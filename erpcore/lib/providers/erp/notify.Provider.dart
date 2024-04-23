import 'dart:convert';

import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class NotifyProvider extends AppProvider{
  NotifyProvider() {
    httpClient = HttpClient.instance.httpClient;
  }
  Future<ResponsesModel> getTagsListNotify() async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses =await httpClient.post(AppServiceAPIData.getListTagNotify, data:{});
      if (responses.statusCode == 200) {
        var _data = responses.data;
        if(_data != null && _data["data"] != null){
          _result.statusCode =0;
          _result.data = PrCodeName.fromJsonList(_data["data"]);
        }
        else if(_data != null && _data["sysCode"] != null && _data["sysCode"] == "1"){
          _result.statusCode =1;
          _result.msg = _data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      }
      else {
        _result.statusCode = 1;
        _result.msg = "Server error " + responses.statusCode.toString();
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getTagsListNotify notify.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListNotify({int? pageNumber =1,int? pageSize=50,String tagCodeList ="",int status =-1}) async {
    ResponsesModel _result = ResponsesModel(statusCode: 1);
    try {
      var responses =await httpClient.post(AppServiceAPIData.getListNotify, data:{
        "tagCodeList":tagCodeList,
        "status":status,
        "AppPackage": AppConfig.appPackageName,
        "pageNumber":pageNumber,"pageSize":pageSize,
      });
      if (responses.statusCode == 200) {
        var _data = responses.data;
        if(_data != null && _data["data"] != null){
          _result.statusCode =0;
          _result.totalRecord =  _data["total"];
          _result.data = NotificationInfoModel.fromJsonList(_data["data"]);
        }
        else if(_data != null && _data["sysCode"] != null && _data["sysCode"] == "1"){
          _result.statusCode =1;
          _result.msg = _data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      }
      else {
        _result.statusCode = 1;
        _result.msg = "Server error " + responses.statusCode.toString();
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListNotify notify.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> updateStatusNotify({List<String>? listSysCode , int status =1}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses =await httpClient.post(AppServiceAPIData.getListTagNotify, data:{
        "listSysCode": jsonEncode(listSysCode??[]),
        "status":status
      });
      if (responses.statusCode == 200) {
        var _data = responses.data;
        if(_data != null && _data["sysCode"] != null && _data["sysCode"] == "0"){
          _result.statusCode =0;
          _result.msg = _data["sysName"];
        }
        else if(_data != null && _data["sysCode"] != null && _data["sysCode"] == "1"){
          _result.statusCode =1;
          _result.msg = _data["sysName"];
        }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      }
      else {
        _result.statusCode = 1;
        _result.msg = "Server error " + responses.statusCode.toString();
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "updateStatusNotify notify.Provider");
    }
    return _result;
  }
}