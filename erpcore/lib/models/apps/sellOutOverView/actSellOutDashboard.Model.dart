import 'package:erpcore/models/apps/sellOutOverView/actSellOutItem.Model.dart';

class ActSellOutDashboardModel {
  int? totalTarget;//target
  int? totalAcutal;//doanh thu thực tế
  int? rate;// Tỷ lệ
  int? totalShop;//sl Shop
  int? totalProduct;//sl SP
  List<ActSellOutItem>? items;
  String? unit;
  ActSellOutDashboardModel({this.items,this.rate,this.totalAcutal,this.totalProduct,this.totalShop,this.totalTarget,this.unit});

  factory ActSellOutDashboardModel.fromJson(Map<String, dynamic>? json) {
    late ActSellOutDashboardModel result = ActSellOutDashboardModel();
    if(json != null){
      result = ActSellOutDashboardModel(
        totalTarget: (json['totalTarget'])??0,
        totalAcutal: (json['totalAcutal'])??0,
        rate: (json['rate'])??0,
        totalShop: (json['totalShop'])??0,
        totalProduct: (json['totalProduct'])??0,
        items: ActSellOutItem.fromJsonList(json['items']),
        unit: (json['unit'])??"",
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTarget'] = (totalTarget)??0;
    data['totalAcutal'] = (totalAcutal)??0;
    data['rate'] = (rate)??0;
    data['totalShop'] = (totalShop)??0;
    data['totalProduct'] = (totalProduct)??0;
    data['items'] = items != null?ActSellOutItem.toJsonList(items):[];
    data['unit'] = (unit)??"";
    return data;
  }

  static List<ActSellOutDashboardModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ActSellOutDashboardModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<ActSellOutDashboardModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
