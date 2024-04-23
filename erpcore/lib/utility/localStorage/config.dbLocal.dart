import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/localStorage/dbConnect.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:sembast/sembast.dart';

import '../../datas/appData.dart';

class ConfigDBLocal{
  ConfigDBLocal();
  final String storeName = "localFile";
  Future<Database> get _db async => await DBConnectUility.instance.database(AppDatas.erpTempLocal.code!);
  Future<String> insertOneLocalFile(PrCodeName data,{bool merge = true}) async{
    String result ="";
    try{
      //var store = StoreRef.main();
      var store = stringMapStoreFactory.store(storeName);
      String key = data.code??"";
      var checkExists = await findOneLocalFile(key);
      if(PrCodeName.isEmpty(checkExists)){
        result = await store.add(await _db,data.toJson());
      }
      else{
        if(merge){
          var statusUpdate = await updateLocalFile(data);
          if(statusUpdate >0){
            result = key;
          }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertOneWorkResult workResult.dbLocal");
    }
    return result;
  }

  Future<int> updateLocalFile(PrCodeName data) async{
    int result = 0;
    try{
      var store = stringMapStoreFactory.store(storeName);
      String key = data.code??"";
      result = await store.update(await _db,data.toJson(),finder: Finder(filter: Filter.equals("code", key)));
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "updateLocalFile workResult.dbLocal");
    }
    return result;
  }

  Future<PrCodeName> findOneLocalFile(String key) async{
    PrCodeName result = PrCodeName();
    try{
      var store = stringMapStoreFactory.store(storeName);
      //tìm kiếm 1 url trong 1 list store urlImage
      var _result = await store.findFirst(await _db,finder: Finder(filter: Filter.equals("code",key)));
      //nếu có thì trả về kết quả
      if(_result != null && _result.value.isNotEmpty){
        var temp = _result.value;
        result = PrCodeName.fromJson(temp);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findOneConfig config.dbLocal");
    }
    return result;
  }

  

  //thêm 1 đường dẫn vào datalocal
  Future<String> insertOneConfig(PrCodeName data) async{
    String result ="";
    try{
      //Khởi tạo store và gắn vào biến store
      var store = stringMapStoreFactory.store(storeName);
      //Kiểm tra url có tồn tại trong store chưa
      var checkExists = await findOneConfig("code",data.code??"");
      //nếu chưa => thêm url vào store
      if(PrCodeName.isEmpty(checkExists)){
        result = await store.add(await _db,data.toJson());
      }
      else{
        await store.update(await _db, data.toJson(),finder: Finder(filter: Filter.equals("code", data.code)));
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertOneConfig config.dbLocal");
    }
    return result;
  }

  Future<int> insertConfigs(List<PrCodeName> datas) async{
    int result =0;
    try{
      for(var item in datas){
          var insertResult = await insertOneConfig(item);
          if(insertResult.isNotEmpty){
            result++;
          }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "insertConfigs config.dbLocal");
    }
    return result;
  }

  Future<PrCodeName> findOneConfig(String key,String value) async{
    PrCodeName result = PrCodeName();
    try{
      var store = stringMapStoreFactory.store(storeName);
      //tìm kiếm 1 url trong 1 list store urlImage
      var _result = await store.findFirst(await _db,finder: Finder(filter: Filter.and([
        Filter.equals(key,value),
      ])));
      //nếu có thì trả về kết quả
      if(_result != null && _result.value.isNotEmpty){
        var temp = _result.value;
        result = PrCodeName.fromJson(temp);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findOneConfig config.dbLocal");
    }
    return result;
  }
  Future<List<PrCodeName>> findAllConfig(String key,String value) async{
    List<PrCodeName> result = new List<PrCodeName>.empty(growable: true);
    try{
      var store = stringMapStoreFactory.store(storeName);
      var _result = await store.find(await _db,finder: Finder(filter: Filter.equals(key,value)));
      if(_result.isNotEmpty){
        _result.map((e) => result.add(PrCodeName.fromJson(e.value))).toList();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findAllConfig config.dbLocal");
    }
    return result;
  }


   Future<List<PrCodeName>> findKeyWithOutList(List<String> codes) async{
    List<PrCodeName> result = new List<PrCodeName>.empty(growable: true);
    try{
      var store = stringMapStoreFactory.store(storeName);
      var _result = await store.find(await _db,finder: Finder(filter: Filter.not(Filter.inList("code", codes))));
      if(_result.isNotEmpty){
        _result.map((e) => result.add(PrCodeName.fromJson(e.value))).toList();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findAllConfig config.dbLocal");
    }
    return result;
  }

  // syskey --> group chứa các cấu hình 
  Future<List<PrCodeName>> findConfigBySysKey(String sysKey,{String packageName =""}) async{
    List<PrCodeName> result = new List<PrCodeName>.empty(growable: true);
    try{
      var store = stringMapStoreFactory.store(storeName);
      List<Filter> listFillter = [
         Filter.equals("value2",sysKey)
      ];
      if(packageName.isNotEmpty){
        listFillter.add(Filter.equals("value3",packageName));
      }
      var _result = await store.find(await _db,finder: Finder(filter: Filter.and(listFillter)));
      if(_result.isNotEmpty){
        _result.map((e) => result.add(PrCodeName.fromJson(e.value))).toList();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "findAllConfig config.dbLocal");
    }
    return result;
  }

  Future<bool> removeOneConfig(String key,String value) async{
    bool result = false;
    try{
      var store = stringMapStoreFactory.store(storeName);
      var _result = await store.delete(await _db,finder: Finder(filter: Filter.equals(key,value)));
      if(_result >0){
       result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "removeOneConfig config.dbLocal");
    }
    return result;
  }

  Future<int> removeConfigByList(List<String> codes) async{
    int result = 0;
    try{
      var store = stringMapStoreFactory.store(storeName);
      return await store.delete(await _db,finder: Finder(filter:Filter.inList("code", codes)));
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "removeOneConfig config.dbLocal");
    }
    return result;
  }

  Future<bool> removeConfigByGroup(String key) async{
    bool result = false;
    try{
      var store = stringMapStoreFactory.store(storeName);
      var _result = await store.delete(await _db,finder: Finder(filter: Filter.equals("value2",key)));
      if(_result >0){
       result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "removeConfigByGroup config.dbLocal");
    }
    return result;
  }
}