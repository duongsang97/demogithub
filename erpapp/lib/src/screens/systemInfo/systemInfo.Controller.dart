
// ignore_for_file: avoid_types_as_parameter_names

import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:intl/intl.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/components/buttons/buttonLogin.Component.dart';
import 'dart:io';
import 'package:erpcore/utility/storage.Utility.dart';
import 'package:path/path.dart' as p;
import 'package:erpcore/utility/localStorage/systemConfig.utils.dart';
import 'package:activation/utils/localStorage/actStorageMng.utils.dart';

class SystemInfoController extends GetxController{
  RxList<charts.Series<PrCodeName, String>> pieChartSizeApp = RxList.empty(growable: true);
  RxList<charts.Series<PrCodeName, String>> barChartSizeApp = RxList.empty(growable: true);
  List<PrCodeName> listBarData = List.empty(growable: true);
  Rx<PackageInfo> packageInfo = PackageInfo(appName: 'Unknown',packageName: 'Unknown',version: 'Unknown',buildNumber: 'Unknown',).obs;
  RxDouble freeStorage = 0.0.obs;
  RxString dbStorage = "0.0".obs;
  RxString filesStorage = "0.0".obs;
  RxInt appSize = 0.obs;
  TextEditingController txtFromDateController = TextEditingController();
  TextEditingController txtToDateController = TextEditingController();
  TextEditingController txtFromDateDeleteController = TextEditingController();
  TextEditingController txtToDateDeleteController = TextEditingController();
  late String filesPath;
  late String dbPath;
  List<DateTime> listTime = List.empty(growable: true);
  Rx<PrCodeName> logo = PrCodeName(code: "0", name: AppConfig.logoERP).obs;
  RxBool isLoading = false.obs;
  late AppController appController;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await initPackageInfo();
    appController = Get.find();
    filesPath = await initializationFolder(SystemConfigUtils.dataFile);
    dbPath = await initializationFolder(SystemConfigUtils.dataDB);
    setUpDate();
    getLogo();
    await getStorage();
    getAppSizeUse();
    pieChartSizeApp.value = await createPieChart() ?? [];
    await loadTimeFilter();
  }

  Future<void> getLogo() async {
    try {
      String tempLogo = await SystemConfigUtils.getConfigByKey(AppData.logoWelcome);
      if(File(tempLogo).existsSync() && checkFileOrImage(p.extension(tempLogo)) == "image"){
        logo.value.name = tempLogo;
        logo.value.code = "1";
      }
      logo.refresh();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getLogo");
    }
    
  }

  void getAppSizeUse() async{
    try {
      double dbStorageBytes = await StorageUtility.getSizeDBStorage(dbPath);
      dbStorage.value = formatBytes(dbStorageBytes.toInt(), 2);
      double filesStorageBytes = await StorageUtility.getSizeFilesStorage(filesPath);
      appSize.value = (dbStorageBytes + filesStorageBytes).toInt();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getAppSizeUse");
    }
  }

  void setUpDate() async {
    try {
      DateTime dateNow = DateTime.now();
      txtFromDateController.text = DateFormat('yyyy-MM-dd').format(DateTime(dateNow.year, dateNow.month, dateNow.day).subtract(const Duration(days: 10)));
      txtToDateController.text = DateFormat('yyyy-MM-dd').format(DateTime(dateNow.year, dateNow.month, dateNow.day));
      txtFromDateDeleteController.text = DateFormat('yyyy-MM-dd').format(DateTime(dateNow.year, dateNow.month, dateNow.day).subtract(const Duration(days: 10)));
      txtToDateDeleteController.text = DateFormat('yyyy-MM-dd').format(DateTime(dateNow.year, dateNow.month, dateNow.day).subtract(const Duration(days: 7)));
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "setUpDate");
    }
  }

  Future<void> getStorage() async {
    try {
      LoadingComponent.show(msg: "Đang tính dung lượng hệ thống...");
      freeStorage.value = await getFreeStorage();
      double dbStorageBytes = await StorageUtility.getSizeDBStorage(dbPath);
      dbStorage.value = formatBytes(dbStorageBytes.toInt(), 2);
      double filesStorageBytes = await StorageUtility.getSizeFilesStorage(filesPath);
      filesStorage.value = formatBytes(filesStorageBytes.toInt(), 2);
      LoadingComponent.dismiss();
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "getStorage");
    }
  }

  Future<void> initPackageInfo() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      packageInfo.value = info;
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "initPackageInfo");
    }
  }

  Future<List<charts.Series<PrCodeName, String>>?> createBarChart() async {
    try {
      return [
        charts.Series<PrCodeName, String>(
          id: 'BarSize',
          domainFn: (PrCodeName size, _) => size.name ?? "",
          measureFn: (PrCodeName size, _) => int.tryParse(size.codeDisplay ?? ""),
          data: listBarData,
          labelAccessorFn: (PrCodeName row, _) => '${row.name}: ${formatBytes((int.tryParse(row.codeDisplay!) != null ? int.parse(row.codeDisplay ?? "") : 0), 2)}',
          fillPatternFn: (_,__)=>charts.FillPatternType.solid,
          colorFn: (data, num) {
            return charts.Color.fromHex(code: '#00BFFF');
          },
        )
      ];
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "createBarChart");
    }
    return null;
  }

  int convertGBtoBytes(int value) {
    return value * 1073741824;
  }

  Future<List<charts.Series<PrCodeName, String>>?> createPieChart() async {
    try {
      LoadingComponent.show(msg: "Đang tính dung lượng ứng dụng...");
      List<PrCodeName> sizePieChart = List<PrCodeName>.empty(growable: true);
      double dbStorageBytes = await StorageUtility.getSizeDBStorage(dbPath);
      double filesStorageBytes = await StorageUtility.getSizeFilesStorage(filesPath);
      sizePieChart.add(PrCodeName(name: "Dung lượng còn lại",codeDisplay: "${convertGBtoBytes(freeStorage.value.toInt())}",)); 
      sizePieChart.add(PrCodeName(name: "Dung lượng app sử dụng",codeDisplay: '${dbStorageBytes.toInt() + filesStorageBytes.toInt()}',)); 
      sizePieChart.add(PrCodeName(name: "Dữ liệu DB",codeDisplay: "${dbStorageBytes.toInt()}",)); 
      sizePieChart.add(PrCodeName(name: "Dữ liệu khác",codeDisplay: "${filesStorageBytes.toInt()}",)); 
      LoadingComponent.dismiss();
      return [
        charts.Series<PrCodeName, String>(
          id: 'Pie',
          domainFn: (PrCodeName size, _) => size.name ?? "",
          measureFn: (PrCodeName size, _) => int.tryParse(size.codeDisplay ?? ""),
          data: sizePieChart,
          colorFn: (data, num) {
            if (num == 0) {
              return charts.Color.fromHex(code: '#00BFFF');
            }
            if (num == 1) {
              return charts.Color.fromHex(code: '#00FF00');
            } 
            if (num == 2) {
              return charts.Color.fromHex(code: '#FFA500');
            }
            return charts.Color.fromHex(code: '#FF6347');
          },
        )
      ];
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "createPieChart");
    }
    return null;
  }

  void onOpenFilter () async {
    try {
      if (filesPath.isNotEmpty) {
        var directory = Directory(filesPath);
        if (await directory.exists()) {
          await ModalSheetComponent.showBarModalBottomSheet(
              context: Get.context,
              isDismissible: false,
              formSize: 0.4,
              Container(
                padding: const EdgeInsets.all(10.0),
                height: Get.height * 0.2,
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
                                  maxTime: ((txtToDateController.text).isNotEmpty)?DateTime.parse(txtToDateController.text):null,
                                  onConfirm: (v) async {
                                    txtFromDateController.text = v;
                                  },
                                  currentTime: DateTime.parse(txtFromDateController.text),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextInputComponent (title: "Đến ngày", placeholder: "yyyy-MM-dd",
                              controller: txtToDateController,
                              enable: false,
                              onTab: () async {
                                onTabChooseDatetion(Get.context!,
                                  onConfirm: (v) async {
                                    txtToDateController.text = v;
                                  },
                                currentTime: DateTime.parse(txtToDateController.text),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      ButtonLoginComponent (
                        btnLabel: "Áp dụng",
                        onPressed: () async {
                          await loadTimeFilter(isFirst: false);
                        },
                      )
                    ],
                  ),
                ),
              ),
              title: "Lọc dữ lệu",
            );
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onOpenFilter");
    }
  }

  Future<void> loadTimeFilter({isFirst = true}) async {
    try {
      if (filesPath.isNotEmpty) {
        var directory = Directory(filesPath);
        if (await directory.exists()) {
          var listFile = directory.listSync();
          LoadingComponent.show(msg: "Đang tính toán dữ liệu theo ngày...");
          listBarData.clear();
          if (txtFromDateController.text.isNotEmpty && txtToDateController.text.isNotEmpty) {
            DateTime fromDate = DateTime.parse(txtFromDateController.text);
            DateTime toDate = DateTime.parse(txtToDateController.text);
            for (var file in listFile) {
              List<String> temp = file.path.split('/');
              if (DateTime.tryParse(temp[temp.length - 1]) != null) {
                int sizeAppByDate = 0;
                var time = DateTime.tryParse(temp[temp.length - 1]);
                if (!time!.isBefore(fromDate) && !time.isAfter(toDate)) {
                  var subDirectory = Directory(file.path);
                  if (await subDirectory.exists()) {
                    var listImage = subDirectory.listSync();
                    for (var image in listImage) {
                      if (await image.exists() && image.path.isNotEmpty ) {
                        final sizeImage = File(image.path).lengthSync();
                        sizeAppByDate += sizeImage;
                      }
                    }
                  }
                  listBarData.add(PrCodeName(name: '${time.year}/${time.month}/${time.day}',codeDisplay: "$sizeAppByDate", value: time)); 
                }
              }
            }
          }
          barChartSizeApp.value = await createBarChart() ?? []; 
          LoadingComponent.dismiss();
          !isFirst ? Get.back() : null;
        }
      } 
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "loadTimeFilter");
    }
  }

  Future<bool> deleteFilesByDater(String filesPath, TextEditingController txtFromDateDeleteController, TextEditingController txtToDateDeleteController, List<String>? listRemoveImg) async {
    try {
      if (filesPath.isNotEmpty) {
        var directory = Directory(filesPath);
        if (await directory.exists()) {
        var listFile = directory.listSync();
        LoadingComponent.show(msg: "Đang xóa dữ liệu...");
        if (txtFromDateDeleteController.text.isNotEmpty && txtToDateDeleteController.text.isNotEmpty) {
          DateTime fromDate = DateTime.parse(txtFromDateDeleteController.text);
          DateTime toDate = DateTime.parse(txtToDateDeleteController.text);
          bool hasDelete = false;
          for (var file in listFile) {
            List<String> temp = file.path.split('/');
            if (DateTime.tryParse(temp[temp.length - 1]) != null) {
              var time = DateTime.tryParse(temp[temp.length - 1]);
              if (!time!.isBefore(fromDate) && !time.isAfter(toDate) && !time.isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
                if (listRemoveImg == null) {
                  hasDelete = true;
                  file.deleteSync(recursive: true);
                } else {
                  if (file.existsSync()) {
                    var directoryImage = Directory(file.path);
                    if (directoryImage.existsSync()) {
                      var listFileImage = directoryImage.listSync();
                      if (listFileImage.isNotEmpty) {
                        for (var image in listFileImage) {
                          String imageName = getFileNameFromString(image.path, '/', '.');
                          if (imageName.isNotEmpty) {
                            // xóa ảnh từ folder nếu tồn tại trong list xóa
                            var indexImageName = listRemoveImg.indexWhere((element) => element == imageName);
                            if (indexImageName != -1) {
                              image.deleteSync(recursive: true);
                              hasDelete = true;
                            }
                          }
                        }
                      }
                    }
                  }
                }
              } 
            }
          }
          if (hasDelete) {
            LoadingComponent.dismiss();
            return true;
          } else {
            LoadingComponent.dismiss();
            return false;
          }
        }
        LoadingComponent.dismiss();
        }
        return false;
      } else {
        LoadingComponent.dismiss();
        return false;
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "deleteFilesByDater");
      return false;
    }
  }

  String getFileNameFromString(String fileRoot, String charFirst, String charSecond) {
    String result = "";
    try {
      String imageNameLast = (fileRoot.split(charFirst).isNotEmpty ? fileRoot.split(charFirst).last : "");
      if (imageNameLast.isNotEmpty) {
        result = imageNameLast.split(charSecond).first;
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getFileNameFromString");
    }
    return result;
  }

  Future<void> deleteFilesByDate() async {
    try {
      String username = appController.userProfle.value.userName ?? "";
      // DateTime fromDate = DateTime.parse(txtFromDateDeleteController.text);
      // DateTime toDate = DateTime.parse(txtToDateDeleteController.text);
      DateTime fromDate = DateTime.parse('2023-12-27');
      DateTime toDate = DateTime.parse('2023-12-29');
      var result = await ActStorageMngUtils().removeModuleStorage(fromDate,toDate,(PrCodeName process){},username: username);
      if(result.statusCode == 0){
        AlertControl.push("Xoá dữ liệu thành công", type: AlertType.SUCCESS);
      }
      else{
        AlertControl.push("Vui lòng thử lại", type: AlertType.ERROR);
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "deleteFilesByDate");
    }
  }

  Future<bool> deleteDBByDate(String dbPath, TextEditingController txtFromDateDeleteController, TextEditingController txtToDateDeleteController) async {
    bool result = false;
    try {
      if (txtFromDateDeleteController.text.isNotEmpty && txtToDateDeleteController.text.isNotEmpty) {
        String username = appController.userProfle.value.userName ?? "";
        DateTime fromDate = DateTime.parse(txtFromDateDeleteController.text);
        DateTime toDate = DateTime.parse(txtToDateDeleteController.text).add(const Duration(days:1));
        await ActStorageMngUtils().removeModuleStorage(fromDate,toDate,(PrCodeName process){},username: username);
      }
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "deleteDBByDate SystemInfo.Controller");
    }
    return result;
  }

  Future<void> onDeleteFiles () async {
    try {
      await ModalSheetComponent.showBarModalBottomSheet(
          context: Get.context,
          isDismissible: false,
          formSize: 0.4,
          Container(
            padding: const EdgeInsets.all(10.0),
            height: Get.height * 0.2,
            width: Get.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextInputComponent (title: "Từ ngày", placeholder: "yyyy-MM-dd",
                          controller: txtFromDateDeleteController,
                          enable: false,
                          onTab: () async {
                            onTabChooseDatetion(Get.context!,
                              maxTime: ((txtToDateDeleteController.text).isNotEmpty)?DateTime.parse(txtToDateDeleteController.text):null,
                              onConfirm: (v) async {
                                txtFromDateDeleteController.text = v;
                              },
                              currentTime: DateTime.parse(txtFromDateDeleteController.text),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextInputComponent (title: "Đến ngày", placeholder: "yyyy-MM-dd",
                          controller: txtToDateDeleteController,
                          enable: false,
                          onTab: () async {
                            onTabChooseDatetion(Get.context!,
                            maxTime: DateTime.now().subtract(const Duration(days: 7)),
                              onConfirm: (v) async {
                                txtToDateDeleteController.text = v;
                              },
                            currentTime: DateTime.parse(txtToDateDeleteController.text),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  ButtonLoginComponent (
                    btnLabel: "Xóa",
                    onPressed: () async {
                      var result = await Alert.showDialogConfirm("Xóa bộ nhớ đệm", "Bạn có chắc muốn xóa bộ nhớ đệm từ ${txtFromDateDeleteController.text} đến ${txtToDateDeleteController.text} (Không xóa dữ liệu 7 ngày gần nhất)");
                      if (result) {
                        await deleteFilesByDate();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          title: "Xóa bộ nhớ đệm",
        );
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "onDeleteFiles");
    }
  }

  Future<void> onRefreshData () async {
    isLoading.value = true;
    setUpDate();
    await getStorage();
    getAppSizeUse();
    pieChartSizeApp.value = await createPieChart() ?? [];
    await loadTimeFilter();
    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}