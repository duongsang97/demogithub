import 'package:erpcore/models/activations/giftLuckyDraw.Model.dart';

class LuckyDrawInfoModel{
  int? total;
  String? sysKey;
  List<GiftLuckyDrawModel>? data;
  LuckyDrawInfoModel({this.data,this.sysKey,this.total});

  factory LuckyDrawInfoModel.fromJson(Map<String, dynamic>? json) {
    late LuckyDrawInfoModel result = LuckyDrawInfoModel();
    if (json != null){
    result = LuckyDrawInfoModel(
      total: (json["total"])??0,
      sysKey: (json["sysKey"])??"",
      data: LuckyDrawInfoModel.fromJsonList(json["data"]) 
    );
    };
    return result;
  }

  static List<GiftLuckyDrawModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => GiftLuckyDrawModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "total": (this.total)??0,
      "sysKey": (this.sysKey)??"",
      //"data": this.data 
    };
    return map;
  }
}