import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/datas/dateFormatType.Data.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/models/activations/giftAct.Model.dart';
import 'package:erpcore/models/activations/recordInfo.Model.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/deviceDetail.Model.dart';
import 'package:erpcore/models/apps/internetConnectionInfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'localStorage/systemConfig.utils.dart';
import 'package:erpcore/utility/value/customPicker.dart';

List colors = [Colors.red, Colors.green, Colors.yellow];

int randomNumber(int size) {
  Random random = Random();
  return random.nextInt(size);
}

Color randomColor() {
  return colors[randomNumber(3)];
}

  extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    Color result = AppColor.grey;
    try{
      if(hexString.isNotEmpty){
        final buffer = StringBuffer();
        if ((hexString.length == 6 || hexString.length == 7)){
          buffer.write('ff');
        }
        buffer.write(hexString.replaceFirst('#', ''));
        result = Color(int.parse(buffer.toString(), radix: 16));
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fromHex app.Utility");
    }
    return result;
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}'
      '${alpha.toRadixString(16).padLeft(2, '0')}';
  }

Future<PackageInfo> initPackageInfo() async {
  return await PackageInfo.fromPlatform();
}

String generateKeyCode() {
  var uuid = const Uuid();
  return uuid.v1().toString();
}

// get extension by path or url
String checkExtensionFile(String url) {
  try {
    return p.extension(url);
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "checkExtensionFile app.Utility");
    return "orther";
  }
}

List<DataImageActModel> removeNullDataImageInList(List<DataImageActModel> data){
  try {
    data.removeWhere((item) => (item.urlImage == null || (item.urlImage != null && item.urlImage!.isEmpty))  && (item.assetsImage == null || (item.assetsImage != null && item.assetsImage!.isEmpty)));
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "removeNullDataImageInList app.Utility ${jsonEncode(data)}}");
  }
  return data;
}

//
List<DataImageActModel> cloneListDataImage(List<DataImageActModel> data){
  return data.map((v) => v).toList();
}

List<dynamic> cloneList(List<dynamic> data){
  return data.map((v) => v).toList();
}

bool checkIsNull(List<DataImageActModel> data){
  var item = data.firstWhere((item) => (item.urlImage == "" || item.urlImage == null )&& (item.assetsImage == "" || item.assetsImage == null),orElse: ()=>DataImageActModel());
  if(item.sysCode != null && item.sysCode!.isNotEmpty){
    return true;
  }
  else{
    return false;
  }
}

// list video extension
List<String> listVideoExtension = [".3g2",".3gp",".avi",".flv",".h264",".m4v",".mkv",".mov",".mp4",".mpg",".rm",".swf",".vob",".wmv"];
// kiểm tra video
bool isVideoCheck(String fileExtension){
  var result = listVideoExtension.indexOf(fileExtension);
  if(result>-1){
    return true;
  }
  else{
    return false;
  }
}

//get File by memory
Image getFileByMemory(Uint8List byte){
  return Image.memory(byte);
}

String checkFileOrImage(String ext) {
  const extImage = ["png", "jpeg", "jpg", "gif"];
  String result = "file";
  if (extImage.contains(ext.toLowerCase().replaceAll(".", ""))) {
    result = "image";
  }
  return result;
}

String checkFileIsPDF(String ext) {
  const extDocument = ["pdf"];
  String result = "file";
  if (extDocument.contains(ext.toLowerCase().replaceAll(".", ""))) {
    result = "PDF";
  }
  return result;
}

String checkFileIsEXCEL(String ext) {
  const extDocument = ["xlsx"];
  String result = "file";
  if (extDocument.contains(ext.toLowerCase().replaceAll(".", ""))) {
    result = "EXCEL";
  }
  return result;
}

String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

// find item in list Object
int findItemByField(dynamic src, String field, String key) {
  if (src != null) {
    for (int i = 0; i < src.length; i++) {
      if (src[i][field] == key) {
        return i;
      }
    }
    return -1;
  }
  return -1;
}

// validate number phone
bool phoneNumberValidator(String value) {
  if ((value.length == 10 || value.length == 11) && value[0] == '0') {
    try {
      int.tryParse(value);
      return true;
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "phoneNumberValidator app.Utility");
      return false;
    }
  } else {
    return false;
  }
}

String getPlatform() {
  try {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else {
      return "none";
    }
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "getPlatform app.Utility");
    return "none";
  }
}

String convertImageToBase64(String? path) {
  if (path != null && path != "") {
    try {
      var bytesImg = File(path);
      final bytes = bytesImg.readAsBytesSync();
      String img64 = base64Encode(bytes);
      return img64;
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "convertImageToBase64 app.Utility");
      return "";
    }
  }
  return "";
}

Uint8List imageFromBase64String(String base64String) {
  Uint8List bytes = base64Decode(base64String);
  return bytes;
}

File getFileByPath(String? path) {
  late File result;
  if (path != null && path != "") {
    try {
      result = File(Uri.parse(path).path);
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "getFileByPath app.Utility");
    }
  }
  return result;
}

