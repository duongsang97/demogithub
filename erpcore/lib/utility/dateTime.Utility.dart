import 'dart:io';

import 'package:datetime_setting/datetime_setting.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

import '../datas/appData.dart';
import 'localStorage/systemConfig.utils.dart';
class DateTimeUtils {
  
  PrDate addSecondToPrDate(PrDate srcDate, int second){
    PrDate result =srcDate;
    try{
      DateTime srcDateTime = PrDate.getDate(srcDate);
      var temp =  srcDateTime.add(Duration(seconds: second));
      result = PrDate.setDate(temp);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "addSecondToPrDate DateTimeUtils");
    }
    return result;
  }
  int calculatorDifference(DateTime start, DateTime end){
    int result = 0;
    try{
      result = start.difference(end).inSeconds;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "calculatorDifference DateTimeUtils");
    }
    if(result <0){
      result = result*-1;
    }
    return result;
  }

  Future<ResponsesModel> checkAutoDateTimeConfig() async {
    ResponsesModel result = ResponsesModel(statusCode: 0,msg: "",data: 1);
    try{
      bool timeAuto = await getDateTimeSettingStatus();
      if (!timeAuto) {
        // var currentServerTime = await getServerTime();
        // if(currentServerTime != null){
        //   result = ResponsesModel(statusCode: 3,msg: "Xác minh thời gian server!",data: currentServerTime);
        // }
        // else{
        // }
        result = ResponsesModel(statusCode: 1,msg: "Thời gian thiết bị phải ở trạng thái tự động, vui lòng kiểm tra lại!",data: 0);

      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "checkAutoDateTimeConfig DateTimeUtils");
    }
    return result;
  }

  Future<DateTime?> getServerTime() async{
    try{
      var response = await AppProvider().getCurrentDateTime();
      if(response.statusCode == 0){
        return response.data;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getServerTime");
    }
    return null;
  }

  String dateTimeFormat(DateTime? date,{String formatTime = "yyyy-MM-dd HH:mm:ss", bool isTimeZone = false}){
    String result = "";
    DateTime now = date??DateTime.now();
    result = now.toString();
    try{
      String timeZone = isTimeZone?"UTC ${now.timeZoneOffset.inHours}":"";
      if(isTimeZone){
        result = "${DateFormat(formatTime).format(now)} $timeZone";
      }
      else{
        result = DateFormat(formatTime).format(now);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "dateTimeFormat DateTimeUtils");
    }
    return result;
  }

  Future<bool> getDateTimeSettingStatus() async{
    bool result = false;
    try{
      if(Platform.isAndroid){
        bool timeAuto = await DatetimeSetting.timeIsAuto();
        bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();
        if(timeAuto && timezoneAuto){
          return true;
        }
      }
      else {
        List<String> timeZoneVietName = ["Asia/Ho_Chi_Minh","Asia/Hovd","Asia/Jakarta","Asia/Krasnoyarsk","Asia/Novokuznetsk","Asia/Novosibirsk","Asia/Phnom_Penh","Asia/Pontianak","Asia/Saigon","Asia/Tomsk","Asia/Vientiane","Indian/Christmas","Asia/Bangkok","Asia/Barnaul"];
        var timeZone = await SystemConfigUtils.getConfigByKey(AppDatas.timeZoneData.code??"");
        if(timeZone.isNotEmpty){
          timeZoneVietName = timeZone.split(",");
        }
        
        var timezone = await FlutterNativeTimezone.getLocalTimezone();
        if(timeZoneVietName.contains(timezone)){
          result = true;
        }
      }
      
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getDateTimeSettingStatus");
    }
    return result;
  }

  PrCodeName getFirstAndLastDayOfMonth(DateTime input){
    PrCodeName result = PrCodeName();
    try{
      final first= DateTime(input.year, input.month, 1);
      final last = DateTime(input.year, input.month+1).subtract(const Duration(days: 1));
      result.value = first;
      result.value2 = last;
      result.code = convertDateToInt(date: last).toString();
      result.name = "Tháng ${last.month}/${last.year}";
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getFirstAndLastDayOfMonth");
    }
    return result;
  }
  //18/01/2024 00:00:00:000
  DateTime? getDateFromVNDate(String vnDate,{int? year,int? month,int? day,bool? getTime = false}){
    DateTime? result;
    try{
      if(vnDate.isNotEmpty){
        List<String> dateAndTime = vnDate.split(" ");
        String dateSrc = "";
        String timeSrc = "";
        String? day;
        String? month;
        String? year;
        String? hour;
        String? minute;
        String? second;
        String finalDate ="";
        String finalTime = "";
        for (var el in dateAndTime) {
          if (el.contains("/")) {
            dateSrc = el;
          } else if (el.contains(":")) {
            timeSrc = el;
          }
        }
        // xử lý ngày tháng năm
        if (dateSrc.isNotEmpty) {
          List<String> splitDate = dateSrc.split("/");
          day = splitDate[0].length > 1 ? splitDate[0] : "0${splitDate[0]}";
          month = splitDate[1].length > 1 ? splitDate[1] : "0${splitDate[1]}";
          year = splitDate[2];
          finalDate = "$year-$month-$day";
        }
        // xử lý thời gian
        if (timeSrc.isNotEmpty) {
          List<String> splitTime = timeSrc.split(":");
          hour = splitTime[0].length > 1 ? splitTime[0] : "0${splitTime[0]}";
          minute = splitTime[1].length > 1 ? splitTime[1] : "0${splitTime[1]}";
          if(splitTime.length >2){
            second = splitTime[2].length > 1 ? splitTime[2] : "0${splitTime[2]}";
          }
          finalTime = "$hour:$minute${second!= null?':$second':''}";
        }
        String finalResult = "$finalDate${(getTime==true?" $finalTime":"")}";
        result = DateTime.parse(finalResult);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getDateFromVNDate");
    }
    return result;
  }
  DateTime getDateTimeFromTime(String time, String date){
    DateTime result = DateTime.now(); // format 12:00
    try{
      List<String> tempTime = time.split(":");
      if (tempTime.isNotEmpty) {
        String tempHour = tempTime[0];
        String tempMinute = tempTime[1];
        var temp = "${date}T$tempHour:$tempMinute";
        // DateTime tempDate = DateFormat ("${date}Thh:mm:ss").parse(temp);
        result = DateTime.parse(temp);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getDateFromVNDate");
    }
    return result;
  }
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }
  DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }
  DateTime findLastDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year, 12, 31);
  }
  DateTime findFirstDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year, 1, 1); 
  }

  static int compareTo(DateTime a,DateTime? b,{bool full = false}){
    int result  = 1;
    if(full){
      if(b != null){
        result = a.compareTo(b);
      }
    }
    else{
      if(b !=  null){
        var tempA = DateTime(a.year,a.month,a.day,0,0,0,0);
        var tempB = DateTime(b.year,b.month,b.day,0,0,0,0);
        result = tempA.compareTo(tempB);
      }
    }
    return result;
  }
  static String formatTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'just now';
    } 
    else if ( difference.inMinutes < 10) {
      return '${difference.inMinutes} minutes ago';
    }
    else if ( difference.inMinutes >= 10 && difference.inMinutes < 60) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inHours < 24) {
      return DateFormat('HH:mm').format(timestamp);
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}

enum TimeType{
  DAY,
  SECONDS,
  MINUTE
}