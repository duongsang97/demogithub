import 'dart:io';

import 'package:dio/dio.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/appVersion.Model.dart';
import 'package:erpcore/models/apps/carouselItem.Model.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:path_provider/path_provider.dart';

class AppProvider{
  Dio httpClient = HttpClient.instance.httpClient;
  AppProvider(){
  }

  Future<ResponsesModel> getVersionInfo(String packageName) async{
    ResponsesModel _result = ResponsesModel.create();
    try{
      httpClient.options.receiveTimeout = 30000;//Duration(seconds: 30);
      httpClient.options.connectTimeout = 10000;//Duration(seconds: 10);
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.checkVersionAppURL,data: {"code":packageName});
      if(responses.statusCode ==200 && responses.data != null){
        _result.statusCode =0;
        _result.msg="";
        _result.data = AppVersionModel.fromJson(responses.data);
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      }
      else if(responses.statusCode ==-2){
        _result.statusCode =2;
        _result.msg = responses.data.toString();
      }
      else{
        _result.statusCode =1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getVersionInfo app.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getAppDomainByPackageName(String packageName) async{
    ResponsesModel _result = ResponsesModel.create();
    try{
      httpClient.options.receiveTimeout = 30000;//Duration(seconds: 30);
      httpClient.options.connectTimeout = 7000;//Duration(seconds: 10);
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.getAppDomain,data: {"code":packageName});
      if(responses.statusCode ==200 && responses.data != null){
        PreferenceUtility.saveString('rootHostURL', responses.data??"");
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      }
      else if(responses.statusCode ==-2){
        _result.statusCode =2;
        _result.msg = responses.data.toString();
      }
      else{
        _result.statusCode =1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getVersionInfo app.Provider");
    }
    return _result;
  }


  Future<ResponsesModel> getNewsData() async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getListProcessURL, data: {});
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["data"] != null) {
          _result.statusCode = 0;
          _result.msg = "";
          _result.data = NotificationInfoModel.fromJsonList(responses.data["data"]);
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getNewsData app.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getCurrentDateTime() async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getCurrentDateTimeServer, data: {});
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysCode"] != null && responses.data["sysCode"]  =="1") {
          _result.statusCode = 1;
          _result.msg = responses.data["sysCode"] ;
        } else {
          _result.statusCode = 0;
          _result.data =  PrDate.fromJson(responses.data);
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getCurrentDateTime app.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getAppConfig({required String sysKey}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      httpClient.options.receiveTimeout = 30000;//Duration(seconds: 30);
      httpClient.options.connectTimeout = 10000;//Duration(seconds: 3);
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.getAppConfig, data: {"sysKey": sysKey});
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data['data'] != null) {
          _result.statusCode = 0;
          _result.totalRecord =  responses.data["total"];
          _result.data = PrCodeName.fromJsonList(responses.data['data']);
        } 
        else {
          _result.statusCode = 1;
          _result.msg = "";
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getAppConfig app.Provider");
    }
    return _result;
  }

