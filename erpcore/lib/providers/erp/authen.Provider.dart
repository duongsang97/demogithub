import 'dart:math';

import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/models/apps/verify.Model.dart';
// import 'package:erpcore/models/apps/verify.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/localStorage/permission.dbLocal.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';

import '../../utility/permission.utils.dart';

class AuthenProvider extends AppProvider {
  AuthenProvider() {
    httpClient = HttpClient.instance.httpClient;
    
  }

  Future<ResponsesModel> doLogin({String username = "", String password ="",String fingerprintToken ="",String faceID=""}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var deviceInfo = await getDeviceDetails();
      var internetType = await checkInternetConnection();
      var appInfo = await initPackageInfo();
      String fcmToken = PreferenceUtility.getString(AppKey.keyFcmToken);
      String flatform = getPlatform();
      // handle data before request
      Map<String, String> dataLogin = {
        "username": username,
        "password": password,
        "deviceId": deviceInfo.identifier ?? "none",
        "internetType": internetType.connectType,
        "appVersion": appInfo.version,
        "packageName": appInfo.packageName,
        "FingerprintToken":fingerprintToken,
        "faceID":faceID,
        "fcm_token":fcmToken,
        "platform":flatform
      };
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.loginURL, data: dataLogin);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysCode"] == "0") {
          var token = responses.data["sysData"];
          var fileToken = responses.data["fileToken"];
          var tokenResult = await PreferenceUtility.saveString(AppKey.keyERPToken,token);
          var dataForGenToken = responses.data["dataForGenToken"];
          await PreferenceUtility.saveString(AppKey.keyTokenFile,fileToken);
          await PreferenceUtility.saveString(AppKey.usernameLogin,username);
          await PreferenceUtility.saveBool(AppKey.authenOpenStatus,false);
          if (dataForGenToken != null) {
            String authType = dataForGenToken["authType"];
            await PreferenceUtility.saveString(AppKey.authTypeKey,authType);
          }
          if (tokenResult) {
            _result.statusCode = 0;
            _result.msg = "Đăng nhập thành công";
          } else {
            _result.statusCode = 1;
            _result.msg = "Xảy ra lỗi khi lưu trữ khoá, vui lòng kiểm tra lại quyền truy cập!";
          }
        } else if (responses.data["sysCode"] == "1") {
          _result.statusCode = 1;
          _result.msg = responses.data["sysName"];
        } else {
          _result.statusCode = 1;
          _result.msg = "Máy chủ không phản hồi";
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
      AppLogsUtils.instance.writeLogs(ex,func: "doLogin authen.Provider");
    }
    return _result;
  }
  

  Future<ResponsesModel> getUserPermission() async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      httpClient.options.baseUrl = getServerName(true);
      httpClient.options.receiveTimeout = 10000;
      httpClient.options.connectTimeout = 10000;
      var responses = await httpClient.post(AppServiceAPIData.getUserProfileURL, data: {});
      if (responses.statusCode == 200 && responses.data != null) {
        await getAppDomainByPackageName(AppConfig.appPackageName);
        PermissionDBLocal permissionDBLocal = PermissionDBLocal();
        // permissionDBLocal.removeAllPermission(null);
        var _dataEmp = responses.data[0];
        var _dataPermistion = responses.data[1];
        var userTemp = UserInfoModel();
        userTemp.fullName = _dataEmp["value"]["displayName"];
        userTemp.sysCode = _dataEmp["value"]["sysCode"];
        userTemp.userName = _dataEmp["value"]["username"];
        
        var verifyTemp = await getEmpProfile();
        if(verifyTemp.statusCode == 0){
          userTemp.verified = verifyTemp.data.verified;
          userTemp.urlAvatar = verifyTemp.data.urlAvatar;
        }
        var listPer = _dataPermistion["value"].toList();
        List<String> permisionData = List<String>.empty(growable: true);
        for(var item in listPer){
          permisionData.add(item);
        }
        await permissionDBLocal.insertListPermission(null, permisionData);
        PermisstionUtils().init(); // nạp dữ liệu quyền lên static
        _result.statusCode = 0;
        _result.msg = "";
        _result.data = userTemp;
        
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
      AppLogsUtils.instance.writeLogs(ex,func: "getUserPermission authen.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getEmpProfile() async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.getSumDataByCode, data: {});
      if (responses.statusCode == 200 && responses.data != null) {
        UserInfoModel userProfile = UserInfoModel();
        var _dataEmp = responses.data["data"];
        var index = _dataEmp.indexWhere((element)=> element["key"] == "HSNV");
        if(index >=0){
          userProfile.code = _dataEmp[index]["value"]["code"]??"";
          userProfile.fullName = _dataEmp[index]["value"]["name"]??"";
          userProfile.displayName = _dataEmp[index]["value"]["name"]??"";
          userProfile.verified = (_dataEmp[index]["value"]["verified"]??0)==1?true:false;
          userProfile.urlAvatar = _dataEmp[index]["value"]["imageName"]??"";
          userProfile.birthday = _dataEmp[index]["value"]["birthDay"]??"";
          userProfile.empNo = _dataEmp[index]["value"]["empNo"]??"";
          userProfile.district = PrCodeName.fromJson(_dataEmp[index]["value"]["district"]??{});
          userProfile.city = PrCodeName.fromJson(_dataEmp[index]["value"]["city"]??{});
          userProfile.country = PrCodeName.fromJson(_dataEmp[index]["value"]["country"]??{});
          userProfile.ward = PrCodeName.fromJson(_dataEmp[index]["value"]["ward"]??{});
          userProfile.street = _dataEmp[index]["value"]["street"]??"";
          try{
            var listTel = _dataEmp[index]["value"]["listOfTel"]??[];
            userProfile.listNumberPhone = listTel.map<PrCodeName>((e)=>PrCodeName(code: e["tel"],name: e["tel"])).toList();
          }
          catch(ex){}
          try{
            var listAdd = _dataEmp[index]["value"]["listOfEmail"]??[];
            userProfile.listEmail = listAdd.map<PrCodeName>((e)=>PrCodeName(code: e["email"],name: e["email"])).toList();
          }
          catch(ex){}
          
        }
        _result.statusCode = 0;
        _result.msg = "";
        _result.data = userProfile;
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
      AppLogsUtils.instance.writeLogs(ex,func: "getUserProfile authen.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> updatePasswordByUser({required String username,required String email}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses = await httpClient.post(AppServiceAPIData.updatePassword, data: {"username": username,"email":email});
      if (responses.statusCode == 200 && responses.data != null) {
        if(responses.data["sysCode"] == "0"){
          _result.statusCode =0;
          _result.msg = responses.data["sysName"];
        }
        else if(responses.data["sysCode"] == "1"){
          _result.statusCode =1;
          _result.msg = responses.data["sysName"];
        }
      }
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "loginWithFingerprintID authen.Provider");
    }
    return _result;
  }
  Future<ResponsesModel> setPasswordByUser({required String verifyCode,required String newPassword,required String confirmNewPassword,required String email,required String userName}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var body = {"verifyCode": verifyCode,"confirmNewPassword":confirmNewPassword,"newPassword":newPassword,"email":email,"userName":userName};
      var responses = await httpClient.post(AppServiceAPIData.setPassword, data: body);
      if (responses.statusCode == 200 && responses.data != null) {
        if(responses.data["sysCode"] == "0"){
          _result.statusCode =0;
          _result.msg = responses.data["sysName"];
        }
        else if(responses.data["sysCode"] == "1"){
          _result.statusCode =1;
          _result.msg = responses.data["sysName"];
        }
      }
      else {
        _result.statusCode = 1;
        _result.msg = "Server error ${responses.statusCode}";
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "loginWithFingerprintID authen.Provider");
    }
    return _result;
  }


  Future<ResponsesModel> loginWithFingerprintID({required String fingerprintID}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.logInByFingerprintIDURL, data: {"FingerprintID": fingerprintID});
      if (responses.statusCode == 200 && responses.data != null) {
       
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
      AppLogsUtils.instance.writeLogs(ex,func: "loginWithFingerprintID authen.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> registerWithFingerprintID() async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var deviceInfo = await getDeviceDetails();
      var internetType = await checkInternetConnection();
      var appInfo = await initPackageInfo();
      Map<String, String> dataLogin = {
        "deviceId": deviceInfo.identifier ?? "none",
        // "internetType": internetType.connectType,
        // "appVersion": appInfo.version
      };
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.registerFingerprintIDURL, data: dataLogin);
      if (responses.statusCode == 200 && (responses.data["sysCode"] != null && responses.data["sysCode"] == "0")) {
        _result.statusCode =0;
        _result.data = responses.data["sysData"];
      }
      else if(responses.statusCode == 200 && (responses.data["sysCode"] != null && responses.data["sysCode"] == "1")){
        _result.statusCode =1;
        _result.msg = responses.data["sysName"];
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
      AppLogsUtils.instance.writeLogs(ex,func: "registerWithFingerprintID authen.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListStatusVerify() async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var deviceInfo = await getDeviceDetails();
      Map<String, String> dataLogin = {
        "deviceId": deviceInfo.identifier ?? "none",
      };
      // httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.getListStatusVerify, data: dataLogin);
      if (responses.statusCode == 200 && responses.data != null) {
        _result.statusCode =0;
        _result.data = VerifyModel.fromJson(responses.data);
      }
      else if(responses.statusCode == 200 && (responses.data["sysCode"] != null && responses.data["sysCode"] == "1")){
        _result.statusCode =1;
        _result.msg = responses.data["sysName"];
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
      AppLogsUtils.instance.writeLogs(ex,func: "registerWithFingerprintID authen.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> changePassword(String oldPass, String newPass) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var data = {
        "oldPass": oldPass,
        "newPass": newPass
      };
      var responses = await httpClient.post(AppServiceAPIData.changePassword, data: data);
      if (responses.statusCode == 200 && (responses.data["sysCode"] != null && responses.data["sysCode"] == "0")) {
        _result.statusCode =0;
        _result.msg = responses.data["sysName"];
      }
      else if(responses.statusCode == 200 && (responses.data["sysCode"] != null && responses.data["sysCode"] == "1")){
        _result.statusCode =1;
        _result.msg = responses.data["sysName"];
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
      AppLogsUtils.instance.writeLogs(ex,func: "changePassword authen.Provider");
    }
    return _result;
  }

  Future<String?> refreshToken() async {
    String? result;
    try {
      var deviceInfo = await getDeviceDetails();
      var internetType = await checkInternetConnection();
      var appInfo = await initPackageInfo();
      String fcmToken = PreferenceUtility.getString(AppKey.keyFcmToken);
      String flatform = getPlatform();
      var loginInfo = await PermisstionUtils.decryptLoginInfo();
      if(loginInfo == null || (loginInfo["username"] == null || loginInfo["password"] == null)){
        return null;
      }
      // handle data before request
      Map<String, String> dataLogin = {
        "username": loginInfo["username"],
        "password": loginInfo["password"],
        "deviceId": deviceInfo.identifier ?? "none",
        "internetType": internetType.connectType,
        "appVersion": appInfo.version,
        "packageName": appInfo.packageName,
        "fcm_token":fcmToken,
        "platform":flatform
      };
      httpClient.options.baseUrl = getServerName(true);
      var responses = await httpClient.post(AppServiceAPIData.loginURL, data: dataLogin);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data["sysCode"] == "0") {
          var token = responses.data["sysData"];
          var fileToken = responses.data["fileToken"];
          await PreferenceUtility.saveString(AppKey.keyERPToken,token);
          responses.data["dataForGenToken"];
          await PreferenceUtility.saveString(AppKey.keyTokenFile,fileToken);
          await PreferenceUtility.saveString(AppKey.usernameLogin,loginInfo["username"]);
          await PreferenceUtility.saveBool(AppKey.authenOpenStatus,false);
          return token;
        }
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "doLogin authen.Provider");
    }
    return result;
  }
  
}
