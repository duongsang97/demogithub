import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/chats/messageSending.Model.dart';
import 'package:erpcore/models/apps/chats/userChatInfo.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

import 'app.Provider.dart';

class ChatProvider extends AppProvider{
  ChatProvider(){
    httpClient = HttpClient.instance.httpClient;
  }

  Future<ResponsesModel> getMessageData({String? sender,String? receiver}) async{
    ResponsesModel _result = ResponsesModel.create();
    try{
      var responses = await httpClient.post(AppServiceAPIData.notifySearch,data: {
        "pageNumber":0,
        "pageSize":50,
        "sysKey":"",
        "SysStatus":-1,
        "KeyWord":"",
        "sender":sender,
        "receiver":receiver,
        "receiverChanel":getChatChannelByServer(),
        "type":0,
        "refData":"",
      });
      if(responses.statusCode ==200 && responses.data != null){
       if(responses.data["data"] != null){
         _result.statusCode =0;
         _result.totalRecord = responses.data["total"];
        _result.data = MessageSendingModel.fromJsonList(responses.data["data"]);
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
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getMessageData chat.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getListUser({String? keyword,PaginationInfoModel? pagingData}) async{
    ResponsesModel _result = ResponsesModel.create();
    pagingData ??= PaginationInfoModel(page: 1,pageSize: 20);
    try{
      var responses = await httpClient.post(AppServiceAPIData.notifyUsersURL,data: {
        "pageNumber": pagingData.page, 
        "pageSize": pagingData.pageSize, 
        "sysKey": "", 
        "SysStatus": -1, 
        "KeyWord": keyword
      });
      if(responses.statusCode ==200 && responses.data != null){
       if(responses.data["data"] != null){
        _result.statusCode =0;
        _result.totalRecord = responses.data["total"];
        _result.data = UserChatInfoModel.fromJsonList(responses.data["data"]);
        _result.paging = PaginationInfoModel.fromJson(responses.data, pagingData);
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
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListUser chat.Provider");
    }
    return _result;
  }
  Future<ResponsesModel> getListChat({String? keyword,PaginationInfoModel? pagingData}) async{
    ResponsesModel _result = ResponsesModel.create();
    pagingData ??= PaginationInfoModel(page: 1,pageSize: 20);
    try{
      var responses = await httpClient.post(AppServiceAPIData.notifyUsersv2URL,data: {
        "pageNumber": pagingData.page, 
        "pageSize": pagingData.pageSize, 
        "sysKey": "", 
        "SysStatus": -1, 
        "KeyWord": keyword
      });
      if(responses.statusCode ==200 && responses.data != null){
       if(responses.data["data"] != null){
        _result.statusCode =0;
        _result.totalRecord = responses.data["total"];
        _result.data = UserChatInfoModel.fromJsonList(responses.data["data"]);
        _result.paging = PaginationInfoModel.fromJson(responses.data, pagingData);
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
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "getListUser chat.Provider");
    }
    return _result;
  }
  Future<ResponsesModel> sendMessage({String? content,String? receiver,String? receiverChanel}) async{
    ResponsesModel _result = ResponsesModel.create();
    try{
      var data = {
        "sysCode":"",
        "type":0,
        "content":content,
        "receiver":receiver,
        "receiverChanel":getChatChannelByServer(),
        "readerTracks":[],
        "owner":false,
        "refData":"",
        "IsNew":1
      };
      httpClient.options.baseUrl = "https://${getChatChannelByServer()}/api/";
      var responses = await httpClient.post(AppServiceAPIData.notifymessageURL,data: data);
      if(responses.statusCode ==200){
       if(responses.data != null && responses.data["sysCode"] == "0"){
         _result.statusCode =0;
         _result.msg = responses.data["sysName"];
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
        _result.msg = "Server error ${responses.statusCode}";
      }
    }
    catch(ex){
      _result.statusCode =1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "sendMessage chat.Provider");
    }
    return _result;
  }
}