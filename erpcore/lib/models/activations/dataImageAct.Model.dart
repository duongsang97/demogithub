import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class DataImageActModel {
  String? sysCode = "";
  String? fileName;
  String? urlImage = "";
  String? assetsImage = "";
  bool? allowUpload; // asset image cần phải đẩy lên
  String? imageBase64 = "";
  PrCodeName? kind = PrCodeName(code: "", name: "");
  int? lenghtSec; // tính bằng giây
  PrDate? createdAt = PrDate();
  bool? isGallery;
  String? note;
  bool get isOnline => (urlImage != null && urlImage!.isNotEmpty)?true:false;

  DataImageActModel({this.assetsImage,this.allowUpload = false, this.createdAt,this.imageBase64,this.kind,this.lenghtSec,this.sysCode,this.urlImage,this.fileName="", this.isGallery,this.note=""});

  factory DataImageActModel.fromJson(Map<String, dynamic>? json) {
    late DataImageActModel result = DataImageActModel();
    try{
      if(json != null){
      result = DataImageActModel(
          sysCode: (json["sysCode"])??"",
          urlImage: (json["urlImage"])??"",
          assetsImage: (json["assetsImage"])??"",
          imageBase64: (json["imageBase64"])??"",
          fileName: (json["fileName"])??"",
          lenghtSec: (json["lenghtSec"])??0,
          kind: PrCodeName.fromJson(json["kind"]),
          createdAt: (json["createdAt"])??PrDate(),
          isGallery: (json["isGallery"]) ?? false,
          note: (json["note"]) ?? "",
          allowUpload: (json["allowUpload"]) ?? false,
        );
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "DataImageActModel.fromJson");
    }
    return result;
  }

  factory DataImageActModel.fromLocalJson(Map<String, dynamic>? json) {
    late DataImageActModel result = DataImageActModel();
    try{
      if(json != null){
      result = DataImageActModel(
        sysCode : (json["sysCode"])??"",
        urlImage: (json["urlImage"])??"",
        assetsImage: (json["assetsImage"])??"",
        imageBase64: (json["imageBase64"])??"",
        fileName: (json["fileName"])??"",
        lenghtSec: (json["lenghtSec"])??0,
        createdAt: (json["createdAt"])!=null ? PrDate.fromJson(json["createdAt"]):PrDate(),
        kind:(json["kind"])!=null?PrCodeName.fromJson(json["kind"]):PrCodeName.create(), 
        isGallery: (json["isGallery"]) ?? false,
        note: (json["note"])??"",
        allowUpload: (json["allowUpload"])??false,
        );
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "DataImageActModel.fromLocalJson");
    }
    return result;
  }

  static List<DataImageActModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataImageActModel.fromJson(item)).toList();
  }
  static List<DataImageActModel> fromLocalList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataImageActModel.fromLocalJson(item)).toList();
  }

  static List< Map<String, dynamic>> toJsonList(List<DataImageActModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
  static List<PrFileUpload> toPrFileUploadList(List<DataImageActModel>? list) {
    if (list == null) return [];
    return list.map((item){
     var temp =  PrFileUpload(
        sysCode: (item.sysCode != null && item.sysCode!.isNotEmpty)?item.sysCode:generateKeyCode(),
        field: item.note,
        fileName: item.fileName,
     );
     return temp;
    }).toList();
  }
 static DataImageActModel create(){
    return DataImageActModel(
        sysCode: generateKeyCode(),
        urlImage: "",
        assetsImage: "",
        imageBase64: "",
        kind: PrCodeName.create(),
        createdAt: PrDate(), 
        isGallery: false);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": (sysCode)??"",
      "urlImage": (urlImage)??"",
      "assetsImage": (assetsImage)??"",
      "imageBase64": (imageBase64)??"",
      "lenghtSec": (lenghtSec)??0,
      "fileName": fileName,
      "createdAt": createdAt!=null?(createdAt!.toJson()):{},
      "kind": kind!=null?(kind!.toJson()):{},
      "isGallery": isGallery ?? false,
      "note": note ?? "",
      "allowUpload": allowUpload ?? false,
    };
    return map;
  }


  // static DataImageActModel fromPrFileUpload(Map<String, dynamic> json) {
  //   if (json == null) return null;
  //   DataImageActModel result = new DataImageActModel();
  //   result.assetsImage = "";
  //   result.createdAt = PrDate.fromJson(json["uploadDate"]);
  //   result.imageBase64 = "";
  //   result.sysCode = "";
  //   result.urlImage = createPathServer(json["fileUrl"], json["rootFileName"]);
  //   result.kind = PrCodeName.fromJson( json["kind"]);
  //   return result;
  // }

  static List<DataImageActModel> fromJsonListFileUpload(List? list) {
    if (list == null) return List<DataImageActModel>.empty(growable: true);
    return list.map((item) => DataImageActModel.fromPrFileUploadKindFile(item)).toList();
  }

  static List<DataImageActModel> fromJsonListFileUploadV2(List? list) {
    if (list == null) return List<DataImageActModel>.empty(growable: true);
    return list.map((item) => DataImageActModel.fromPrFileUploadKindFileV2(item)).toList();
  }
  static List<DataImageActModel> fromListFileUpload(List<PrFileUpload>? list) {
    if (list == null) return List<DataImageActModel>.empty(growable: true);
    return list.map<DataImageActModel>((item) => DataImageActModel(sysCode: item.sysCode,fileName: item.fileName,note: item.field,urlImage: (item.fileUrl != null)?createPathServer(item.fileUrl,item.fileName):"",)).toList();
  }

  static DataImageActModel fromPrFileUploadKindFile(Map<String, dynamic>? json) {
    late DataImageActModel result = DataImageActModel();
    try{
      if(json != null){
        result.assetsImage =  (json["assetsImage"])??"";
        result.createdAt = PrDate.fromJson(json["uploadDate"]);
        result.imageBase64 = "";
        result.sysCode = "";
        result.fileName = json["fileName"]??"";
        result.lenghtSec = (json["lenghtSec"])??0;
        result.urlImage = (json["fileUrl"] != null)?createPathServer(json["fileUrl"], json["rootFileName"]):(json["urlImage"])??"";
        result.kind = PrCodeName.fromJson( json["kind"]);
        result.lenghtSec = ((json["sideType"])??0)!=0?((json["sideType"])??0):(json["lenghtSec"])??0;
        result.isGallery = json["isGallery"] ?? false;
        result.allowUpload = json["allowUpload"] ?? false;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fromPrFileUploadKindFile");
    }
    return result;
  }

  static DataImageActModel fromPrFileUploadKindFileV2(Map<String, dynamic>? json) {
    late DataImageActModel result = DataImageActModel();
    try{
      if(json != null){
        result.assetsImage =  (json["assetsImage"])??"";
        result.createdAt = PrDate.fromJson(json["uploadDate"]);
        result.imageBase64 = "";
        result.fileName = json["fileName"]??"";
        result.sysCode = json["sysCode"];
        result.urlImage = (json["fileUrl"] != null)?createPathServer(json["fileUrl"], json["fileName"]):(json["urlImage"])??"";
        result.kind = PrCodeName.fromJson( json["kind"]);
        result.lenghtSec = ((json["sideType"])??0)!=0?((json["sideType"])??0):(json["lenghtSec"])??0;
        result.isGallery = json["isGallery"] ?? false;
        result.allowUpload = json["allowUpload"] ?? false;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fromPrFileUploadKindFileV2");
    }
    return result;
  }

  static List<DataImageActModel> fromJsonListFileUploadKindFile(List? list) {
    if (list == null) return [];
    return list.map((item) => DataImageActModel.fromPrFileUploadKindFile(item)).toList();
  }

  factory DataImageActModel.copyWith(DataImageActModel data) {
    var result = DataImageActModel();
    try{
      result.assetsImage =  data.assetsImage;
      result.createdAt = data.createdAt;
      result.imageBase64 = data.imageBase64;
      result.sysCode = data.sysCode;
      result.fileName = data.fileName;
      result.lenghtSec = data.lenghtSec;
      result.urlImage = data.urlImage;
      result.kind = data.kind;
      result.lenghtSec = data.lenghtSec;
      result.isGallery = data.isGallery;
      result.allowUpload = data.allowUpload;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "DataImageActModel.copyWith");
    }
    return result;
  }
}
