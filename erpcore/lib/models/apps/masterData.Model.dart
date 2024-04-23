import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class MasterDataModel {
  String? code = "";
  //String? listErr = "";
  String? name = "";
  String? note;
  int? sortOrder;
  String? strResult;
  String? sysCode;
  int? sysStatus;
  int? type;


  MasterDataModel({String? code,String? name,String? note,int? sortOrder,String? strResult,String? sysCode,int? sysStatus,int? type}){
    this.code = code??"";
    //this.listErr = listErr??"";
    this.name = name??"";
    this.note = note??"";
    this.sortOrder = sortOrder??0;
    this.strResult = strResult??"";
    this.sysCode = sysCode??"";
    this.sysStatus = sysStatus??0;
    this.type = type??0;
  }

  factory MasterDataModel.fromJson(Map<String, dynamic>? json) {
    late MasterDataModel result = MasterDataModel();
    if (json != null){
    result = MasterDataModel(
      code: (json["code"])??"",
      name: (json["name"])??"",
      note: (json["note"])??"",
      sortOrder: (json["sortOrder"])??0,
      strResult: (json["strResult"])??"",
      sysCode: (json["sysCode"])??"",
      sysStatus: (json["sysStatus"])??0,
      type: (json["type"])??0,
    );
    }
    return result;
  }

  static List<MasterDataModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => MasterDataModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": (code)??"",
      "name": (name)??"",
      "note": (note)??"",
      "sortOrder": (sortOrder)??0,
      "strResult": (strResult)??"",
      "sysCode": (sysCode)??"",
      "sysStatus": (sysStatus)??0,
      "type": (type)??0,
    };
    return map;
  }
}