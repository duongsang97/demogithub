import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/localStorage/dbConnect.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:sembast/sembast.dart';

class LogsDBLocal{
  static final LogsDBLocal _logsDBLocal = LogsDBLocal._();
  static LogsDBLocal get instance => _logsDBLocal;
  String storeName = "logs";
  LogsDBLocal._();
  Future<Database> get _db async => await DBConnectUility.instance.database(AppDatas.logsDb.code!);
  
  Future<String> insertLog(LogInfo data) async{
    String result ="";
    try{
      var store = stringMapStoreFactory.store(storeName);
      result = await store.add(await _db,data.toJson());
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertLog logs.dbLocal");
    }
    return result;
  }
  
  Future<int> insertLogs(List<LogInfo> datas) async{
    int result =0;
    try{
      for(var item in datas){
          var insertResult = await insertLog(item);
          if(insertResult.isNotEmpty){
            result++;
          }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertLogs logs.dbLocal");
    }
    return result;
  }

  // tìm kiếm bản ghi theo ngày
  Future<List<LogInfo>> findLogsByDate({DateTime? fromDate,DateTime? toDate,List<String>? dbsPath}) async{
     List<LogInfo> result = List<LogInfo>.empty(growable: true);
    try{
      var store = stringMapStoreFactory.store(storeName);
      List<Filter> filter = List<Filter>.empty(growable: true);
      // if(fromDate != null){
      //   filter.add(
      //     Filter.greaterThanOrEquals("longTime", fromDate.millisecondsSinceEpoch)
      //   );
      // }
      // if(toDate != null){
      //   filter.add(
      //     Filter.lessThanOrEquals("longTime", toDate.millisecondsSinceEpoch)
      //   );
      // }
      var finder = Finder(
        filter: Filter.and(filter),
        sortOrders: [SortOrder("longTime")]
      );
      if(dbsPath != null && dbsPath.isNotEmpty){
        for(var dbPath in dbsPath){
          var dbTemp = await DBConnectUility.instance.database("",dbPath: dbPath);
          var dbResult = await store.find(dbTemp,finder: finder);
          if(dbResult.isNotEmpty){
            result += dbResult.map((e) => LogInfo.fromJson(e.value)).toList();
          }
        }
      }
      else{
        var dbResult = await store.find(await _db,finder: finder);
        if(dbResult.isNotEmpty){
          result = dbResult.map((e) => LogInfo.fromJson(e.value)).toList();
        }
      }
      
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findLogsByDate logs.dbLocal");
    }
    return result;
  }

  // lấy danh sách công việc theo mã working plan
  // Future<List<WorkingActModel>> findAllLogs(String sysCodeWP) async{
  //   List<WorkingActModel> result = List<WorkingActModel>.empty(growable: true);
  //   try{
  //     var store = stringMapStoreFactory.store(storeName);
  //     var _result = await store.find(await _db,finder: Finder(sortOrders: [SortOrder("longTime",false,false)]));
  //     if(_result.isNotEmpty){
  //       result = _result.map((e) => WorkingActModel.fromJson(e.value)).toList();
  //     }
  //   }
  //   catch(ex){
  //     AppLogsUtils.instance.writeLogs(ex,func: "findAllLogs logs.dbLocal");
  //   }
  //   return result;
  // }

  Future<int> removeAllLogs({int? endDate}) async{
    int result = 0;
    try{
      int longDate = 0;
      if(endDate != null){
        longDate = DateTime.parse(convertIntToDate(endDate.toString())).millisecondsSinceEpoch;
      }
      var _filter = Finder(filter: Filter.lessThanOrEquals("longTime", longDate));
      var store = stringMapStoreFactory.store(storeName);
      result = await store.delete(await _db,finder:_filter);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "removeAllWorkingPlan workingPlan.dbLocal");
    }
    return result;
  }
}