import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class ResponsesModel {
  int? statusCode = 0;
  String? msg;
  dynamic data;
  dynamic subData;
  int? totalRecord = 0;
  PaginationInfoModel? paging = PaginationInfoModel();
  
  ResponsesModel({this.data,this.msg,this.statusCode,this.subData,this.totalRecord,this.paging});

  static ResponsesModel create() {
    return ResponsesModel(
      statusCode: 0, msg: "", data: "", totalRecord: 0,paging : PaginationInfoModel());
  }

  static List<ResponsesModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ResponsesModel.fromJson(item)).toList();
  }

  static List<Map<String,int>> countElementOccurence(List<ResponsesModel> list){
    List<Map<String,int>> result = List<Map<String,int>>.empty(growable: true);
    try{
      for(var item in list){
        int index = result.lastIndexWhere((element) => element["key"] == (item.statusCode??0));
        if(index>=0){
          result[index]["value"] = (result[index]["value"]??0)+1;
        }
        else{
          result.add({
            "key": item.statusCode??0,
            "value":1
          });
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "countElementOccurence");
    }
    result.sort((a,b)=> a["value"]!.compareTo(b["value"]!));
    return result;
  }

  // priorityStatus = status ưu tiên sử dụng, nếu status nào bằng thì sẽ ưu tiên lấy
  static ResponsesModel mergeFrom(List<ResponsesModel> list,{int priorityStatus = 1}) {
    ResponsesModel result = ResponsesModel.create();
    try{
      String msg ="";
      int status = list.last.statusCode??0;
      var occurrence = countElementOccurence(list);
      for(var item in list){
        if((item.msg??"").isNotEmpty){
          msg+= "${item.msg} \n";
        }
        if(priorityStatus == item.statusCode){
          status = priorityStatus;
        }
      }
      if(priorityStatus == 0){
        status = occurrence.last["key"]??0;
      }

      result.msg = msg;
      result.statusCode = status;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "mergeFrom ResponsesModel");
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "statusCode": (this.statusCode) ?? 0,
      "msg": (this.msg) ?? "",
      "data": (this.data) ?? "",
      "supData": (this.subData) ?? "",
      "totalRecord": (this.totalRecord) ?? 0
    };
    return map;
  }
  static List<Map<String, dynamic>> toJsonList(List<ResponsesModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  factory ResponsesModel.fromJson(Map<String, dynamic>? json) {
    late ResponsesModel result = ResponsesModel();
    if (json != null) {
      result = ResponsesModel(
        statusCode: (json["statusCode"]) ?? 0,
        msg: (json["msg"]) ?? "",
        data: (json["data"]) ?? "",
        subData: (json["subData"]) ?? "",
        totalRecord: (json["totalRecord"]) ?? 0,
      );
    }
    return result;
  }
}
