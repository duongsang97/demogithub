import 'package:erpcore/models/apps/actInventoryTracking/dataGifts.Model.dart';
import 'package:erpcore/models/apps/actInventoryTracking/overviewInv.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

import 'shopReportStatus.Model.dart';

class DataInventoryModel {
  List<OverviewInv>? overView;
  List<DataGiftsModel>? topGifts;
  List<ShopReportStatusModel>? shops;
  List<DataGiftsModel>? gifts;
  int? total;
  String? note;
  

  DataInventoryModel({this.gifts,this.note,this.overView,this.shops,this.topGifts,this.total});

  factory DataInventoryModel.fromJson(Map<String, dynamic>? json) {
    late DataInventoryModel result = DataInventoryModel();
    if(json != null){
      result = DataInventoryModel(
        overView: OverviewInv.fromJsonList(json['overView']),
        topGifts : DataGiftsModel.fromJsonList(json['topGifts']),
        shops : ShopReportStatusModel.fromJsonList(json['shops']),
        gifts : DataGiftsModel.fromJsonList(json['gifts']),
        total : (json['total'])??0,
        note : (json['note'])??"",
      ); 
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['overView'] = this.overView!=null?(OverviewInv.toJsonList(this.overView!)):[];
      data['topGifts'] = this.topGifts!=null?(DataGiftsModel.toJsonList(this.topGifts!)):[];
      data['shops'] = this.shops!=null?(PrCodeName.toJsonList(this.shops!)):[];
      data['gifts'] = this.gifts!=null?(DataGiftsModel.toJsonList(this.gifts!)):[];
      data['total'] = this.total??0;
      data['note'] = this.note??"";
    return data;
  }

  static List<DataInventoryModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataInventoryModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<DataInventoryModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
