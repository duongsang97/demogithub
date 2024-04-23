
import 'package:dio/dio.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:path/path.dart';

import 'app.Provider.dart';

class ProfileProvider extends AppProvider {
  ProfileProvider() {
    httpClient = HttpClient.instance.httpClient;
  }

  Future<ResponsesModel> faceIdVerify(String path) async{
    ResponsesModel _result = ResponsesModel.create();
    try{
      String _fileName = basename(path);
      FormData formData = FormData.fromMap({"infos":[{"key":"","fileName":"${_fileName}","fileSize":"","field":"faceimg","brief":"","path":"","base64":""}]});
      formData.files.add(MapEntry("faceimg", await MultipartFile.fromFile(path,filename: _fileName),));
      var responses = await httpClient.post(AppServiceAPIData.faceIdVerify,data: formData);
      if(responses.statusCode ==200 && responses.data != null){
       if(responses.data["sysCode"] != null && responses.data["sysCode"] == "0"){
         _result.statusCode =0;
         _result.msg ="Xác thực thành công";
       }
       else{
          _result.statusCode =1;
          _result.msg = responses.data["sysName"];
       }
      }
      else if(responses.statusCode ==-1){
        _result.statusCode =1;
        _result.msg = responses.data.toString();
      }
      else{
        _result.statusCode =1;
        _result.msg = "Server error "+responses.statusCode.toString();
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "faceIdVerify profile.Provider");
    }
    return _result;
  }


  Future<ResponsesModel> deleteAccount() async{
    ResponsesModel _result = ResponsesModel.create();
    try{
      var responses = await httpClient.post(AppServiceAPIData.deleteUserURL,data: {});
      var data = responses.data;
      if(responses.statusCode ==200 && data != null && data["sysCode"] == "0"){
        _result.statusCode = 0;
        _result.msg = data["sysName"];
      }
      else if(responses.statusCode ==200 && data != null && data["sysCode"] != "0"){
         _result.statusCode = 1;
        _result.msg = data["sysName"];
      }
      else{
        _result.statusCode =1;
        _result.msg = "Server error "+responses.statusCode.toString();
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getVersionInfo app.Provider");
    }
    return _result;
  }



}