// get Device Info
Future<DeviceDetails> getDeviceDetails() async {
  DeviceDetails deviceInfo = DeviceDetails();
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceInfo.deviceName = build.model;
      deviceInfo.deviceVersion = build.version.toString();
      deviceInfo.identifier = build.androidId; //UUID for Android
      deviceInfo.systemName = 'Android';
      deviceInfo.systemVersion = build.version.release;
      deviceInfo.androidSdk = build.version.sdkInt;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceInfo.deviceName = data.name;
      deviceInfo.deviceVersion = data.systemVersion;
      deviceInfo.identifier = data.identifierForVendor; //UUID for iOS
      deviceInfo.systemName = data.systemName;
      deviceInfo.systemVersion = data.systemVersion;
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
  return deviceInfo;
}

// handle token

//end

// check internet connection
Future<InternetCnInfoModel> checkInternetConnection() async {
  var result = InternetCnInfoModel(connectType: "none", connecting: false);
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    result.connectType = "mobile";
    result.connecting = true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    result.connectType = "wifi";
    result.connecting = true;
  }
  return result;
}

// handle file to DataFile
Future<FormData> convertFileToFromData(List<File> listFile, String fileField) async {
  FormData formData = FormData();
  var _list = List<MultipartFile>.empty(growable: false);
  if (listFile.isNotEmpty) {
    for (var file in listFile) {
      _list.add(MultipartFile.fromFileSync(file.path, filename: file.path));
    }
    // if(_list.length >0){
    //   //formData.files.addAll(_list);
    // }
    return formData;
  } else {
    return formData;
  }
}

// Get location

Future<ResponsesModel> getLocation() async {
  var result = ResponsesModel.create();
  bool serviceEnabled;
  LocationPermission permission;
  String msg="";

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    msg= "vui lòng mở định vị GPS để tiếp tục";
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      msg= "Vui lòng cho phép ứng dụng quyền sử dụng GPS!";
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    msg= "Vui lòng cho phép ứng dụng quyền sử dụng GPS!";
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  if(msg.isEmpty){
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    );
    result.data =position;
    result.statusCode=0;
  }
  else{
    result.msg = msg;
    result.statusCode=1;
  }
  return result;
}

String createPathServer(String? fileUrl, String? fileName) {
  String result = "";
  try {
    String _fileUrl = fileUrl??"";
    String _fileName = fileName??"";
    result = "${getServerName(false)}/$_fileUrl/$_fileName";
    if (fileUrl != null &&  fileUrl.isNotEmpty) {
      if (fileUrl.isNotEmpty && (fileUrl.startsWith("https://") || fileUrl.startsWith("http://"))) {
        result = "$fileUrl/${fileName!}";
      }
    }
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "createPathServer app.Utility");
   
  }
  return result;
}

Future<bool> requirePermission(Permission permission) async {
  try {
    var status = await permission.status;
    if (status.isDenied) {
      var result = await permission.request();
      if (result.isDenied) {
        return false;
      }
      return true;
    }
    return true;
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "requirePermission app.Utility");
    return false;
  }
}

/// // file/ERP/date(yyyy-MM-dd)

Future<String> getFilePath({String ext = ".png"}) async {
  String fileName = generateKeyCode() + ext;
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
  if (Platform.isIOS) {
    appDocumentsDirectory = await getTemporaryDirectory();
  } 
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = "$appDocumentsPath/$fileName"; // 3
  return filePath;
}

Future<void> cleanFileTemp() async {
  try {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    final dir = Directory(appDocumentsPath);
    dir.deleteSync(recursive: true);
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "cleanFileTemp app.Utility");
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');
  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
    .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
}

/// this will delete cache
Future<void> deleteCacheDir() async {
  final cacheDir = await getTemporaryDirectory();
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}

