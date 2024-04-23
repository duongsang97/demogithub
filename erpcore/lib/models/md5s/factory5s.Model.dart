import 'package:erpcore/models/apps/prCodeName.Model.dart';

class Factory5sModel{
  String code = "";
  String name = "";
  List<PrCodeName>? listParts;

  Factory5sModel({required String code, required String name, List<PrCodeName>? listParts}){
    code = code;
    name = name;
    this.listParts = listParts??List<PrCodeName>.empty(growable: true);
  }

  factory Factory5sModel.fromJson(Map<String, dynamic>? json) {
    late Factory5sModel result = Factory5sModel(code: "",name: "");
    if (json != null){
    result = Factory5sModel(
      code: (json["code"])??"",
      name: (json["name"])??"",
      listParts: PrCodeName.fromJsonList(json["listParts"]),
    );
    }
    return result;
  }


  static List<Factory5sModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => Factory5sModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": code,
      "name": name,
    };
    return map;
  }
}