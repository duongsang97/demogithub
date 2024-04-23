import 'dart:convert';

import 'package:erpcore/datas/dateFormatType.Data.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class InputInfoConfigModel{
  bool enable =false;
  String  name ="";
  String? placeholder ="";
  bool? isRequire=false;
  bool? readOnly; // chỉ cho phép xem, không chỉnh sửa
  bool? readFromCamera; // đọc từ camera
  int? verifyData= -1; // nếu -1 thì không xác minh , 1 xác minh qua api
  List<PrCodeName>? inputFormatters;
  int? timeScanQRCode; // số lần được quét qrcode ở chế độ camera
  int? scanNumber; // số lượt đã quét qrcode
  DateFormatType typeDate;
  int? type;
  String? format;
  InputInfoConfigModel({required this.enable,this.isRequire,required this.name,this.placeholder,this.readFromCamera,this.readOnly,this.verifyData,this.inputFormatters,this.timeScanQRCode=0,
    this.scanNumber=0,this.typeDate = DateFormatType.DATETIME,this.type = 0,this.format=""
  });

  static DateFormatType getDateType(int type){
    DateFormatType result = DateFormatType.DATETIME;
    try{
      if(type ==1){
        result = DateFormatType.DATE;
      }
      else if(type ==2){
        result = DateFormatType.TIME;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "InputInfoConfigModel getDateType");
    }
    return result;
  }
  factory InputInfoConfigModel.fromJson(Map<String, dynamic>? json) {
    InputInfoConfigModel result = InputInfoConfigModel(enable: false,name: "");
    try{
      if (json != null){
        result = InputInfoConfigModel(
          enable: (json["enable"])??false,
          name: (json["name"])??"",
          placeholder: (json["placeholder"])??"",
          isRequire: (json["isRequire"])??false,
          readOnly: (json["readOnly"])??true,
          readFromCamera: (json["readFromCamera"])??false,
          verifyData: (json["verifyData"])??-1,
          timeScanQRCode: (json["timeScanQRCode"])??0,
          scanNumber: (json["scanNumber"])??0,
          type: json["type"]??0,
          typeDate: getDateType((json["type"])??0),
          format: (json["format"])??"",
        );
        try{
          result.inputFormatters = PrCodeName.fromJsonList((json["inputFormatters"])??[]);
        }
        catch(ex){
          result.inputFormatters = PrCodeName.fromJsonList(jsonDecode(json["inputFormatters"]));
        }
      }
      
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "InputInfoConfigModel.fromJson");
    }
    return result;
  }

  static InputInfoConfigModel create(){
    return new InputInfoConfigModel(enable: false, name: "Nhập giá trị",placeholder: "Nhập giá trị",isRequire:false);
  }

  static List<InputInfoConfigModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => InputInfoConfigModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "enable": (this.enable),
      "name": (this.name),
      "placeholder": (this.placeholder)??"",
      "isRequire": (this.isRequire)??false,
      "readOnly": (this.readOnly)??true,
      "readFromCamera": (this.readFromCamera)??false,
      "verifyData": (this.verifyData)??-1,
      "timeScanQRCode": timeScanQRCode,
      "scanNumber": scanNumber,
      "type": type,
      "format": format,
      "inputFormatters": jsonEncode(inputFormatters??[])
    };
    return map;
  }
}