/// this will delete app's storage
Future<void> deleteAppDir() async {
  final appDir = await getApplicationSupportDirectory();
  if (appDir.existsSync()) {
    appDir.deleteSync(recursive: true);
  }
}

  Future<String> recordAudio({int status=0,String shopId=""}) async{
    late String result = "false";
    bool recordStatus = await Record().hasPermission();
    if(recordStatus && status ==0){
      if(!await Record().isRecording() && !await Record().isPaused())
      {
        Random dn = Random();
        Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
        String appDocumentsPath = appDocumentsDirectory.path; // 2
        String filePath = "$appDocumentsPath/${convertDateToInt(date: DateTime.now())}/${shopId}_${convertDateToInt(date: DateTime.now())}${dn.nextInt(5)}.mp4"; // 3
        Record().start(path: filePath,encoder: AudioEncoder.aacLc);
        result= "true";
      }
      else{
        AlertControl.push("Microphone đang được sử dụng, kiểm tra lại", type: AlertType.ERROR);
      }
    }
    else if(status ==1){
      result = (await Record().stop())!;
    }
    else{
      AlertControl.push("Không có quyền ghi âm", type: AlertType.ERROR);
    }
    return result;
  }

  Future<dynamic> sendCommandRecordService(String command,{int status=0,String shopId="",bool editPath=true}) async {
    const platform = MethodChannel('erp.native/helper');
    try {
      if(Platform.isIOS){
        var result = await recordAudio(status: status,shopId: shopId);
        if(result == "true"){
          return "OK";
        }
        else if(result == "false"){
          return null;
        }
        else{
          return result;
        }
      }
      else if(Platform.isAndroid){
        var result = await platform.invokeMethod(command,{'status':status,'shopId':shopId});
        if(command == "recordReceiver" && (result == null || result == "")){
          var pathStorage = await getExternalStorageDirectory();
          result = "${pathStorage!.path}/ERP/${convertDateToInt(date: DateTime.now())}/";
        }
        else if(command == "recordReceiver" && editPath && (result != null && result != "")){
          result =result+"/"+ DateFormat('yyyy-MM-dd').format(DateTime.now())+"/";
        }
        return result;
      }
    } on PlatformException catch (ex) {
      print(ex);
      AppLogsUtils.instance.writeLogs(ex,func: "sendCommandRecordService app.Utility");
      return null;
    }
  }

  Future<bool> getLensInfoByCameraId(String cameraId) async {
    var isWideCamera = false;
    try {
      if(Platform.isAndroid){
        MethodChannel channel = const MethodChannel('erp.native/helper');
        final bool lensType = await channel.invokeMethod('getCameraLensType', {'cameraId':cameraId});
        isWideCamera = lensType; // true = wide cam
      }
      else if(Platform.isIOS){
        const MethodChannel channel = MethodChannel('erp.native/helper');
        String lensInfo = await channel.invokeMethod('getCameraLensType', {'cameraId':cameraId});
        if(lensInfo != "null"){
          lensInfo = lensInfo.replaceAll("[", "{");
          lensInfo = lensInfo.replaceAll("]", "}");
          var temp = jsonDecode(lensInfo);
          double wideAngleThreshold = 60.0;
          double fieldOfView = (temp["fieldOfView"]??0.0);
          if(fieldOfView < wideAngleThreshold){
            //isWideCamera= true;
          }
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getBackCameraLensType cameraView_Controller");
    }
    return isWideCamera;
  }

  Future<double> getFreeStorage() async{
    double result = -1;
    try{
      const platform = MethodChannel('erp.native/helper');
      var _temp = await platform.invokeMethod('getFreeStorage');
      result = double.parse(_temp)/(1000000000);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getFreeStorage");
    }
    return result;
  }

  Future<String> initializationFolder(String folderName) async {
    String path = "";
    Directory? baseDir = await getApplicationSupportDirectory();
    try{
      baseDir = await getApplicationDocumentsDirectory(); //works for both iOS and Android
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getApplicationDocumentsDirectory error Android");
    }
    if(baseDir != null){
      String dirFarther = await createFolder(baseDir.path,"ERPDATA");
      if(dirFarther.isNotEmpty){
        String dirChilrend = await createFolder(dirFarther,folderName);
        path = dirChilrend;
      }
    }
    return path;
  }

  Future<String> createFolder(String pathSrc,String folderName) async{
    String path ="";
    try{
      if(pathSrc.isNotEmpty){
        String dir = p.join(pathSrc, folderName);
        var dirFolder = Directory(dir);
        bool dirFartherExists = await dirFolder.exists();
        if(!dirFartherExists){
          dirFolder.create(); //pass recursive as true if directory is recursive
        }
        path= dirFolder.path;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "createFolder app.Utility");
    }
    return path;
  }
  
String convertWindowPathToURL(String srcPath) {
  String result = "";
  result = srcPath.replaceAll("\\", "/");
  return result;
}

String getFolderPathByFile(String? filePath){
  String pathFolder ="";
  try{
    if(filePath != null){
      int index =-1;
      for(var i = filePath.length-1; i>=0;i--){
        if(filePath[i] == "/"){
          index = i;
          break;
        }
      }
      if(index >0){
        pathFolder = filePath.substring(0,index);
      }
    }
  }
  catch(ex){
    AppLogsUtils.instance.writeLogs(ex,func: "getFolderPathByFile app.Utility");
  }
  return pathFolder;
}

Future<List<FileSystemEntity>> getAllFileInFolder(String pathFolder,{String? sortName}) async{
  List<FileSystemEntity> folders = List<FileSystemEntity>.empty(growable: true);
  try{
    final myDir = Directory(pathFolder);
    var tempFolder = myDir.listSync(recursive: true, followLinks: false);
    if(sortName != null && sortName.isNotEmpty){
      folders = tempFolder.where((element) => element.path.contains(sortName)).toList();
    }
    else{
      folders = tempFolder;
    }
  }
  catch(ex){
    AppLogsUtils.instance.writeLogs(ex,func: "getAllFileInFolder app.Utility");
  }
  return folders;
}

void onTabChooseDatetion(BuildContext context,{ VoidCallback? onCancel,Function(String)? onConfirm,DateTime? maxTime,DateTime? minTime,DateFormatType type = DateFormatType.DATE, DateTime? currentTime,String format ="", bool isCustomPicker = false}){
    var _themeConfig = DatePickerThemeBdaya(
      headerColor: const Color(0xFF512DA8),
      itemStyle: TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.bold,
      fontSize: 18),
      cancelStyle: const TextStyle(color: Colors.white, fontSize: 15),
      doneStyle:const TextStyle(color: Colors.white, fontSize: 18)
    );
    // xử lý loại input
    if (isCustomPicker) {
      DatePickerBdaya.showPicker(context, showTitleActions: true,
          theme: _themeConfig,
          locale: LocaleType.vi,
          onCancel: (){
            if(onCancel != null) {
              onCancel();
            }
          },
          onChanged: (date) {
            print('change $date in time zone ${date.timeZoneOffset.inHours}');
          }, 
          onConfirm: (date) 
          {
            var tempDate = DateFormat(format.isEmpty?'yyyy-MM-dd HH:mm':format).format(date);
            if(onConfirm != null){
              onConfirm(tempDate);
            }
          }, 
        pickerModel: CustomPicker(currentTime: DateTime.now()));
    } else if(type == DateFormatType.DATE){
      DatePickerBdaya.showDatePicker(context,
        showTitleActions: true,
        minTime: minTime??DateTime(1900, 0, 0),
        maxTime: maxTime??DateTime(2100, 0, 0),
        theme: _themeConfig,
        onCancel: (){
          if(onCancel != null) {
            onCancel();
          }
          },
          onChanged: (date) {
            print('change $date in time zone ${date.timeZoneOffset.inHours}');
          }, 
          onConfirm: (date) 
          {
            var tempDate = DateFormat(format.isEmpty?'yyyy-MM-dd':format).format(date);
            if(onConfirm != null){
              onConfirm(tempDate);
            }
          }, 
          currentTime: currentTime ?? DateTime.now(), locale: LocaleType.vi,
      );
    }
    else if(type == DateFormatType.DATETIME){
      DatePickerBdaya.showDateTimePicker(context,
        showTitleActions: true,
        minTime: minTime??DateTime(1900, 0, 0),
        maxTime: maxTime??DateTime(2100, 0, 0),
        theme: _themeConfig,
        onCancel: (){
          if(onCancel != null){
            onCancel();
          }
        },
        onChanged: (date) {
          print('change $date in time zone ${date.timeZoneOffset.inHours}');
        }, 
        onConfirm: (date) 
        {
          var tempDate = DateFormat(format.isEmpty?'yyyy-MM-dd HH:mm':format).format(date);
          if(onConfirm != null){
            onConfirm(tempDate);
          }
        }, 
        currentTime: currentTime ?? DateTime.now(), locale: LocaleType.vi,
      );
    }
    else if(type == DateFormatType.TIME){
      DatePickerBdaya.showTimePicker(context,
        showTitleActions: true,
        showSecondsColumn: false,
        theme: _themeConfig,
        onCancel: (){
          if(onCancel != null){
            onCancel();
          }
        },
        onChanged: (date) {
          print('change $date in time zone ${date.timeZoneOffset.inHours}');
        }, 
        onConfirm: (date) 
        {
          var tempDate = DateFormat(format.isEmpty?'HH:mm':format).format(date);
          if(onConfirm != null){
            onConfirm(tempDate);
          }
        }, 
        currentTime:currentTime ?? DateTime.now(), locale: LocaleType.vi,
      );
    }
  }

  int convertDateToTicks(DateTime date){
    const epochTicks = 621356220000000000;
    int result =0;
    try{
     result = date.millisecondsSinceEpoch * 10000 + epochTicks;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "convertDateToTicks app.Utility");
    }
    return result;
  }

  DateTime convertTicksToDate(int ticks){
    DateTime result = DateTime(DateTime.now().year);
    const epochTicks = 621356220000000000;
    try {
      result =  DateTime.fromMillisecondsSinceEpoch((ticks-epochTicks)~/10000);
    } 
    catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "convertTicksToDate app.Utility");
    }
    return result;
  }

  extension DateOnlyCompare on DateTime {
    bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
    }
  }

    // định dạng thời gian
  String datetimeDisplayHandle({String formatDate ="yyyy-MM-dd HH:mm",String? dateTimeStringInput,DateTime? dateTimeInput}){
    String result ="n.a";
    try{
      final format = DateFormat(formatDate);
      if(dateTimeStringInput != null  && dateTimeStringInput.isNotEmpty){
          result =format.format(DateTime.parse(dateTimeStringInput));
      }
      else if(dateTimeInput != null){
        result =format.format(dateTimeInput);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "datetimeDisplayHandle app.Utility");
    }
    return result;
  }

  int convertDateToInt({String? dateString,DateTime? date}){
    int result=0;
    try{
      if(dateString != null){
        if(dateString.isNotEmpty){
          var _date = DateTime.parse(dateString);
          result = int.parse(DateFormat('yyyyMMdd').format(_date));
        }
      }
      else if(date != null){
        result = int.parse( DateFormat('yyyyMMdd').format(date));
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "convertDateToInt app.Utility");
    }
    return result;
  }

  String convertIntToDate(String date) {
    String result ="";
    try{
      var _data = date.toString();
      String year = _data.substring(0, 4);
      String month = _data.substring(4, 6);
      String day = _data.substring(6, 8);
      result = "$year-$month-$day";
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "convertIntToDate app.Utility");
    }
    return result;
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  Future<bool> internetConnectionChecking()async{
    bool result = false;
    try {
      final onlineResult = await InternetAddress.lookup('google.com');
      if (onlineResult.isNotEmpty && onlineResult[0].rawAddress.isNotEmpty) {
        result = true;
      }
    } on SocketException catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "onlineChecking app.Utility");
      result = false;
    }
    return result;
  }
  // fileName --> dùng để backup
  Future<File> moveFile(File sourceFile, String newPath,{String? fileName}) async {
    File result = sourceFile;
    String _newPath=Uri.parse(newPath).path;
    try {
      try{
        final newFile = await sourceFile.copy(_newPath);
        if(newFile.existsSync()){
          await sourceFile.delete();
          result= newFile;
        }
        else{
          result = renameFile(sourceFile,fileName??""); // nếu không thể copy file --> rename file lưu tạm thành tên file có cấu trúc
        }
      }
      catch(ex){
        result = renameFile(sourceFile,fileName??""); // nếu không thể copy file --> rename file lưu tạm thành tên file có cấu trúc
        AppLogsUtils.instance.writeLogs(ex,func: "moveFile 1");
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "moveFile 2");
    }
    return result;
  }

  Future<File> copyFile(File oldFile,{String? fileName}) async{
    File result = oldFile;
    try{
      if(oldFile.existsSync()){
        String fileExtension = p.extension(oldFile.path);
        var cacheDir = await getTemporaryDirectory();
        if(fileName == null || fileName.isNotEmpty){
          fileName = generateKeyCode()+fileExtension;
        }
        File newImage = await oldFile.copy('${cacheDir.path}/$fileName');
        if(newImage.existsSync()){
          result = newImage;
        }
      }
      else{
        AppLogsUtils.instance.writeLogs("oldFile not exists",func: "copyFile");
      }

    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "copyFile");
    }
    return result;
  }

  File renameFile(File oldFile,String fileName){
    File result = oldFile;
    try{
      String dir = p.dirname(Uri.parse(oldFile.path).path);
      String temp = p.join(dir, fileName);
      if(temp.isNotEmpty && File(temp).existsSync()){
        result = oldFile.renameSync(temp);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "renameFile");
    }
    return result;
  }

  String getUnitNumber(dynamic number) {
    String result = "";
    try {
      // String numberOfText = ((number as double).toInt()).toString();
      String numberOfText = (number).toString();
      switch (numberOfText.length) {
        case 4:
          result = "k";
          break;
        case 5:
          result = "k";
          break;
        case 6:
          result = "k";
          break;
        case 7:
          result = "tr";
          break;
        case 8:
          result = "tr";
          break;
        case 9:
          result = "tr";
          break;
        case 10:
          result = "tỷ";
          break;
        case 11:
          result = "tỷ";
          break;
        case 12:
          result = "tỷ";
          break;
        case 13:
          result = "tỷ";
          break;
        case 14:
          result = "tỷ";
          break;
      }
    } catch (ex) {
      print(ex);
      AppLogsUtils.instance.writeLogs(ex,func: "getUnitNumber app.Utility");
    }
    return result;
  }

  String compactNumberToText(dynamic number ,{int asFixed = 2}) {
    String result = "0";
    try {
      int divisor = 1;
      // int length = ((number as double).toInt()).toString().length;
      int length = (number).toString().length;
      if (length > 3 && length < 7) {
        divisor = 1000;
      // } else if (length <= 6) {
      //   divisor = 100000;
      } 
      else if (6 < length && length < 10) {
        divisor = 1000000;
      } else if (9 < length) {
        divisor = 1000000000;
      }
      result = (number / divisor).toStringAsFixed(asFixed);
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "compactNumberToText app.Utility");
    }
    return result;
  }

  String formatNumberDouble(double? number) {
    String result = "";
    try {
      number ??= 0.0;
      double fraction = number - number.truncate();
      if (fraction == 0) {
        result = "${number.truncate()}";
      } else {
        result = "$number";
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "formatNumberDouble");
    }
    return result;
  }

  // nếu type = true --> trả về url có gắn api và ngược lại
  String getServerName(bool type,{bool byPackageName=false}) {
    String result = AppServiceAPIData.acaHostURL;
    try{
      if(byPackageName){
        var temp = PreferenceUtility.getString("rootHostURL");
        if(temp.isNotEmpty){
          result = temp;
        }
      }
      else{
        if(AppConfig.appPackageName == PackageName.acacyPackage){
          result = AppServiceAPIData.acaHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.spiralPackage || AppConfig.appPackageName == PackageName.spiralv2Package){
          result = AppServiceAPIData.spiHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.heinekenAuditPackage || AppConfig.appPackageName == PackageName.heinekenPackage || AppConfig.appPackageName == PackageName.heinekenMTPackage){
          result = AppServiceAPIData.heinekenHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.abbottv2Package || AppConfig.appPackageName == PackageName.abbottPackage){
          result = AppServiceAPIData.abbottHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.marsPackage){
          result = AppServiceAPIData.marsHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.demoAcacyPackage){
          result = AppServiceAPIData.demoAcacyHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.pepsiPackage){
          result = AppServiceAPIData.pepsiHostURL;
        }
         else if(AppConfig.appPackageName == PackageName.chupachupsPackage){
          result = AppServiceAPIData.chupachupsHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.demoSpiralPackage){
          result = AppServiceAPIData.demoSpiralHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.sabecoAcacyPackage){
          result = AppServiceAPIData.sabecoAcacyHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.jtiPackage){
          result = AppServiceAPIData.jtiAcacyHostURL;
        }
        else if(AppConfig.appPackageName == PackageName.pernodPackage){
          result = AppServiceAPIData.pernodAcacyHostURL;
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getServerName app.Utility");
    }
    if(PreferenceUtility.getBool(AppKey.keyDevMode)){
      var temp = PreferenceUtility.getString(AppKey.keyServerDevModeURL);
      if(temp.isNotEmpty){
        result = temp;
      }
    }
    //result = "https://jtiuatapi.acacy.com.vn/";
    if(type){
      return "$result/api";
    }
    else{
      return result;
    } 
  }
  
Future<bool> updateRecordStatus(RecordInfoModel value) async {
  var temp = jsonEncode(value.toJson());
  return PreferenceUtility.saveString(AppServiceAPIData.actRecordKey, temp);
}

Future<RecordInfoModel> getRecordStatus() async {
  var result = RecordInfoModel(workingPlanCode: "",createdAt: DateTime.now(),status: false,shopName: "");
  try{
    var temp = PreferenceUtility.getString(AppServiceAPIData.actRecordKey);
    var resultJson = jsonDecode(temp);
    result = RecordInfoModel.fromJson(resultJson);
  }
  catch(ex){
    AppLogsUtils.instance.writeLogs(ex,func: "getRecordStatus appUtils");
  }
  return result;
}
List<DataImageActModel> mergeImageDataV2(List<DataImageActModel> localData,List<DataImageActModel> networkData){
  List<DataImageActModel> result = List<DataImageActModel>.empty(growable: true);
  try{
    for(var item in localData){
      if((item.assetsImage != null && item.assetsImage!.isNotEmpty || (item.urlImage != null && item.urlImage!.isNotEmpty))){
        var index = result.indexWhere((element) => ((element.assetsImage != null && element.assetsImage!.isNotEmpty) &&  element.assetsImage == item.assetsImage) || ((element.urlImage != null && element.urlImage!.isNotEmpty) && element.urlImage == item.urlImage));
        if(index <0){
          result.add(item);
        }
      }
    }
    for(var item in networkData){
      if((item.assetsImage != null && item.assetsImage!.isNotEmpty || (item.urlImage != null && item.urlImage!.isNotEmpty))){
        var index = result.indexWhere((element) => ((element.assetsImage != null && element.assetsImage!.isNotEmpty) &&  element.assetsImage == item.assetsImage) || ((element.urlImage != null && element.urlImage!.isNotEmpty) && element.urlImage == item.urlImage));
        if(index <0){
          result.add(item);
        }
      }
    }
    result.sort((a, b) => a.createdAt!.lD!.compareTo((b.createdAt!.lD)!));
  }
  catch(ex){
    AppLogsUtils.instance.writeLogs(ex,func: "mergeImageData v2");
  }
  return result;
}
List<DataImageActModel> mergeImageData(List<DataImageActModel> localData,List<DataImageActModel> networkData, int maxSize,{bool isRemoveAssetFile=false}){
  List<DataImageActModel> result = List<DataImageActModel>.empty(growable: true);
  try{
    if(isRemoveAssetFile){
      localData.removeWhere((element) => (element.assetsImage != null && element.assetsImage!.isNotEmpty && (element.urlImage == null || element.urlImage!.isEmpty)));
      networkData.removeWhere((element) => (element.assetsImage != null && element.assetsImage!.isNotEmpty && (element.urlImage == null || element.urlImage!.isEmpty)));
    }
    for(var item in localData){
      if((item.assetsImage != null && item.assetsImage!.isNotEmpty || (item.urlImage != null && item.urlImage!.isNotEmpty))){
        var index = result.indexWhere((element) => ((element.assetsImage != null && element.assetsImage!.isNotEmpty) &&  element.assetsImage == item.assetsImage) || ((element.urlImage != null && element.urlImage!.isNotEmpty) && element.urlImage == item.urlImage));
        if(index <0){
          result.add(item);
        }
      }
    }
    for(var item in networkData){
      if((item.assetsImage != null && item.assetsImage!.isNotEmpty || (item.urlImage != null && item.urlImage!.isNotEmpty))){
        var index = result.indexWhere((element) => ((element.assetsImage != null && element.assetsImage!.isNotEmpty) &&  element.assetsImage == item.assetsImage) || ((element.urlImage != null && element.urlImage!.isNotEmpty) && element.urlImage == item.urlImage));
        if(index <0){
          result.add(item);
        }
      }
    }

    result.sort((a, b) => a.createdAt!.lD!.compareTo((b.createdAt!.lD)!));
    if(maxSize <=0 || (result.length < maxSize)){
      result.insert(0,DataImageActModel(sysCode: generateKeyCode(), createdAt: PrDate()));
    }
  }
  catch(ex){
    AppLogsUtils.instance.writeLogs(ex,func: "mergeImageData");
  }
  return result;
}

List<DataImageActModel> mergeAudioData(List<DataImageActModel> localData,bool removeAssetsItem) {
 if(removeAssetsItem){
  localData.removeWhere((element) => (element.assetsImage != null && element.assetsImage!.isNotEmpty && (element.urlImage == null ||element.urlImage!.isEmpty)));
 }
 return localData;
}

List<ItemSelectDataActModel> mergeSelectData(List<ItemSelectDataActModel>? selectResult,List<ItemSelectDataActModel>? selectSrc) {
 
  List<ItemSelectDataActModel> result = List<ItemSelectDataActModel>.empty(growable: true);
  try{
    selectSrc ??= List<ItemSelectDataActModel>.empty(growable: true);
    selectResult ??= List<ItemSelectDataActModel>.empty(growable: true);
    for(var item in selectSrc){
      var _temp = selectResult.indexWhere((e)=> e.code?.compareTo(item.code??"")==0);
      if(_temp>-1){
        item.isChoose = selectResult[_temp].isChoose;
      }
      result.add(item);
    }
  }
  catch(ex){
    AppLogsUtils.instance.writeLogs(ex,func: "mergeSelectData app.Utility");
  }
  return result;
}

// // Xáo trộ các phần quà
List<GiftActModel> randomizeGift(List<GiftActModel> giftSrc,int length){
  if(giftSrc.isEmpty){
    return [];
  }
  else
  {
    var _temp = giftSrc.map((v) => v).toList();
    int _tempLength = giftSrc.length;
    while(_tempLength <length)
    {
      _temp.add(giftSrc[randomNumber(giftSrc.length)]);
      _tempLength++;
    }
    return _temp;
  }
}


// xử lý file khi lưu offline 
Future<List<DataImageActModel>> handleFileOffile(List<DataImageActModel> src) async{
  List<DataImageActModel> result = List<DataImageActModel>.empty(growable: true);
  try{
    for(var item in src){
      if((item.assetsImage != null && item.assetsImage!.isNotEmpty)){
        var temp = await SystemConfigUtils.writeFile(item.assetsImage??"");
        if(temp.isNotEmpty){
          item.assetsImage = temp;
          result.add(item);
        }
      }
    }
  }
  catch(ex){
    AppLogsUtils.instance.writeLogs(ex,func: "handleFileOffile app.Utility");
  }
  return result;
}

String handURLFilePrFileUpload(PrFileUpload? file) {
  String result = "";
  try {
    if (file != null) {
      if ((file.fileUrl??"").contains("http")) {
        result = "${file.fileUrl!}/${file.fileName!}";
      } else {
        var pathFolder = convertWindowPathToURL(file.fileUrl??"");
        result = "${getServerName(false)}$pathFolder/${file.fileName!}";
      }
    }
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "handURLFilePrFileUpload app.Utility");
  }
  return result;
}

String handURLImageString(String? file) {
  String result = "";
  try {
    if (file != null) {
      if (file.contains("http")) {
        result = file;
      } else {
        result = getServerName(false) + file;
      }
    }
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "handURLImageString app.Utility");
  }
  return result;
}

  String formatStringCurrency(String number) {
    String result = "";
    try {
      var fraction = number.split(".");
      if (fraction.isNotEmpty && fraction.length == 2) {
        int? fractionNumber = int.tryParse(fraction.last);
        if (fractionNumber != null ) {
          if (fractionNumber == 0) {
            result = fraction.first;
          } else {
            result = number;
          }
        } else {
          result = number;
        }
      } else {
        result = number;
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "formatStringCurrency");
    }
    return result;
  }

