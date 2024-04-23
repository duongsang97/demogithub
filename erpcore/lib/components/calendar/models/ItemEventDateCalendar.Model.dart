import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class ItemEventDateCalendarModel{
  String? sysCode;
  DateTime? ofDate;
  String? name;
  Color? color;
  String? groupCode;
  dynamic values;
  EventType? type;
  ItemEventDateCalendarModel({this.name,this.sysCode,this.values,this.ofDate,this.color,this.groupCode="none",
    this.type = EventType.DOT
  });

  factory ItemEventDateCalendarModel.fromJson(Map<String, dynamic>? json) {
    late ItemEventDateCalendarModel result;
    try{
      if(json != null){
        result =  ItemEventDateCalendarModel(
          sysCode: json["sysCode"],
          name: json["name"],
          values: json["values"],
        );
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "ItemEventDateCalendarModel.fromJson ItemEventDateCalendar.Model");
    }
    return result;
  }

  static List<ItemEventDateCalendarModel> fromJsonList(List? list) {
    late List<ItemEventDateCalendarModel> result;
    try{
      if(list !=null){
       result = list.map((item) => ItemEventDateCalendarModel.fromJson(item)).toList();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fromJsonList ItemEventDateCalendar.Model");
    }
    return result;
  }
  static  List<Map<String, dynamic>> toJsonList(List<ItemEventDateCalendarModel>? list) {
    late List<Map<String, dynamic>> result;
    try{
      if(list != null){
        result = list.map((item) => item.toJson()).toList();
      }
    } 
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "toJsonList ItemEventDateCalendar.Model");
    }
    return result;
  }

  static Widget handleWidgetEvent(Map<String, dynamic>? json){
    if(json != null){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${json["workDay"]}",style: const TextStyle(fontSize: 8,color: Color(0XFF3369b5),fontWeight: FontWeight.bold),),
            const SizedBox(width: 2,),
            Text("${json["isDayOff"]}",style: const TextStyle(fontSize: 8,color: Color(0XFFcc6327),fontWeight: FontWeight.bold),),
            const SizedBox(width: 2,),
            Text("${json["isDayOT"]}",style: const TextStyle(fontSize: 8,color: Color(0XFF096b29),fontWeight: FontWeight.bold),),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": sysCode,
      "name": name,
      "values": values
    };
    return map;
  }
}

enum EventType{
  DOT,
  WIDGET
}