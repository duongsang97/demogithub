import 'dart:async';
import 'dart:io';

import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/localStorage/systemConfig.utils.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/string.utils.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as p;
class DBConnectUility {
  // code --> chưa tên db
  // name --> chứa thư mục lưu db [nếu type = true]
  // value --> chưa Completer 
  // value2 --> chưa type [true --> mỗi ngày 1 db]
  // codeDisplat --> chưa path db
  String logDb = "log.db";
  static final DBConnectUility _singleton = DBConnectUility._();
  static DBConnectUility get instance => _singleton;
  static List<PrCodeName> dbCompleter = List<PrCodeName>.empty(growable: true);

  DBConnectUility._();
  
  void initDatabase(PrCodeName db){
    int index = dbCompleter.indexWhere((element) => element.code == db.code);
    if(index<0){
      dbCompleter.add(PrCodeName(
        code: db.code,
        name: db.name,
        value2: db.value2,
      ));
    }
  }
  void initDatabases(List<PrCodeName> dbs){
    for(var item in dbs){
      initDatabase(item);
    }
  }

   Future<Database> database(String key,{String? dbPath,}) async{
    try{
      if(dbPath != null && dbPath.isNotEmpty && (File(Uri.parse(dbPath).path).existsSync())){
        var db = await databaseFactoryIo.openDatabase(dbPath);
        return db;
      }
      else if(dbPath != null && dbPath.isNotEmpty){
        String localPath = await initializationFolder(SystemConfigUtils.dataDB);
        String path = join(localPath,dbPath);
        if((File(Uri.parse(path).path).existsSync())){
          var db = await databaseFactoryIo.openDatabase(path);
          return db;
        }
      }
      else{
        int index = dbCompleter.indexWhere((element) => element.code == key);
        if (index >=0) {
          //int dateNow = convertDateToInt(date: DateTime.now());
          if(dbCompleter[index].value == null || (dbCompleter[index].codeDisplay??"").isEmpty){
            bool type = dbCompleter[index].value2??false;
            String path = await _openDatabase(dbCompleter[index].code!,type: type,category: dbCompleter[index].name);
            dbCompleter[index].codeDisplay = path;
            dbCompleter[index].value = await databaseFactoryIo.openDatabase(path);
            printInfo(info: "$path initializeDB");
          }
          return dbCompleter[index].value;
        }
        else{
          AppLogsUtils.instance.writeLogs("Can't opent DB $key because it's not exists",func: "database DBConnectUility");
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "database DBConnectUility");
    }
    throw "Can't opent DB $key because it's not exists";
  }
  
  // type = true --> one day one db
  Future<String> _openDatabase(String key,{bool type = false, String? category = "none"}) async {
    String result = "";
    try{
      DateTime now = DateTime.now();
      String localPath = await initializationFolder(SystemConfigUtils.dataDB);
      String datePath = DateTimeUtils().dateTimeFormat(now,formatTime: "yyyyMMdd").trim();
      String? dbPath;
      if(type){
        dbPath = join(localPath,category,datePath,key);
      }
      else{
        dbPath = join(localPath,key);
      }
      result = dbPath;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex);
    }
    return result;
  }

  static String getPathDB(String path) {
    String result = "";
    try{
      List<String> temps = p.split(path);
      int startIndex = temps.lastIndexWhere((element) => element == SystemConfigUtils.dataDB);
      int endIndex = temps.length-1;
      for(int i=startIndex+1; i<=endIndex;i++){
        result += temps[i];
        if(i<endIndex){
          result += "/";
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getPathDB");
      result =path;
    }
    return result;
  }

  Future<List<PrCodeName>> get getDBInfo async{
    List<PrCodeName> result = List<PrCodeName>.empty(growable: true);
    try{
      String localPath = await initializationFolder(SystemConfigUtils.dataDB);
      Directory dir = Directory(localPath);
      var listFile = dir.listSync(recursive: true).whereType<File>();
        for(File f in listFile){
          if(f.existsSync() && f.lengthSync() > 0){
            var pathList = StringUtils().getPathList(f.path);
            String dirofFile = "";
            if(pathList.length > 1){
              var temp = pathList[pathList.length-2]; // lấy phần tử kế cuối
              if(temp != "db" && pathList.length >3){
                dirofFile = "${pathList[pathList.length-4]}/${pathList[pathList.length-3]}/${pathList[pathList.length-2]}";
              }
              else{
                dirofFile = temp; // lấy phần tử kế cuối
              }
              
            }
            result.add(PrCodeName(name:f.path ,code: p.basename(f.path),codeDisplay: dirofFile));
          }
        }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "DBConnectUility.getDBInfo");
    }
    return result;
  }
}