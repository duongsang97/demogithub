
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:sembast/sembast.dart';

import 'dbConnect.Utility.dart';

class PermissionDBLocal{
  PermissionDBLocal();
  Future<Database> get _db async => await DBConnectUility.instance.database(AppDatas.erpTempLocal.code!);
  final String storeName = "appPermission";
  Future<String> insertOnePermistion(String data,{bool merge =true}) async{
    String result ="";
    try{
      //var store = StoreRef.main();
      var store = stringMapStoreFactory.store(storeName);
      var checkExists = await findOnePermission(data);
      if(checkExists.isEmpty){
        result = await store.add(await _db,{"data":data});
      }
      else{
        if(merge){
          var statusUpdate = await updatePermission(data);
          if(statusUpdate >0){
            result = data;
          }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertOneWorkResult permission.dbLocal");
    }
    return result;
  }
  Future<int> updatePermission(String data) async{
    int result = 0;
    try{
      var store = stringMapStoreFactory.store(storeName);
      result = await store.update(await _db,{"data":data},finder: Finder(filter: Filter.equals("data", data)));
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "updatePermission permission.dbLocal");
    }
    return result;
  }
  // Future<int> insertListWorkResult(List<String> datas) async{
  //   int result =0;
  //   try{
  //     for(var item in datas){
  //         var insertResult = await insertOneWorkResult(item,merge: true);
  //         if(insertResult.isNotEmpty){
  //           result++;
  //         }
  //     }
  //   }
  //   catch(ex){
  //     AppLogsUtils.instance.writeLogs(ex,func: "insertListWorkResult permission.dbLocal");
  //   }
  //   return result;
  // }

  Future<dynamic> insertPermission(String permission) async{
    try{
      var store = stringMapStoreFactory.store(storeName);
      var result = await store.add(await _db,{"data":permission});
      return result;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertPermission permission.dbLocal");
      return null;
    }
  }
 Future<int> insertListPermission(Database? db,List<String> datas,{bool merge=true}) async{
    int result =0;
    try{
      for(var item in datas){
        var insertResult = await insertOnePermistion(item,merge: merge);
        if(insertResult.isNotEmpty){
          result++;
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertListWorking work.dbLocal");
    }
    return result;
  }

  Future<String> findOnePermission(String key) async{
    String result = "";
    try{
      var store = stringMapStoreFactory.store(storeName);
      var _result = await store.findFirst(await _db,finder: Finder(filter: Filter.equals("data",key)));
      if(_result != null && _result.value.isNotEmpty){
        var temp = _result.value;
        result = (temp["data"] as String);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findOnePermission permission.dbLocal");
    }
    return result;
  }

  Future<List<String>> findAllPermission() async{
    List<String> result = List<String>.empty(growable: true);
    try{
      var store = stringMapStoreFactory.store(storeName);
      var _result = await store.find(await _db);
      if(_result.isNotEmpty){
        result = _result.map((e){
          var temp = e.value["data"] as String;
          return temp;
        }).toList();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findAllPermission permission.dbLocal");
    }
    return result;
  }
  Future<bool> removeAllPermission(Database? db) async{
    bool result = false;
    try{
      var store = stringMapStoreFactory.store(storeName);
      var _result = await store.delete(await _db);
      if(_result >0){
       result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "removeAllPermission permission.dbLocal");
    }
    return result;
  }
}