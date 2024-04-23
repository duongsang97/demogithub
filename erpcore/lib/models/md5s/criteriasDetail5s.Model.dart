import 'package:erpcore/models/apps/prCodeName.Model.dart';

class CriteriasDetail5sModel {
  String? code = "";
  String? name = "";
  PrCodeName? kind;

  CriteriasDetail5sModel({String? code, String? name, PrCodeName? kind}){
    this.code = code??"";
    this.name = name??"";
    this.kind = kind??PrCodeName();
  }

  factory CriteriasDetail5sModel.fromJson(Map<String, dynamic>? json) {
    late CriteriasDetail5sModel result = CriteriasDetail5sModel();
    if (json != null) {
      result = CriteriasDetail5sModel(
        code: (json["code"])??"",
        name: (json["name"])??"",
        kind: PrCodeName.fromJson(json["kind"]),
      );
    }
    return result;
  }

  static List<CriteriasDetail5sModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => CriteriasDetail5sModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": (code)??"",
      "name": (name)??"",
      "kind": kind!=null?(kind!.toJson()):{}
    };
    return map;
  }
}
