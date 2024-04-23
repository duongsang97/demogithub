import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/identification.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';


class IdentificationProvider extends AppProvider {
  IdentificationProvider() {
    httpClient = HttpClient.instance.httpClient;
  }

  Future<ResponsesModel> getInfoTypeAuth({String authType =  "", int type = 0}) async {
    ResponsesModel result = ResponsesModel.create();
    try {
      var data = {
        "type": type,
        "authType": authType,
      };
      var responses = await httpClient.post(AppServiceAPIData.getInfoTypeAuth, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysData"] != null && responses.data["sysCode"] != "1") {
          result.statusCode = 0;
          result.msg = "";
          result.data = IdentificationModel.fromJson(responses.data["sysData"]);
        } else {
          result.statusCode = 1;
          result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
        result.statusCode =1;
        result.msg = responses.data.toString();
      } 
      else {
        result.statusCode = 1;
        result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      result.statusCode = 1;
      result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getInfoTypeAuth Identification.Provider");
    }
    return result;
  }

  Future<ResponsesModel> onCheckAuthCode({String authType =  "", int type = 1, String authCode = ""}) async {
    ResponsesModel result = ResponsesModel.create();
    try {
      var data = {
        "type": type,
        "authType": authType,
        "authCode": authCode,
      };
      var responses = await httpClient.post(AppServiceAPIData.getInfoTypeAuth, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null && responses.data["sysCode"] != "1") {
          result.statusCode = 0;
          result.msg = responses.data["sysName"];
        } else {
          result.statusCode = 1;
          result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
        result.statusCode =1;
        result.msg = responses.data.toString();
      } 
      else {
        result.statusCode = 1;
        result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      result.statusCode = 1;
      result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "onCheckAuthCode Identification.Provider");
    }
    return result;
  }

  Future<ResponsesModel> onCancelAuth2Step({int type = 3}) async {
    ResponsesModel result = ResponsesModel.create();
    try {
      var data = {
        "type": type,
      };
      var responses = await httpClient.post(AppServiceAPIData.getInfoTypeAuth, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null && responses.data["sysCode"] != "1") {
          result.statusCode = 0;
          result.msg = responses.data["sysName"];
        } else {
          result.statusCode = 1;
          result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
        result.statusCode =1;
        result.msg = responses.data.toString();
      } 
      else {
        result.statusCode = 1;
        result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      result.statusCode = 1;
      result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "onCancelAuth2Step Identification.Provider");
    }
    return result;
  }

  Future<ResponsesModel> onVerifyAuthCode({int type = 4, String authCode = ""}) async {
    ResponsesModel result = ResponsesModel.create();
    try {
      var data = {
        "type": type,
        "authCode": authCode,
      };
      var responses = await httpClient.post(AppServiceAPIData.getInfoTypeAuth, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null && responses.data["sysCode"] != "1") {
          result.statusCode = 0;
          result.msg = responses.data["sysName"];
        } else {
          result.statusCode = 1;
          result.msg = responses.data["sysName"];
        }
      }
      else if(responses.statusCode == -1){
        result.statusCode =1;
        result.msg = responses.data.toString();
      } 
      else {
        result.statusCode = 1;
        result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      result.statusCode = 1;
      result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "onCheckAuthCode Identification.Provider");
    }
    return result;
  }
  
}