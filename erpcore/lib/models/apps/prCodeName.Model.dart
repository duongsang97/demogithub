import 'package:diacritic/diacritic.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class PrCodeName {
  Key? key;
  String? code = "";
  String? name = "";
  String? codeDisplay = "";
  String? keyword;
  dynamic value;
  dynamic value2;
  dynamic value3;
  dynamic value4;
  PrCodeName({this.key,this.code,this.name,this.codeDisplay,this.keyword,this.value,this.value2,this.value3,this.value4});


  factory PrCodeName.fromJson(Map<String, dynamic>? json) {
    late PrCodeName result = PrCodeName();
    if (json != null) {
      result = PrCodeName(
        code: (json["code"]) ?? (json["Code"] ?? ""),
        name: (json["name"]) ?? (json["Name"] ?? ""),
        codeDisplay: (json["codeDisplay"]) ?? (json["CodeDisplay"] ?? ""),
        value: (json["value"])??(json["Value"] ?? ""),
        value2:(json["value2"])??"",
        value3:(json["value3"])??"",
      );
    }
    result.keyword = "${removeDiacritics(result.code??"")} ${removeDiacritics(result.name??"")} ${removeDiacritics(result.codeDisplay??"")}".toLowerCase();
    return result;
  }

  static bool isEmpty(PrCodeName? item){
    bool result = false;
    try{
      if(item == null){
        result = true;
      }
      else if(item.code == null || (item.code != null && item.code!.isEmpty)){
        result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "isEmpty PrCodeName.Model");
    }
    return result;
  }
  static PrCodeName create() {
    return PrCodeName(code: "", name: "");
  }

  static List<PrCodeName> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PrCodeName.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PrCodeName>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  static String toCodeList(List<PrCodeName> data){
    String result ="";
    int length = data.length;
    for(int i=0;i< length;i++){
      result += (data[i].code??"");
      if(i<length-1){
        result+=",";
      }
    }
    return result;
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": (code) ?? "",
      "name": (name) ?? "",
      "codeDisplay": (codeDisplay) ?? "",
      "value": value??{},
      "value2": value2??{},
      "value3": value3??{},
    };
    return map;
  }

  bool compareTo(PrCodeName? value){
    bool result =false;
    try{
      if(!PrCodeName.isEmpty(value) && (code!.compareTo(value!.code!) ==0)){
        result= true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "compareTo prCodeName.Model");
    }
    return result;
  }
}
