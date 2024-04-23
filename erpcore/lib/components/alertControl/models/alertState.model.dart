import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';


class AlertStatesModel{
  String code = generateKeyCode();
  AlertType type = AlertType.DEFAULT;
  String title ="";
  bool init = false;
  String description = "";
  AlertPriority priority = AlertPriority.MEDIUM;
  bool isDisplay = false;
  DateTime? exp;
  Duration? duration;
  VoidCallback? callback;
  AlertStatesModel({this.title="",this.type=AlertType.DEFAULT,this.description="",this.priority = AlertPriority.MEDIUM,this.isDisplay=false,this.code="",this.exp,this.duration,this.callback});


  static AlertStatesModel toCopy(AlertStatesModel data){
    AlertStatesModel result = AlertStatesModel();
    result.code = data.code;
    result.type = data.type;
    result.title = data.title;
    result.init = data.init;
    result.description = data.description;
    result.isDisplay = data.isDisplay;
    result.exp = data.exp;
    result.duration = data.duration;
    result.callback = data.callback;
    return result;
  }

}