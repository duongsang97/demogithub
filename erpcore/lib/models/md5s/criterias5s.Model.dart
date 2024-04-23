import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';

class Criterias5sModel{
  String? sysCode="";
  String? code="";
  String? name="";
  bool? checked=true;
  String? imagePath ="";
  String? imageBase64="";
  PrCodeName? criterias;
  PrCodeName? kind = PrCodeName(code: generateKeyCode(),name: "");
  Criterias5sModel({String? sysCode,String? code,String? name,bool? checked,PrCodeName? kind,String? imagePath,String? imageBase64,PrCodeName? criterias}){
    this.sysCode= sysCode??"";
    this.code= code??"";
    this.name= name??"";
    this.checked= checked??true;
    this.imagePath = imagePath??"";
    this.imageBase64= imageBase64??"";
    this.criterias = criterias??PrCodeName();
    this.kind = kind??PrCodeName(code: generateKeyCode(),name: "");
  }

  static List<Criterias5sModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((e) => Criterias5sModel.fromJson(e)).toList();
  }

  factory Criterias5sModel.fromJson(Map<String, dynamic>? json) {
    late Criterias5sModel result = Criterias5sModel();
    if (json != null){
    result = Criterias5sModel(
      sysCode: (json["sysCode"])??"",
      code: (json["code"])??"",
      name: (json["name"])??"",
      checked: (json["point"]!= null && json["point"] == 10)?true:false,
      kind: PrCodeName.fromJson(json["kind"]),
      imagePath:"",
      imageBase64:"",
      criterias : PrCodeName.fromJson(json["criterias"])
    );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "criterias":{"code":(code)??"","name":(name)??""},
      "point": (checked!=null && checked==true)?10:0,
      "imgBase64":(imageBase64)??""
    };
    return map;
  }


  static List<Map<String,dynamic>> toListJson(List<Criterias5sModel>? list) {
    if (list == null) return [];
    return list.map<Map<String,dynamic>>((e) => e.toJson()).toList();
  }
}