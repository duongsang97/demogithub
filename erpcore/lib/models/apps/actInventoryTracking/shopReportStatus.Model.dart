import 'package:erpcore/models/apps/prCodeName.Model.dart';

class ShopReportStatusModel extends PrCodeName{
  int isConfirm;
  ShopReportStatusModel({this.isConfirm=0,String code ="",String name="",String codeDisplay=""}):super(code: code,name: name,codeDisplay: codeDisplay);

  
  factory ShopReportStatusModel.fromJson(Map<String, dynamic>? json) {
    late ShopReportStatusModel result = ShopReportStatusModel();
    if (json != null) {
      result = ShopReportStatusModel(
        code: (json["code"]) ?? "",
        name: (json["name"]) ?? "",
        codeDisplay: (json["codeDisplay"]) ?? "",
        isConfirm: (json["isConfirm"]) ?? 0,
      );
    }
    return result;
  }

  static List<ShopReportStatusModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ShopReportStatusModel.fromJson(item)).toList();
  }
}