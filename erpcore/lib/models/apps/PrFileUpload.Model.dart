import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';

class PrFileUpload {
  String? sysCode = generateKeyCode();
  int? sideType=0;
  int? outFileUrl=0;
  String? rootFileName="";
  String? fileExt="";
  String? fileName="";
  String? fileUrl="";
  String? field ="";
  String? note="";
  PrDate? uploadDate;
  PrCodeName? kind = PrCodeName.create();
  String? itemCode="";
  String? codeOfData="";
  String? fileOnServer="";
  String? fileSize = "";
  String? fileAsset="";
  String? longitude;
  String? latitude;
  
  PrFileUpload({this.latitude,this.longitude,this.codeOfData,this.fileAsset,this.fileExt,this.fileName,this.fileOnServer,this.fileUrl,
    this.itemCode,this.kind,this.note,this.outFileUrl,this.rootFileName,this.sideType,this.sysCode,this.uploadDate, this.fileSize,this.field
  });

  factory PrFileUpload.fromJson(Map<String, dynamic>? json) {
    late PrFileUpload result = PrFileUpload();
    if (json != null){
      result = PrFileUpload(
        sysCode: (json["sysCode"])??generateKeyCode(),
        sideType: (json["sideType"])??0,
        outFileUrl: (json["outFileUrl"])??0,
        rootFileName: (json["rootFileName"])??"",
        fileExt: (json["fileExt"])??"",
        fileName: (json["fileName"])??"",
        fileUrl: (json["fileUrl"])??"",
        note: (json["note"])??"",
        uploadDate: PrDate.fromJson(json["uploadDate"]),
        kind: PrCodeName.fromJson(json["kind"]),
        itemCode: (json["itemCode"])??"",
        codeOfData: (json["codeOfData"])??"",
        fileOnServer: (json["fileOnServer"])??"",
        latitude: (json["latitude"])??"",
        longitude: (json["longitude"])??"",
        fileSize: (json["fileSize"])??"",
        field: (json["field"])??"",
      );
    }
    return result;
  }

  static PrFileUpload create(){
    return PrFileUpload(sideType:0,outFileUrl:0,rootFileName:"",fileExt:"",fileName:"",fileUrl:"",note:"",uploadDate: PrDate(),kind:PrCodeName.create(),itemCode:"",
  codeOfData:"",fileOnServer:"");
  }

  static List<PrFileUpload> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PrFileUpload.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PrFileUpload>? list) {
    if (list == null) return [];
    var temp = List<Map<String, dynamic>>.empty(growable: true);
    for(var item in list){
      if(item.fileAsset == null || item.fileAsset!.isEmpty){
        temp.add(item.toJson());
      }
    }
    return temp;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sideType": (sideType)??0,
      "outFileUrl": (outFileUrl)??0,
      "rootFileName": (rootFileName)??"",
      "fileExt": (fileExt)??"",
      "fileName": (fileName)??"",
      "fileUrl": (fileUrl)??"",
      "note":(note)??"",
      "uploadDate": uploadDate!=null?(uploadDate!.toJson()):{},
      "kind": kind!=null?(kind!.toJson()):{},
      "itemCode": (itemCode)??"",
      "codeOfData": (codeOfData)??"",
      "fileOnServer": (fileOnServer)??"",
      "longitude": (longitude)??"",
      "latitude":(latitude)??"",
      "fileSize": (fileSize) ?? "",
      "field": (field) ?? "",
      "sysCode": (sysCode),
      "key":sysCode
    };
    return map;
  }
}