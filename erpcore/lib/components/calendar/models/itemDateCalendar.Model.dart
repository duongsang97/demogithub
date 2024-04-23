import 'package:erpcore/components/calendar/models/ItemEventDateCalendar.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class ItemDateCalendarModel {
  String? sysCode;
  DateTime? date;
  int? dateDisplay;
  List<ItemEventDateCalendarModel>? events;
  ItemDateCalendarModel({this.date,this.dateDisplay,this.sysCode,this.events});

  factory ItemDateCalendarModel.fromJson(Map<String, dynamic>? json) {
    late ItemDateCalendarModel result;
    try{
      if(json != null){
        result =ItemDateCalendarModel(
          sysCode: json["sysCode"],
          date: json["sysCode"],
          dateDisplay: json["dateDisplay"],
          //events: [ItemEventDateCalendarModel.fromJsonList(json["events"])],
        );
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "ItemDateCalendarModel.fromJson itemDateCalendar.Model");
    }
    return result;
  }

  static List<ItemDateCalendarModel> fromJsonList(List? list) {
    late List<ItemDateCalendarModel> result =[];
    try{
      if(list != null){
        result = list.map((item) => ItemDateCalendarModel.fromJson(item)).toList();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fromJsonList itemDateCalendar.Model");
    }
    return result;
    
  }
  static  List<Map<String, dynamic>> toJsonList(List<ItemDateCalendarModel>? list) {
    late List<Map<String, dynamic>> result;
    try{
      if(list != null){
        result = list.map((item) => item.toJson()).toList();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "toJsonList itemDateCalendar.Model");
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": sysCode,
      "date": date,
      "dateDisplay": dateDisplay,
    };
    return map;
  }
}