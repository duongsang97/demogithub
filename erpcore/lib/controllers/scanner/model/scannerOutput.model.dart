import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:flutter/material.dart';

class ScannerOutputModel {
  String? code;
  String? data;
  DateTime? createdAt;
  ResponsesModel? type;
  // status: 0 : chưa xác minh,1 đang xác minh, 2 hợp lệ, -2 không hợp lệ , -3 lỗi khác
  bool get isValid => ![1].contains(type?.statusCode);
  bool get isError => ![-2,-3].contains(type?.statusCode);
  bool get isWait => type?.statusCode == 0;
  bool get isChecking => type?.statusCode==1;
  Color? hightLightColor;
  String? urlOnlineCheck;
  ScannerOutputModel({this.code,this.createdAt,this.data,this.type,this.hightLightColor,this.urlOnlineCheck});
}