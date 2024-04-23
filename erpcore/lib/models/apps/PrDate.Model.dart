import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:intl/intl.dart';

class PrDate {
  String? sD;
  int? lD;
  PrDate({this.lD = 0,this.sD =""});

  factory PrDate.fromJson(Map<String, dynamic>? json) {
   late PrDate dt = PrDate();
    if (json != null) {
    dt.lD = (json["lD"])??0;
    dt.sD = (json["sD"])??"";
    }
    return dt;
  }

  static bool isEmpty(PrDate? date){
    bool result = true;
    try{
      if(date != null && (date.lD != null && date.lD! >0) && (date.sD != null && date.sD!.isNotEmpty)){
        result= false;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "isEmpty PrDate.Model");
    }
    return result;
  }
  
  static int compareTo(PrDate? other1,PrDate? other2){
    int result = 0;
    try{
      if(isEmpty(other1) && isEmpty(other2)){
        result =0;
      }
      else if(other1?.lD == other2?.lD){
        result =0;
      }
      else if((other1?.lD??0) > (other2?.lD??0)){
        result =1;
      }
       else if((other1?.lD??0) < (other2?.lD??0)){
        result =-1;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "isEmpty PrDate.Model");
    }
    return result;
  }

  static PrDate setDate(DateTime date,{String formatDate = "yyyy-MM-dd HH:mm:ss"}){
    var result = PrDate();
    try{
      result.sD = DateFormat(formatDate).format(date);
      result.lD = convertDateToTicks(date);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "setDate PrDate.Model");
    }
    return result;
  }
  static DateTime getDate(PrDate date){
    var result = DateTime(1900);
    try{  
      result = convertTicksToDate(date.lD??0);//.subtract(Duration(days: 1));
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getDate PrDate.Model");
    }
    return result;
  }
  static List<PrDate> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PrDate.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "lD": (lD)??0,
      "sD": (sD)??0,
    };
    return map;
  }
}