// lấy danh sách config của module activation
  Future<ResponsesModel> getProgramConfig({required String sysKey}) async {
    ResponsesModel _result = ResponsesModel.create();
    try{
      httpClient.options.connectTimeout = 30000;//Duration(seconds: 3);
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.actGetProgramConfig, data: {"sysKey": sysKey});
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["total"] != null && responses.data["total"] >0) {
          _result.statusCode = 0;
          _result.totalRecord = responses.data["total"];
          _result.data = PrCodeName.fromJsonList(responses.data["data"]);
        } 
        else if(responses.data['sysCode'] =="2"){
          _result.statusCode = 2;
          _result.msg = "";
        }
        else {
          _result.statusCode = 1;
          _result.msg = "";
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getProgramConfig app.Provider");
    }
    return _result;
  }
  
  Future<ResponsesModel> getListAds({String? screenID,String? position}) async {
    ResponsesModel _result = ResponsesModel.create();
    try{
      var responses = await httpClient.post(AppServiceAPIData.getListAds, data: {
        "pageNumber": 1, 
        "pageSize": 50, 
        "PackageID": AppConfig.appPackageName,
        "ScreenID":screenID,
        "Position":position 
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data['data'] != null) {
          _result.statusCode = 0;
          _result.totalRecord =  responses.data["total"];
          _result.data = CarouselItemModel.fromJsonList(responses.data['data']);
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListAds app.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListCustomer({String keyword = "",int sysStatus = 1,int pageNumber = 1,int pageSize = 10}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses =
          await httpClient.post(AppServiceAPIData.empsearchcustomer, data: {
        "KeyWord": keyword,
        "SysStatus": sysStatus,
        "delay": 139,
        "pageNumber": pageNumber,
        "pageSize": pageSize
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["data"] != null) {
          _result.statusCode = 0;
          _result.msg = "";
          _result.data = PrCodeName.fromJsonList(responses.data["data"]);
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListCustomer md5s.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListProgramByUser({String keyword = "",int sysStatus = 1,int pageNumber = 1,int pageSize = 10}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getListProgramAct, data: {
        "KeyWord": keyword,
        "SysStatus": sysStatus,
        "delay": 139,
        "pageNumber": pageNumber,
        "pageSize": pageSize
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["data"] != null) {
          _result.statusCode = 0;
          _result.msg = "";
          _result.data = responses.data["data"].map<PrCodeName>((e)=> PrCodeName(code: e["code"],name: e["name"])).toList();

        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListCustomer md5s.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListCustomerByUser({String keyword = "",int sysStatus = 1,int pageNumber = 1,int pageSize = 10}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getListCustomerAct, data: {
        "KeyWord": keyword,
        "SysStatus": sysStatus,
        "delay": 139,
        "pageNumber": pageNumber,
        "pageSize": pageSize
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["data"] != null) {
          _result.statusCode = 0;
          _result.msg = "";
          _result.data = PrCodeName.fromJsonList(responses.data["data"]);

        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListCustomer md5s.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListProject(
      {String keyword = "",
      int sysStatus = 1,
      int pageNumber = 1,
      int pageSize = 10,
      String customerCodeList = ""}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses =
          await httpClient.post(AppServiceAPIData.empsearchproject, data: {
        "KeyWord": keyword,
        "SysStatus": sysStatus,
        "delay": 139,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "CustomerCodeList": customerCodeList
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["data"] != null) {
          _result.statusCode = 0;
          _result.msg = "";
          _result.data = PrCodeName.fromJsonList(responses.data["data"]);
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListProject md5s.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> downloadFile(String urlFile,{String? savePath,Function(int, int)? onReceiveProgress,}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {

      Directory? baseDir = await getTemporaryDirectory();
      savePath??= baseDir.path;
      var responses = await httpClient.downloadUri(Uri.parse(urlFile),savePath);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysCode"] != null && responses.data["sysCode"] == "0") {
          _result.statusCode = 0;
          _result.msg = "";
          _result.data = PrCodeName.fromJson(responses.data["sysData"]);
        } 
        else if(responses.data["sysCode"] != null && responses.data["sysCode"] == "1"){
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListProgramInv actInventory.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> searchUserByCompany({String keyWord = "",String customerCodeList = "",String projectCodeList = "",int pageNumber = 1,int pageSize = 50}) async {
    ResponsesModel _result = ResponsesModel.create();
    List tmpList = [];
    try {
      var responses = await httpClient.post(AppServiceAPIData.searchUserByCompany, data: {
        "pageNumber": pageNumber,
        "CustomerCodeList": customerCodeList,
        "ProjectCodeList": projectCodeList,
        "pageSize": pageSize,
        "SysStatus": 1,
        "KeyWord": keyWord,
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["data"] != null) {
          _result.statusCode = 0;
          _result.totalRecord = responses.data["total"];
          List<PrCodeName> listUser = List<PrCodeName>.empty(growable: true);
          for (var i in responses.data["data"]) {
            var temp = PrCodeName(code: i['sysCode'],name: i['displayName'],codeDisplay:i['username']);
            listUser.add(temp);
          }
          _result.data = listUser;
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } 
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "searchUserByCompany taskMngt.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> scannerOnlineCheck(PrCodeName? param,{String? inputData}) async{
    ResponsesModel _result = ResponsesModel(statusCode: -3);
    try{
      if(!PrCodeName.isEmpty(param)){
        httpClient.options.receiveTimeout = 3000;//Duration(seconds: 30);
        httpClient.options.connectTimeout = 3000;//Duration(seconds: 10);
        httpClient.options.baseUrl = getServerName(true);
        Map<String,dynamic> data = (param!.value as Map<String,dynamic>);
        data.addAll({"data":inputData});
        var responses = await httpClient.post(param.name!,data: data);
        if(responses.statusCode ==200 && responses.data != null ){
          if(responses.data["sysCode"] == "0")
          {
            _result.statusCode =2;
            _result.msg= responses.data["sysName"];
          }
          else if(responses.data["sysCode"] == "1"){
            _result.statusCode =-2;
            _result.msg= responses.data["sysName"];
          }
        }
        else{
          _result.statusCode =-3;
          _result.msg = "Server error ${responses.statusCode}";
        }
      }
    }
    catch(ex){
      _result.statusCode =-3;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getVersionInfo app.Provider");
    }
    return _result;
  }
}
