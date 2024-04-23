import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/asset/asset.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/services/httpClient.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class AssetProvider extends AppProvider {
  AssetProvider() {
    httpClient = HttpClient.instance.httpClient;
  }

  Future<ResponsesModel> getAssetList({PaginationInfoModel? paginationInfoModel}) async {
    ResponsesModel _result = ResponsesModel.create();
    paginationInfoModel ??=PaginationInfoModel(pageSize: 25);
    var data = {
        "CustomerCodeList": "",
        "ProjectCodeList": "",
        "pageSize": 50,
        "pageNumber": 1,
        "lFrom": 0,
        "lTo": 0,
        "SysStatus": -1,
        "KeyWord": "",
        "LocationCodeList": "",
        "AreaCodeList": "",
        "RegionCodeList": "",
        "AssetStatusCodeList": "",
        "StatusCodeList": "",
        "AttributeItemCodeList": "",
        "SeriNumber": "",
        "QRCode": "",
        "AW": "",
        "rowSelected": ""
    };
    try {
      var responses = await httpClient.post(AppServiceAPIData.getListAsset, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data['data'] != null) {
          _result.statusCode = 0;
          _result.data = AssetModel.fromJsonList(responses.data['data']);
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
      AppLogsUtils.instance.writeLogs(ex,func: "getAssetList Asset.Provider");
    }
    return _result;
  }

  Future<ResponsesModel> getOneAsset({String sysCode = ""}) async {
    ResponsesModel _result = ResponsesModel.create();
    var data = {
      "SysCode" : sysCode
    };
    try {
      var responses = await httpClient.post(AppServiceAPIData.getOneAsset, data: data);
      if (responses.statusCode == 200 && responses.data != null) {
        if (responses.data != null) {
          _result.statusCode = 0;
          _result.data = AssetModel.fromJson(responses.data);
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
      AppLogsUtils.instance.writeLogs(ex,func: "getOneAsset Asset.Provider");
    }
    return _result;
  }
}