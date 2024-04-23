import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/models/apps/taskMng/myTask/myTask.Model.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

import 'app.Provider.dart';

class TaskMngtProvider extends AppProvider {
  TaskMngtProvider() {
    httpClient = HttpClient.instance.httpClient;
  }

  Future<ResponsesModel> getListMyTask(
      {String keyWord = "",
      String CustomerCodeList = "",
      String ProjectCodeList = "",
      String assignCode = "",
      String statusList = "",
      int pageNumber = 1,
      int pageSize = 50}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var data = {
        "pageNumber": pageNumber,
        "TaskStatusCodeList": statusList,
        "AssignCodeList": assignCode,
        "FlowCodeList": "",
        "CustumerCodeList": CustomerCodeList,
        "ProjectCodeList": ProjectCodeList,
        "pageSize": pageSize,
        "SysStatus": -1,
        "KeyWord": keyWord,
        "rowSelected": "",
      };
      var responses = await httpClient.post(AppServiceAPIData.getListMyTask, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["data"] != null) {
          _result.statusCode = 0;
          _result.totalRecord = responses.data["total"];
          _result.data = MyTaskModel.fromJsonList(responses.data["data"]);
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
      AppLogsUtils.instance.writeLogs(ex,func: "getListMyTask taskMngt.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListTaskStatus(
      {String keyWord = "",
      String CustomerCodeList = "",
      String ProjectCodeList = "",
      int pageNumber = 1,
      int pageSize = 50}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses =
          await httpClient.post(AppServiceAPIData.getListTaskStatus, data: {
        "KeyWord": keyWord,
        "SysStatus": 1,
        "pageSize": pageSize,
        "pageNumber": pageNumber
      });
      if (responses.statusCode == 200 && responses.data != null) {
        _result.statusCode = 0;
        _result.data = PrCodeName.fromJsonList(responses.data);
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
      AppLogsUtils.instance.writeLogs(ex,func: "getListTaskStatus taskMngt.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> saveMyTask(MyTaskModel data,List<PrFileUpload> files) async {
    ResponsesModel _result = ResponsesModel.create();
    try {  
      files.removeWhere((element) => element.fileAsset == null);      
      FormData formData = FormData.fromMap({
        'data': jsonEncode(data.toJson()),
      });
      List infosList = List.empty(growable: true);
      for (var file in files) {
        if (file.fileAsset != null && file.fileAsset!.isNotEmpty) {
          try {
            formData.files.addAll([
              MapEntry("files", await MultipartFile.fromFile(file.fileAsset??'',filename: file.fileName)),
            ]);
            var infos = {
              "key" : "",
              "fileName": file.fileName,
              "fileSize": "",
              "field": "taskFile",
              "brief": "",
              "path": "",
              "base64": ""
            };
            infosList.add(jsonEncode(infos));
          } catch (ex) {
            print(ex);
          }
        }
      }
      formData.fields.add(MapEntry("infos", infosList.toString()));
      var responses = await httpClient.post(AppServiceAPIData.saveMyTask, data: formData);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysCode"] != null && responses.data["sysCode"] == "1") {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        } else {
          _result.statusCode = 0;
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
      AppLogsUtils.instance.writeLogs(ex,func: "saveMyTask taskMngt.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getOneTask(
      {String sysCode = ""}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getOneTask, data: {
        "SysCode": sysCode,
      });
      if (responses.data != null) {
        _result.statusCode = 0;
        _result.data = MyTaskModel.fromJson(responses.data);
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
      AppLogsUtils.instance.writeLogs(ex,func: "getOneTask taskMngt.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> updateOneTask({String sysCode = "", int status = 0}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.updateOneTask, data: {
        "SysCode" : sysCode,
        "Status": status,
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysCode"] != null && responses.data["sysCode"] == "1") {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        } else {
          _result.statusCode = 0;
          _result.msg = responses.data["sysName"];
        }
      } else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      } else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "updateOneTask taskMngt.Provider");
    }
    return _result;
  }
}
