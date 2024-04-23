import 'package:erpcore/components/loading/datas/loadingType.data.dart';
import 'package:flutter/material.dart';

class LoadingConfigModel{
  Color? backgroundColor = Colors.grey.withOpacity(0.2);
  String? image;
  Size? size;
  bool dismissible = false;
  double? shadow;
  OverlayType overlayType;
  LoadingConfigModel({this.backgroundColor,this.dismissible= false,this.image,this.size,this.shadow =0.6,this.overlayType = OverlayType.FULL});
}