import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class FileInfoConfigModel{
  bool enable = false;
  bool? readOnly = false;
  int? minQuantity =0;
  int? maxQuantity =-1;
  bool? isRequire=false;
  bool? isAutoSave=false;
  bool? isScanBill= false;
  bool? faceDetect = false;
  int? numberPeople = 0;
  int? serverTime = 0; // if serverTime equal 1, get online time for take picture action
  int? isGPS; // IsGPS = 0: Không cần GPS, 1: cần GPS
  FileInfoConfigModel({required this.enable,this.isRequire,this.isScanBill,this.minQuantity,this.faceDetect=false,this.numberPeople = 0,this.maxQuantity=-1,this.serverTime=0,
    this.readOnly = false,this.isAutoSave=false, isGPS = 0,
  });

  factory FileInfoConfigModel.fromJson(Map<String, dynamic>? json) {
    FileInfoConfigModel result = FileInfoConfigModel(enable : false);
    try{
      if(json != null){
        result = FileInfoConfigModel(
          enable: (json["enable"])??false,
          minQuantity: (json["minQuantity"])??0,
          isRequire: (json["isRequire"])??false,
          isAutoSave: (json["isAutoSave"])??false,
          isScanBill: (json["isScanBill"])??false,
          faceDetect: (json["faceDetect"])??false,
          numberPeople: (json["numberPeople"])??0,
          maxQuantity: (json["maxQuantity"])??-1,
          serverTime: (json["serverTime"])??0,
          readOnly: (json["readOnly"])??false,
          isGPS: (json["isGPS"])??0,
        );
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "FileInfoConfigModel.fromJson");
    }
    return result;
  }

  static FileInfoConfigModel create(){
    return FileInfoConfigModel(enable: false, minQuantity: 0,isRequire:false);
  }

  static List<FileInfoConfigModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => FileInfoConfigModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "enable": enable,
      "minQuantity": (minQuantity)??0,
      "isRequire": (isRequire)??false,
      "isAutoSave": (isAutoSave)??false,
      "isScanBill": (isScanBill)??false,
      "faceDetect": (faceDetect)??false,
      "numberPeople": (numberPeople)??0,
      "maxQuantity": (maxQuantity)??-1,
      "serverTime":  (serverTime)??0,
      "readOnly":  (readOnly)??false,
      "isGPS":  (isGPS)??0,
    };
    return map;
  }
}