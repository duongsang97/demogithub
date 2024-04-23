import 'dataBalance.Model.dart';

class DataTrackingBalance {
  List? sum;
  int? total;
  List<DataBalance>? data;
  var dataSum;
  var dataConfig;
  String? sysKey;
  String? filter;
  String? warning;

  DataTrackingBalance({List? sum,int? total,List<DataBalance>? data,var dataSum,var dataConfig,String? sysKey,String? filter,String? warning}){
    this.sum = sum??[];
    this.total = total??0;
    this.data = data?? List<DataBalance>.empty(growable: true);
    this.dataSum = dataSum??"";
    this.dataConfig = dataConfig??"";
    this.sysKey = sysKey??"";
    this.filter = filter??"";
    this.warning = warning??"";
  }

  factory DataTrackingBalance.fromJson(Map<String, dynamic>? json) {
    late DataTrackingBalance result = DataTrackingBalance();
    if (json != null){
    result = DataTrackingBalance(
        sum: (json['sum'])??[],
        total: (json['total'])??0,
        data: DataBalance.fromJsonList(json['data']),
        dataSum: (json['dataSum'])??"",
        dataConfig: (json['dataConfig'])??"",
        sysKey: (json['sysKey'])??"",
        filter: (json['filter'])??"",
        warning: (json['warning'])??"");
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = (this.sum)??[];
    data['total'] = (this.total)??0;
    data['data'] = (this.data)??[];
    data['dataSum'] = (this.dataSum)??"";
    data['dataConfig'] = (this.dataConfig)??"";
    data['sysKey'] = (this.sysKey)??"";
    data['filter'] = (this.filter)??"";
    data['warning'] = (this.warning)??"";
    return data;
  }
}
