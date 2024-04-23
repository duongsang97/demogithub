import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class SelectInfoConfigModel {
  String? code;
  bool? readOnly;
  bool? enable;
  bool? isRequired;
  bool? isMultipleSeleted;
  bool? displayType;
  String? lable;
  String? placeholder;
  List<PrCodeName>? srcData;
  List<PrCodeName>? selectedItems;

  SelectInfoConfigModel(
      {this.code,
      this.enable=false,
      this.isMultipleSeleted,
      this.displayType,
      this.lable,
      this.placeholder,
      this.srcData,
      this.readOnly,
      this.selectedItems,this.isRequired=false});

  SelectInfoConfigModel.fromJson(Map<String, dynamic>? json) {
    try{
      if(json != null){
        code = json['code'];
        readOnly = json['readOnly']??false;
        enable = json['enable'];
        isRequired = json['isRequired']??false;
        isMultipleSeleted = json['isMultipleSeleted'];
        displayType = json['displayType'];
        lable = json['lable'];
        placeholder = json['placeholder'];
        if (json['srcData'] != null) {
          srcData = <PrCodeName>[];
          json['srcData'].forEach((v) {
            srcData!.add(new PrCodeName.fromJson(v));
          });
        }
        if (json['selectedItems'] != null) {
          selectedItems = <PrCodeName>[];
          json['selectedItems'].forEach((v) {
            selectedItems!.add(new PrCodeName.fromJson(v));
          });
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "SelectInfoConfigModel.fromJson");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['readOnly'] = this.readOnly;
    data['enable'] = this.enable;
    data['isRequired'] = this.isRequired??false;
    data['isMultipleSeleted'] = this.isMultipleSeleted;
    data['displayType'] = this.displayType;
    data['lable'] = this.lable;
    data['placeholder'] = this.placeholder;
    if (this.srcData != null) {
      data['srcData'] = this.srcData!.map((v) => v.toJson()).toList();
    }
    if (this.selectedItems != null) {
      data['selectedItems'] = this.selectedItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}