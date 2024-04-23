import 'package:erpcore/models/apps/payslip/salPeriod.Model.dart';

class PayslipOverviewModel {
  String? sysCode = "";
  SalPeriodModel? salPeriod; // thông tin lương
  int? data01; // tổng thu
  int? data02; // tổng trừ
  int? data03; // thực nhận

  PayslipOverviewModel({this.data01,this.data02,this.data03,this.salPeriod,this.sysCode});

  factory PayslipOverviewModel.fromJson(Map<String, dynamic>? json) {
    late PayslipOverviewModel result = PayslipOverviewModel();
    if (json != null){
    result = PayslipOverviewModel(
      sysCode: (json["sysCode"])??"",
      data01: (json["data01"])??0,
      data02: (json["data02"])??0,
      data03: (json["data03"])??0,
      salPeriod: SalPeriodModel.fromJson(json["salPeriod"],)
    );
    }
    return result;
  }
  
  static List<PayslipOverviewModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PayslipOverviewModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<PayslipOverviewModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": (this.sysCode)??"",
      "data01": (this.data01)??0,
      "data02": (this.data02)??0,
      "data03": (this.data03)??0,
      "salPeriod": this.salPeriod!=null?(this.salPeriod!.toJson()):{},
    };
    return map;
  }
}
