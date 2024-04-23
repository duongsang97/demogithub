import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

class ItemMenuInfoModel {
  String sysCode = "";
  String? nameDisplay;
  String? navigation;
  Icon? icon;
  bool? selected=false;
  Widget? widthBox;
  TextStyle? titleStyle;
  List<ItemMenuInfoModel>? child = new List<ItemMenuInfoModel>.empty(growable: true);
  ItemMenuInfoModel({ required String sysCode,String? nameDisplay,String? navigation,List<ItemMenuInfoModel>? child,Icon? icon,bool? selected,Widget? widthBox,TextStyle? titleStyle}){
    this.sysCode = sysCode;
    this.nameDisplay = nameDisplay??"";
    this.navigation = navigation??"";
    this.icon = icon?? Icon(Icons.abc);
    this.selected = selected??false;
    this.widthBox = widthBox ??SizedBox();
    this.titleStyle = titleStyle??TextStyle();
    this.child = child??new List<ItemMenuInfoModel>.empty(growable: true);
  }
  static create(){
    return new ItemMenuInfoModel(sysCode: generateKeyCode(),nameDisplay: "",navigation: "",child: new List<ItemMenuInfoModel>.empty(growable: true));
  }
}