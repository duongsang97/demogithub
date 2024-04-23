import 'package:erpcore/models/apps/prCodeName.Model.dart';

class ActSellOutItem {
  String? workdate; // Ngày 
  PrCodeName? shop; //CH   
  PrCodeName? product; //sản phẩm (chi tiết doanh thủ)
  int? quantity; // số lượng (chi tiết doanh thủ)
  int? cost; //Giá  (chi tiết doanh thủ)
  int? actual; //Doanh thu - Tổng tiền
  int? totalActual; //Tổng doanh thu
  ActSellOutItem({this.actual,this.cost,this.product,this.quantity,this.shop,this.totalActual,this.workdate});
  factory ActSellOutItem.fromJson(Map<String, dynamic>? json) {
    late ActSellOutItem result = ActSellOutItem();
    if(json != null){
      result = ActSellOutItem(
        workdate: (json['workdate'])??"",
        shop: PrCodeName.fromJson(json['shop']),
        product: PrCodeName.fromJson(json['product']),
        quantity: (json['quantity'])??0,
        cost: (json['cost'])??0,
        actual: (json['amonut'])??0,
        totalActual: (json['totalAmonut'])??0,
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workdate'] = (workdate)??"";
    data['shop'] = (shop)!=null ? shop!.toJson():{};
    data['product'] = (product)!=null ? product!.toJson():{};
    data['quantity'] = (quantity)??0;
    data['cost'] = (cost)??0;
    data['amonut'] = (actual)??0;
    data['totalAmonut'] = (totalActual)??0;
    return data;
  }

  static List<ActSellOutItem> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ActSellOutItem.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<ActSellOutItem>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}