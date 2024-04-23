import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';

class DataImageActivationModel {
  String? sysCode = "";
  String? urlImage = "";
  String? assetsImage = "";
  String? imageBase64 = "";
  PrCodeName? kind = new PrCodeName(code: "", name: "");
  PrDate? createdAt = new PrDate();

  DataImageActivationModel({this.assetsImage,this.createdAt,this.imageBase64,this.kind,this.sysCode,this.urlImage});
  

  factory DataImageActivationModel.fromJson(Map<String, dynamic>? json) {
    late DataImageActivationModel result = DataImageActivationModel();
    if(json != null){
    result = DataImageActivationModel(
        sysCode: (json["sysCode"])??"",
        urlImage: (json["urlImage"])??"",
        assetsImage: (json["assetsImage"])??"",
        imageBase64: (json["imageBase64"])??"",
        kind: PrCodeName.fromJson(json["kind"]),
        createdAt: (json["createdAt"])??PrDate()
      );
    }
    return result;
  }

  static List<DataImageActivationModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataImageActivationModel.fromJson(item)).toList();
  }

 static DataImageActivationModel create(){
    return new DataImageActivationModel(
        sysCode: generateKeyCode(),
        urlImage: "",
        assetsImage: "",
        imageBase64: "",
        kind: PrCodeName.create(),
        createdAt: new PrDate());
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": (this.sysCode)??"",
      "urlImage": (this.urlImage)??"",
      "assetsImage": (this.assetsImage)??"",
      "imageBase64": (this.imageBase64)??"",
      "createdAt": this.createdAt!=null?(this.createdAt!.toJson()):{},
      "kind": this.kind!=null?(this.kind!.toJson()):{}
    };
    return map;
  }

  // static DataImageActivationModel fromPrFileUpload(Map<String, dynamic> json) {
  //   if (json == null) return null;
  //   DataImageActivationModel result = new DataImageActivationModel();
  //   result.assetsImage = "";
  //   result.createdAt = PrDate.fromJson(json["uploadDate"]);
  //   result.imageBase64 = "";
  //   result.sysCode = "";
  //   result.urlImage = createPathServer(json["fileUrl"], json["rootFileName"]);
  //   result.kind = PrCodeName.fromJson( json["kind"]);
  //   return result;
  // }

  static List<DataImageActivationModel> fromJsonListFileUpload(List? list) {
    if (list == null) return [];
    return list.map((item) => DataImageActivationModel.fromPrFileUploadKindFile(item)).toList();
  }

  static DataImageActivationModel fromPrFileUploadKindFile(Map<String, dynamic>? json) {
    late DataImageActivationModel result = new DataImageActivationModel();
    if(json != null){
      result.assetsImage = "";
      result.createdAt = PrDate.fromJson(json["uploadDate"]);
      result.imageBase64 = "";
      result.sysCode = "";
      result.urlImage = createPathServer(json["fileUrl"], json["rootFileName"]);
      result.kind = PrCodeName.fromJson( json["kind"]);
    }
    return result;
  }

  static List<DataImageActivationModel> fromJsonListFileUploadKindFile(List? list) {
    if (list == null) return [];
    return list.map((item) => DataImageActivationModel.fromPrFileUploadKindFile(item)).toList();
  }
}
