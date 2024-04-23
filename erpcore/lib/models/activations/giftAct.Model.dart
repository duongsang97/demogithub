import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

class GiftActModel {
  String code = "";
  String imageAsset = "";
  int? type;
  String urlImage = "";
  String? decription = "";
  Color color = AppColor.aqua;

  GiftActModel({required this.code, required this.color,this.decription,required this.imageAsset,this.type,required this.urlImage});
  factory GiftActModel.fromJson(Map<String, dynamic>? json) {
    late GiftActModel result = GiftActModel(code: "",imageAsset: "",color: AppColor.aqua,urlImage: "");
    if (json != null) {
      result = GiftActModel(
        code: (json["code"])??"",
        imageAsset: (json["imageAsset"])??"",
        urlImage: (json["urlImage"])??"",
        decription: (json["decription"])??"",
        color: (json["color"])??AppColor.aqua
      );
    }
    return result;
  }

  static List<GiftActModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => GiftActModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": this.code,
      "imageAsset": this.imageAsset,
      "urlImage": this.urlImage,
      "decription": (this.decription)??"",
      "color": this.color
    };
    return map;
  }

  static GiftActModel fromAPI(Map<String, dynamic>? json) {
  late  GiftActModel result = GiftActModel(code: "",imageAsset: "",urlImage: "",color: AppColor.aqua);
  if(json != null){
    result = new GiftActModel(
        code: generateKeyCode(),
        imageAsset: "",
        urlImage: "",
        color: Colors.black12,);
        // result.imageAsset = "";
        // result.code = (json["code"])??"";
        // result.decription = (json["name"])??"";
        // result.urlImage = createPathServer((json["image"])??"", "");
  }
    return result;
  }

  static List<GiftActModel> fromJsonListAPI(List? list) {
    if (list == null) return [];
    return list.map((item) => GiftActModel.fromAPI(item)).toList();
  }
}
