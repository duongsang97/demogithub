import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/attendant/dateoffinfo.Model.dart';
import 'package:erpcore/models/apps/attendant/offDateResult.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class AttendantProvider extends AppProvider {
  AttendantProvider() {
    httpClient = HttpClient.instance.httpClient;
  }

Future<ResponsesModel> getListTimeSlot({String keyword = " ", int sysStatus = 1, int pageNumber = 1,int pageSize = 10,}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses =await httpClient.post(AppServiceAPIData.getlisttimeslot, data: {
        "KeyWord": keyword,
        "SysStatus": sysStatus,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
    
      });
      if (responses.statusCode == 200 && responses.data != null) {
          _result.statusCode = 0;
          _result.msg = "";
          _result.data = PrCodeName.fromJsonList(responses.data);
      }
      else if(responses.data != null && responses.data["sysCode"] == "1"){
        _result.statusCode = 1;
        _result.msg = responses.data["sysName"];
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
      AppLogsUtils.instance.writeLogs(ex,func: "getListTimeSlot attendant.Provider");
    }
    return _result;
  }
Future<ResponsesModel> getListTypeDayOff({String keyword = " ", int sysStatus = 1, int pageNumber = 1,int pageSize = 10,}) async {
    ResponsesModel _result = ResponsesModel.create();
    try {
      var responses =await httpClient.post(AppServiceAPIData.getlisttypedayoff, data: {
        "KeyWord": keyword,
        "SysStatus": sysStatus,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      });
      if (responses.statusCode == 200 && responses.data != null) {
          _result.statusCode = 0;
          _result.data = PrCodeName.fromJsonList(responses.data);
      }
        else if(responses.data != null && responses.data["sysCode"] == "1"){
        _result.statusCode = 1;
        _result.msg = responses.data["sysName"];
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
      AppLogsUtils.instance.writeLogs(ex,func: "getListTypeDayOff attendant.Provider");
    }
    return _result;
  }
Future<ResponsesModel> saveRequestOff(DateOffInfo InputData)async{
  ResponsesModel _result = ResponsesModel.create();
    try {
      InputData.isnew =1;
      var responses =await httpClient.post(AppServiceAPIData.empsavedayoff, data: InputData.toJson());
      if (responses.statusCode == 200 && responses.data != null) {
        if ( responses.data["sysCode"]=="0") {
          _result.statusCode =0;
          _result.msg = responses.data["sysName"];
        }  
        else {
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
        _result.msg = "Server error " + responses.statusCode.toString();
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "saveRequestOff attendant.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> searchOffDateByUser(PrDate fromDate,PrDate toDate) async{
    ResponsesModel _result = ResponsesModel.create();
    try {
      var data = {  
        "pageNumber":1,
        "pageSize":50,
        "sysKey":"",
        "SysStatus":1,
        "fromDate" : fromDate.toJson(),
        "toDate": toDate.toJson(),
        "lTo":toDate.lD,
        "lFrom":fromDate.lD,
      };
      var responses =await httpClient.post(AppServiceAPIData.empDayOffByUser, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if ( responses.data["data"] !=null) {
          _result.statusCode =0;
          _result.data = OffDateResultModel.fromJsonList(responses.data["data"]);
        }  
        else {
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
        _result.msg = "Server error " + responses.statusCode.toString();
      }
    } catch (ex) {
      _result.statusCode = 1;
      _result.msg = ex.toString();
      AppLogsUtils.instance.writeLogs(ex,func: "searchOffDateByUser attendant.Provider");
    }
    return _result;
  }
}