Future<String> getEncodeTraining({UserInfoModel? userProfle}) async {
    DeviceDetails device = await getDeviceDetails();
    var token = PreferenceUtility.getString(AppKey.keyERPToken);
    Map<String, dynamic> map = {};
    map['AccountId'] = 0;
    map['CoachingID'] = '';
    map['DeviceID'] = device.identifier != null && device.identifier!.isNotEmpty ? device.identifier : "1234567";
    map['EmployeeId'] = (userProfle != null && userProfle.sysCode != null)?userProfle.sysCode:"";
    map['LoginID'] = '';
    map['LoginIDForRP'] = '';
    map['ErpToken'] = token;
    var jsonTemp = json.encode(map);
  return base64Encode(utf8.encode(jsonTemp));
}

Future<File?> compressImage(File file,{int quality =40,int minWidth =1024,int minHeight = 640}) async {
  final filePath = file.absolute.path;
  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, outPath,
    quality: quality,minWidth: minWidth,minHeight: minHeight, 
  );
  return result;
 }

 Future<void> openNavigationMap(double currentLatitude, double currentLongitude,double? latitude, double? longitude) async {
    String googleUrl = "https://www.google.com/maps/dir/?api=1&origin=$currentLatitude,$currentLongitude&destination=$latitude,$longitude&travelmode=driving&dir_action=navigate";
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl),mode: LaunchMode.externalApplication);
    } else {
      AlertControl.push("Không thể mở ứng dụng bản đồ, vui lòng kiểm tra thiệt bị của bạn!", type: AlertType.ERROR);
    }
  }

  Future<void> openNavigatePhone(String phoneNumber) async {
    final Uri _phoneUri = Uri(
        scheme: "tel",
        path: phoneNumber
    );
    try {
      if (await canLaunchUrlString(_phoneUri.toString())) {
        await launchUrlString(_phoneUri.toString());
      }
    } catch (error) {
      throw("Không thể chuyển cuộc gọi, vui lòng kiểm tra thiệt bị của bạn!");
    }
  }

  String convertToASCII(String text,{bool removeSpace = false}) {
    const vietnamese = 'àáảãạâầấẩẫậăằắẳẵặèéẻẽẹêềếểễệđìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵÀÁẢÃẠÂẦẤẨẪẬĂẰẮẲẴẶÈÉẺẼẸÊỀẾỂỄỆĐÌÍỈĨỊÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢÙÚỦŨỤƯỪỨỬỮỰỲÝỶỸỴ';
    const ascii = 'aaabaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaamaaanaaaoaaapaaaqaaaraaasaaataaauaaavaaawaaaxaaayaaazababbbabdbabebabfbabgbabhbibjbibkbablbabmbabnbabobabpbabqbabrbabsbabtbabubabvbabwabxabzacacbdaceacfacgachaciacjackaclacmacnacodcpacqacracubabscactacuacvacwacyadadbadeadfadgadhadiadajadsladmadnadoadpadqadradsadtadubabvadwadxadzafagdahgaiagjagkaglagMagNagOagPagqagragsagtaguagvagwagxagyahaahhahiahjahkahlahmahnahoahpahqahrahsahtahuahvahwahxahy';

    // Map Vietnamese to equivalent ASCII  
    var map = <String, String>{};
    for (var i = 0; i < vietnamese.length; i++) {
      map[vietnamese[i]] = ascii[i]; 
    }
    // Replace Vietnamese characters with ASCII equivalents
    var result = '';
    for (var char in text.split('')) {
      if (map.containsKey(char)) {
        result += map[char]!;
      } else {
        result += char; 
      }
    }
    if(removeSpace){
      result = result.replaceAll(" ", "");
    }
    return result;
  }

  String getChatChannelByServer(){
    String result = AppServiceAPIData.chatChannelAcacy;
    try{
      switch(getServerName(false)){
        case "https://erpapi.spiral.com.vn/":
          result = AppServiceAPIData.chatChannelSpiral;
        break;
        default:
          result = AppServiceAPIData.chatChannelAcacy;
        break;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getChatChannelByServer main.Controller");
    }
    return result;
  }

  Future<bool> checkGPSStatus() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    return isServiceEnabled;
  }

  String getLocalPathByType(String path,{String type = SystemConfigUtils.dataDB}) {
    String result = "";
    try{
      List<String> temps = p.split(path);
      int startIndex = temps.lastIndexWhere((element) => element == type);
      int endIndex = temps.length-1;
      for(int i=startIndex+1; i<=endIndex;i++){
        result += temps[i];
        if(i<endIndex){
          result += "/";
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getPathDB");
      result =path;
    }
    return result;
  }

  String getKeyWordByList(List<PrCodeName> data){
    String result = "";
    int length =  data.length;
    for(int i = 0;i< length;i++){
      if(data[i].code != null && data[i].code!.isNotEmpty){
        result+= data[i].code??"";
        if(i<length-1){
          result+=",";
        }
      }
      
    }
    return result;
  }

