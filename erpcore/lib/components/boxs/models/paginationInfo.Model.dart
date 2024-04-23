import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class PaginationInfoModel {
  int? page;
  int? totalPage;
  int? pageSize;
  String get pageDisplay => "${(page ?? 0)}/${totalPage}";
  PaginationInfoModel({this.page = 1, this.pageSize = 50, this.totalPage = 1});

  factory PaginationInfoModel.fromJson(Map<String, dynamic>? json,PaginationInfoModel current) {
    if (json != null) {
      current.totalPage = totalPageCalculator(current.pageSize??25,json["total"]??1);
    }
    return current;
  }

  static int totalPageCalculator(int page,int totalItem){
    int result = 1;
    try{
      bool isDevisor = totalItem%page==0;
      result= totalItem~/page;
      if(!isDevisor){
        result++;
      }
      if(result == 0){
      result ++;
    }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "totalPageCalculator");
    }
    return result;
  }
}
