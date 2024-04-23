import 'dart:math';

import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/models/apps/signature/signatureAvailable.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'dart:convert';
import 'package:dio/src/form_data.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:dio/src/multipart_file.dart';

class DocumentProvider extends AppProvider {
  DocumentProvider() {
    httpClient = HttpClient.instance.httpClient;
  }

  Future<ResponsesModel> saveSignature(SignatureAvailableModel signature, PrFileUpload file, {bool isUpdate = false}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var data = {
        "editMode": signature.editMode,
        "sysCode": signature.sysCode,
        "code": signature.code,
        "name": signature.name,
        "username": signature.username,
        "email": signature.email,
        "p12Url": signature.p12Url,
        "files": [],
        "note": signature.note,
        "imageName": signature.imageName,
        "IsNew": signature.isNew,
        "TypeSign": signature.typeSign,
      };
      if (isUpdate) {
        data = signature.toJson();
      }
      FormData formData = FormData.fromMap({
        "data":jsonEncode(data)
      });
      List infosList = List.empty(growable: true);
      // for (var file in listFiles) {
      if (file.fileAsset != null && file.fileAsset!.isNotEmpty) {
        try {
          formData.files.addAll([
            MapEntry("files", await MultipartFile.fromFile(file.fileAsset??'',filename: file.fileName)),
          ]);
          var infos = {
            "key" : "",
            "fileName": file.fileName,
            "fileSize": "",
            "field": file.kind?.code,
            "brief": "",
            "path": "",
            "base64": ""
          };
          infosList.add(jsonEncode(infos));
        } catch (ex) {
          print(ex);
        }
      }
      // }
      formData.fields.add(MapEntry("infos", infosList.toString()));
      var responses = await httpClient.post(AppServiceAPIData.saveSignature, data: formData);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysCode"] != null && responses.data["sysCode"] == "1") {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        } else {
          _result.statusCode = 0;
          _result.msg = responses.data["sysName"];
          _result.data = responses.data["sysData"];
        }
      }
      else if(responses.statusCode == -1){
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
      AppLogsUtils.instance.writeLogs(ex,func: "saveSignature document.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> updateStatusSignature({String sysCode =  "", int status = 0}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var data = {
        "SysCode": sysCode,
        "Status": status,
      };
      var responses = await httpClient.post(AppServiceAPIData.updateSignature, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null && responses.data["sysCode"] != "1") {
          _result.statusCode = 0;
          _result.msg = responses.data["sysName"];
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
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
      AppLogsUtils.instance.writeLogs(ex,func: "updateStatusSignature document.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getSignatureList({PaginationInfoModel? paginationInfoModel}) async {
    ResponsesModel _result = ResponsesModel.create();
    paginationInfoModel ??=PaginationInfoModel(pageSize: 25);
    var data = {
        "pageSize":paginationInfoModel.pageSize,
        "pageNumber": paginationInfoModel.page,
        "sysKey":"",
        "SysStatus":-1,
        "lFrom":0,
        "lTo":0,
        "rowSelected":"",
        "KeyWord":"",
    };
    try {
      var responses = await httpClient.post(AppServiceAPIData.getListSignature, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data['data'] != null) {
          _result.statusCode = 0;
          _result.data = SignatureAvailableModel.fromJsonList(responses.data['data']);
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
        _result.paging = PaginationInfoModel.fromJson(responses.data, paginationInfoModel);
      }
      else if(responses.statusCode == -1){
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
      AppLogsUtils.instance.writeLogs(ex,func: "getSignatureList document.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getOneSignature({String sysCode =  "",}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var data = {
        "SysCode": sysCode,
      };
      var responses = await httpClient.post(AppServiceAPIData.getOneDataSignature, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null && responses.data["sysCode"] != "1") {
          _result.statusCode = 0;
          _result.data = SignatureAvailableModel.fromJson(responses.data);
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
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
      AppLogsUtils.instance.writeLogs(ex,func: "getOneSignature document.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListUser({int page =1, int pageSize = 15,String keyword = ""}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var data = {
        "KeyWord": keyword,
        "SysStatus": 1,
        "pageSize": pageSize,
        "pageNumber": page,
      };
      var responses = await httpClient.post(AppServiceAPIData.getListUser, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data['data'] != null) {
          _result.statusCode = 0;
          _result.data = PrCodeName.fromJsonList(responses.data['data']);
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
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
      AppLogsUtils.instance.writeLogs(ex,func: "getListUser document.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getDefaultImageSign({String position = "", String name = "", String content = "Duyệt bởi"}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getDefaultImageSign, data: {
          "Position":position,
          "Name":name,
          "Content": content,
          "Width":250,
          "Height": 120
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null && responses.data["sysCode"] != "1") {
          _result.statusCode = 0;
          _result.data = responses.data['sysData'];
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
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
      AppLogsUtils.instance.writeLogs(ex,func: "getDefaultImageSign document.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getPositionByUser({String sysCode = ""}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getPositionByUser, data: {
        "SysCode": sysCode
      });
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null && responses.data["sysCode"] != "1") {
          _result.statusCode = 0;
          _result.data = responses.data['sysData'];
        } else {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
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
      AppLogsUtils.instance.writeLogs(ex,func: "getPositionByUser document.Provider");
    }
    return _result;
  }
}