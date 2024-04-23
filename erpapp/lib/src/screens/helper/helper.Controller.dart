import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/buttons/buttonLogin.Component.dart';
import 'package:erpcore/components/loading/loading.component.dart';
// import 'package:erpcore/routers/app.Router.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/models/apps/deviceDetail.Model.dart';
import 'package:erpcore/models/apps/internetConnectionInfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/localStorage/dbConnect.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/utility/localStorage/systemConfig.utils.dart';
class HelperController extends GetxController {
  late AppController appController;
  late InternetCnInfoModel internetType;
  late PackageInfo appInfo;
  late DeviceDetails deviceInfo;
  late List<PrCodeName> dbPath;
  late String filesPath;
  TextEditingController txtFromDateController = TextEditingController();
  TextEditingController txtToDateController = TextEditingController();
  bool isSend = false;
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    appController = Get.find();
    internetType = await checkInternetConnection();
    appInfo = await initPackageInfo();
    deviceInfo = await getDeviceDetails();
    dbPath = await DBConnectUility.instance.getDBInfo;
    filesPath = await initializationFolder(SystemConfigUtils.dataFile);
    setUpDate();
  }

  void setUpDate() {
    DateTime dateNow = DateTime.now();
    txtFromDateController.text = DateTimeUtils().dateTimeFormat((dateNow.subtract(const Duration(days: 30))),formatTime: "yyyy-MM-dd");
    txtToDateController.text =  DateTimeUtils().dateTimeFormat(dateNow,formatTime: "yyyy-MM-dd");
  }

  void sendEmail() async {
    try {
      var nowDate = DateTime.now();
      var startDate = DateTime.parse(txtFromDateController.text);
      var endDate = DateTime.parse(txtToDateController.text);
      var pathFile = await AppLogsUtils.instance.getLogsWithFile(
        fromDate: startDate,
        toDate: endDate
      );
      var freeStorage = await getFreeStorage();
      final Email sendEmail = Email(
        body:'BUGS DATA \n- Version : ${appInfo.version.isNotEmpty ? appInfo.version : "1.0.0"} \n - Package name : ${appInfo.packageName} \n - Loại kết nối : ${internetType.connectType} \n - HĐH : ${deviceInfo.systemName} ( Version : ${deviceInfo.systemVersion} ) \n - Dung lượng: ${freeStorage} GB \n - Ghi chú :',
        subject:'[ERP LOGS] ${appController.userProfle.value.userName ?? ""} | ${DateFormat('yyyy-MM-dd HH:mm').format(nowDate)}',
        recipients: ['ittest990@gmail.com'],
        attachmentPaths: pathFile.isNotEmpty ? [pathFile] : [],
        isHTML: false,
      );
      LoadingComponent.show();
      await FlutterEmailSender.send(sendEmail);
      LoadingComponent.dismiss();
    } catch (ex) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(ex, func: "sendEmail helper.Controller");
      AlertControl.push("Không thể soạn email, vui lòng kiểm tra lại",type: AlertType.ERROR);
    }
  }

  Future<void> openModalSelectDate() async {
    await ModalSheetComponent.showBarModalBottomSheet(
      context: Get.context,
      onCancel: (){
        setUpDate();
        Get.back();
      },
      isDismissible: false,
      expand: true,
      formSize: 0.4,
      Container(
        padding: const EdgeInsets.all(10.0),
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextInputComponent (title: "Từ ngày", placeholder: "yyyy-MM-dd",
                      controller: txtFromDateController,
                      enable: false,
                      onTab: () async {
                        onTabChooseDatetion(Get.context!,
                          format: "yyyy-MM-dd",
                          onConfirm: (v) async {
                            txtFromDateController.text = v;
                          },
                          onCancel: ()=>{
                            txtFromDateController.clear()
                          }
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: TextInputComponent (title: "Đến ngày", placeholder: "yyyy-MM-dd",
                      controller: txtToDateController,
                      onTab: () async {
                        onTabChooseDatetion(Get.context!,
                          format: "yyyy-MM-dd",
                          minTime: ((txtFromDateController.text).isNotEmpty)?DateTime.parse(txtFromDateController.text):null,
                          onConfirm: (v) async {
                            txtToDateController.text = v;
                          },
                          onCancel: ()=>{
                            txtToDateController.clear()
                          }
                        );
                      },
                      enable: false,
                    ),
                  ),
                ],
              ),
              ButtonLoginComponent ( btnLabel: "Áp dụng",
                onPressed: () async {
                  seenFiles();
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
      title: "Thời gian",
    );
  }

  Future<File?> handleZipFile(DateTime fromDate, DateTime toDate) async{
    File? file;
    try{
      Directory appDocDirectory = await getTemporaryDirectory();
      String fileName = "data_backup_${appController.userProfle.value.userName}_${convertDateToInt(date: DateTime.now())}.zip";
      String backUpFilePath = "${appDocDirectory.path}/$fileName";
      var encoder = ZipFileEncoder();
      encoder.create(backUpFilePath);
      var archive = Archive();
      // xử lý file db
      LoadingComponent.show(msg: "Đang nén dữ liệu database");
      for (PrCodeName itemPath in dbPath) {        
        if (!PrCodeName.isEmpty(itemPath) && itemPath.name!.isNotEmpty && await File(itemPath.name!).exists()) {
          final bytes = await File(itemPath.name!).readAsBytes();
          final archiveFile = ArchiveFile("${itemPath.codeDisplay}/${p.basename(itemPath.name!)}", bytes.length, bytes);
          archive.addFile(archiveFile);
        }
      }
      // xử lý file hình ảnh
      LoadingComponent.show(msg: "Đang nén dữ liệu hình ảnh");
      var tempDate = DateTime(toDate.year,toDate.month,toDate.day);
      while(DateTimeUtils.compareTo(tempDate, toDate) >=0){
        var fileDir = Directory("$filesPath/${convertDateToInt(date: tempDate)}");
        if(fileDir.existsSync()){
          List<FileSystemEntity> listImage = await fileDir.list(recursive: true).toList();
          for (var image in listImage) {
            if (await image.exists() && image.path.isNotEmpty ) {
              final bytes = await File(image.path).readAsBytes();
              final archiveFile = ArchiveFile(("images/${DateFormat('yyyy-MM-dd').format(tempDate)}/${p.basename(image.path)}"), bytes.length, bytes);
              archive.addFile(archiveFile);
            }
          }
        }
        tempDate =tempDate.subtract(const Duration(days: 1));
      }
  
      LoadingComponent.show(msg: "Đang xử lý file");
      // xử lý file
      final zipEncoder = ZipEncoder();
      final encodedArchive = zipEncoder.encode(archive);
      if (encodedArchive != null && encodedArchive.isNotEmpty){
        file = await File(encoder.zipPath).writeAsBytes(encodedArchive);
      }
      LoadingComponent.dismiss();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleZipFile");
    }
    return file;
  }

  void seenFiles() async {
    try {
      DateTime fromDate = DateTime.parse(txtFromDateController.text);
      DateTime toDate = DateTime.parse(txtToDateController.text);
      DateTime now = DateTime.now();
      File? file = await handleZipFile(fromDate,toDate);
      if(file != null){
        launchShareFile(file,now);
      }
      else{
        LoadingComponent.dismiss();
        AlertControl.push("Có lỗi xảy ra khi nén giữ liệu",type: AlertType.ERROR);
      }
      setUpDate();
    } catch (ex) {
      setUpDate();
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(ex, func: "seenFiles helper.Controller");
      AlertControl.push("Sao lưu thất bại, vui lòng kiểm tra lại!", type: AlertType.ERROR);
    }
  }

  Future<void> launchShareFile(File data, DateTime nowDate) async {
    try {
      LoadingComponent.show(msg: "Đang nén dữ liệu...");
      if (data.existsSync() && data.lengthSync() > 0) {
        List<XFile> listShareData = List.empty(growable: true);
        XFile fileShare = XFile(data.path);
        var lengthFile = await fileShare.length();
        if (lengthFile > 0) {
          listShareData.add(fileShare);
        }
        await Share.shareXFiles(
          listShareData,
          text: 'DATA BACKUP \n- Version : ${appInfo.version.isNotEmpty ? appInfo.version : "1.0.0"} \n - Package name : ${appInfo.packageName} \n - Ghi chú :',
          subject: '[ERP LOGS] ${appController.userProfle.value.userName ?? ""} | ${DateFormat('yyyy-MM-dd HH:mm').format(nowDate)}',
        );
      }
      LoadingComponent.dismiss();
    } catch (ex) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(ex, func: "seenFiles_shareFile helper.Controller");
      AlertControl.push("Không thể chia sẽ file, vui lòng kiểm tra lại", type: AlertType.ERROR);
    }
  }
}
