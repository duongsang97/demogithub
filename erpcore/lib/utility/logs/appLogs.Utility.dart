import 'dart:io';

import 'package:erpcore/utility/localStorage/logs.dbLocal.dart';

import '../app.Utility.dart';
import '../localStorage/systemConfig.utils.dart';
import 'package:path/path.dart' as p;
class AppLogsUtils{
  static final AppLogsUtils _appLogs = AppLogsUtils._();
  static AppLogsUtils get instance => _appLogs;
  AppLogsUtils._();

  void writeLogs(dynamic ex,{String func="ROOT"}){
    try{
      var nowDate = DateTime.now();
      LogInfo log = LogInfo(logTime: nowDate,longTime: nowDate.millisecondsSinceEpoch,msg: ex.toString(),functionName:func);
      LogsDBLocal.instance.insertLog(log);

    }
    catch(ex){AppLogsUtils.instance.writeLogs(ex,func: "writeLogs appLogs.Utility");}
  }

  Future<List<String>> get logsPath async{
    List<String> result = List<String>.empty(growable: true);
    try{
      var dbPath = await initializationFolder(SystemConfigUtils.dataDB);
      var dbLogs = "$dbPath/logs";
      final dir = Directory(dbLogs);
      var logs = dir.listSync(recursive: true).whereType<File>();
      for(FileSystemEntity log in logs){
        if(p.extension(log.path) == ".db"){
          result.add(log.path);
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "get logsPath");
    }
    return result;
  }

  Future<String> getLogsWithFile({DateTime? fromDate, DateTime? toDate}) async{
    String result ="";
    try{
      var listLogDB = await logsPath;
      var _data = await LogsDBLocal.instance.findLogsByDate(fromDate: fromDate,toDate: toDate,dbsPath: listLogDB);
      if(_data.isNotEmpty){
        var textLogs = LogInfo.toText(_data);
        var fileName = "logs_${(fromDate??DateTime.now()).millisecondsSinceEpoch}";
        result = await SystemConfigUtils.writeTXTTempFile(fileName, textLogs);
      }
    }
    catch(ex){AppLogsUtils.instance.writeLogs(ex,func: "getLogsWithFile appLogs.Utility");}
    return result;
  }
}
class LogInfo{
  DateTime logTime = DateTime.now();
  String msg="";
  String functionName ="ROOT";
  int? longTime;
  LogInfo({this.functionName="",required this.logTime,this.msg="",this.longTime=0});

  factory LogInfo.fromJson(Map<String, dynamic>? json) {
    late LogInfo result = LogInfo(logTime: DateTime.now());
    if (json != null) {
      result = LogInfo(
        logTime: DateTime.parse(json["logTime"]),
        functionName: (json["functionName"]) ?? "",
        msg: (json["msg"]) ?? "",
        longTime: (json["longTime"]) ?? 0,
      );
    }
    return result;
  }
  static List<LogInfo> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => LogInfo.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<LogInfo>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  static String toText(List<LogInfo>? list) {
    String result ="";
    try{
      if(list != null){
        for(var item in list){
          result+=item.toString()+"\n";
        }
      }
    }
    catch(ex){AppLogsUtils.instance.writeLogs(ex,func: "toText appLogs.Utility");}
    return result;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "logTime": this.logTime.toString(),
      "functionName": this.functionName,
      "msg": this.msg,
      "longTime": this.longTime??logTime.millisecondsSinceEpoch
    };
    return map;
  }
  @override
  String toString(){
    String result = "";
    try{
      result = "${logTime.toString()} | ${functionName.toString()} | ${msg.toString()} | ${longTime.toString()}";
    }
    catch(ex){AppLogsUtils.instance.writeLogs(ex,func: "toString appLogs.Utility");}
    return result;
  }
}