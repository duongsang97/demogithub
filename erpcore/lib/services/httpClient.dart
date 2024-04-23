
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/permission.utils.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:erpcore/utility/route.utils.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient._();
  static HttpClient get instance => _singleton;
  HttpClient._();
  String serverURL = "";
  List<String> whichOutPackage = [PackageName.heinekenPackage,PackageName.heinekenAuditPackage,PackageName.spiralPackage,PackageName.spiralv2Package,PackageName.abbottv2Package,
    PackageName.marsPackage,PackageName.demoAcacyPackage,PackageName.demoSpiralPackage,PackageName.heinekenMTPackage,PackageName.chupachupsPackage,PackageName.pepsiPackage,
    PackageName.sabecoAcacyPackage,PackageName.jtiPackage,PackageName.pernodPackage
  ];
  
  Dio get httpClient {
    if(serverURL.isEmpty){
      if(whichOutPackage.contains(AppConfig.appPackageName)){
        serverURL= getServerName(true,byPackageName: false);
      }
      else{
        serverURL= getServerName(true,byPackageName: true);
      }
    }
    Dio dio = Dio(setupOptionDio(serverURL));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options, RequestInterceptorHandler handler)=> requestInterceptor(options,handler),
      onResponse: (Response response,ResponseInterceptorHandler handler)=>responseInterceptor(response,handler),
      onError: (DioError e, handler)=>errorInterceptor(e,handler)
    ));
    return dio;
  }
  

 Future<dynamic> requestInterceptor( RequestOptions options, RequestInterceptorHandler handler) async
  {
    var token = PreferenceUtility.getString(AppKey.keyERPToken);
    //print(token);
    var infoApp = await initPackageInfo();
    var fcmToken = PreferenceUtility.getString(AppKey.keyFcmToken);
      print("fcm_token: $fcmToken");
      options.headers["appVersion"] = infoApp.version;
      options.headers["appPackageName"] = AppConfig.appPackageName;
      options.headers["deviceOS"] = getPlatform();
      options.headers["fcm_token"] = fcmToken;
      // options.headers['Content-Type']="application/json";
      options.contentType = "application/json";
    if(token.isNotEmpty){
      options.headers["Authorization"] = "Bearer $token";
      print("token: $token");
    }
    return handler.next(options);
  }

   dynamic responseInterceptor(Response response,ResponseInterceptorHandler handler) async {
    try{
      if (response.data!=null && response.data["sysCode"] != null && response.data["sysCode"] == "4") {
        if (response.data["sysName"]!=null&& response.data["sysName"].toString().contains("syssection")) {
          if(PermisstionUtils.loginInfoExits){
            String? newAccessToken = await AuthenProvider().refreshToken();
            if(newAccessToken != null && newAccessToken.isNotEmpty){
              response.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              return handler.resolve(await httpClient.fetch(response.requestOptions));
            }
            else{
              PermisstionUtils.emptyLoginInfo();
              RouteUtils().handleAuthen();
            }
          }
          else{
            RouteUtils().handleAuthen();
          }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "responseInterceptor httpClient");
    }
    return handler.next(response); // continue
  }

  dynamic errorInterceptor(DioError dioError,ErrorInterceptorHandler handler) async{
    Response temp = Response(statusCode: -2,requestOptions: RequestOptions(path: ''));
    temp = Response(statusCode: -1,data:_handleError(dioError), requestOptions: RequestOptions(path: ''));
    return handler.resolve(temp);
  }

  BaseOptions setupOptionDio(String serverURL) {
    return BaseOptions(
      baseUrl: serverURL,
      headers: {
        "Content-Type": "application/json",
        "Accept":"*/*",
        "Access-Control-Allow-Origin": "*",
        "Connection":"keep-alive"
      }
    );
  }
}

String _handleError(DioError dioError) {
    String result = "Kết nối internet không ổn định, vui lòng thử lại !";
    try{
      AppLogsUtils.instance.writeLogs("${jsonEncode(dioError.requestOptions.data)} | ${dioError.error} | ${dioError.requestOptions.baseUrl + dioError.requestOptions.path} | ${jsonEncode(dioError.response?.data)}",func: "_handleError");
      switch (dioError.type) {
        case DioErrorType.response:
          switch (dioError.response!.statusCode){
            case 404:
              result= 'Yêu cầu không tồn tại';
              break;
            case 500:
              result= 'Máy chủ đang bảo trì, vui lòng quay lại sau vài phút [500]';
              break; 
            case 503:
              result= 'Máy chủ đang bảo trì, vui lòng quay lại sau vài phút [503]';
              break;
            case 502:
              result= 'Máy chủ đang bảo trì, vui lòng quay lại sau vài phút [502]';
              RouteUtils().handleAuthen();
              break;
            case 401:
                try{
                  if(dioError.response != null && (dioError.response?.data != null && dioError.response?.data["sysName"] != null)){
                    result = dioError.response?.data["sysName"]!;
                  }
                  else{
                    if(dioError.response == null || (dioError.response != null && dioError.response?.data =="")){
                      result = "Phiên đăng nhập hết hạn, vui lòng đăng nhập lại!";
                      RouteUtils().handleAuthen();
                    }
                    else if(dioError.response != null && dioError.response?.data != null && dioError.response?.data != String && dioError.response?.data["sysCode"] == "4")
                    {
                      result = "Phiên đăng nhập hết hạn, vui lòng đăng nhập lại!";
                      if(dioError.response?.data["sysName"] != null && dioError.response?.data["sysName"] != ""){
                        result =dioError.response?.data["sysName"]??"Phiên đăng nhập hết hạn, vui lòng đăng nhập lại!";
                        RouteUtils().handleAuthen();
                      }
                    }
                  }
              }
              catch(ex){
                result = ex.toString();
              }
              break;
          }
          break;
        case DioErrorType.cancel:
          result = 'Kết nối bị đóng ! [cancel]';
          break;
        case DioErrorType.connectTimeout:
          result = 'Kết nối internet không ổn định, vui lòng thử lại ! [connectTimeout]';
          break;
        case DioErrorType.receiveTimeout:
          result = 'Kết nối internet không ổn định, vui lòng thử lại ! [receiveTimeout]';
          break;
        case DioErrorType.sendTimeout:
          result = 'Kết nối internet không ổn định, vui lòng thử lại ! [sendTimeout]';
          break;
        case DioErrorType.other:
          if ((dioError.message).contains("SocketException")) {
            result = 'Không có kết nối internet, vui lòng kết nối lại ! ${dioError.error}';
          }
          else{
            result = "Kết nối internet không ổn định, vui lòng thử lại ${dioError.error}!";
          }
          break;
        default:
        return 'Kết nối internet không ổn định, vui lòng thử lại !${dioError.error}';
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "_handleError httpClient");
    }
    return result;
  }
