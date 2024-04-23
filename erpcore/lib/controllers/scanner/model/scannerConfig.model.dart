import 'package:erpcore/controllers/scanner/model/scannerOutput.model.dart';

import '../../../models/apps/prCodeName.Model.dart';

class ScannerConfigModel {
  bool? isDisplayResult;
  bool? isMultiple;
  bool? allowDouplicate;
  String? msgDouplicate;
  int? timeAwait;
  bool saveImage;
  bool? removeItem;
  int? targetItem;
  List<ScannerOutputModel>? srcData;
  List<ScannerOutputModel>? withOutData; // dùng để so sánh với dữ liệu quét được, ko thuộc list data này
  PrCodeName? urlOnlineCheck;
  ScannerConfigModel({this.allowDouplicate=false,this.isDisplayResult=false,
    this.isMultiple=false,this.timeAwait=5,this.saveImage = false,
    this.removeItem=false,this.targetItem=0,this.srcData,this.withOutData,this.msgDouplicate,this.urlOnlineCheck
  });
}