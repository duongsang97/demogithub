import 'dart:convert';

import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class DataPrdActInvGiftModel {
  String? sysCode;
  String? code; //
  PrCodeName? product; // sản phẩm
  double? quantity; // số lượng sẩn phẩm
  double? quantityActual; // số lượng thực tế --> phiếu xác nhạn
  double? qtyTransfer; // số lượng thực tế
  double? quantityRemain; // số lượng thực tế tồn
  double? quantityLost; // số lượng thất thoát
  double? saleQuantity; // số lượng sale nhập
  double? sPQuantity; // số lượng PG nhập
  double? qtyCreated; // số lượng thực tế jti
  double? amountVND; // giá
  double? amountVNDCreated;
  String? infoSysCode;
  String? infoCode;
  List<DataImageActModel>? listItemConfirm;
  // confirm 
  String? reason;
  int? isnew;
  String? note;
  PrDate? date;
  PrCodeName? shop;
  List<String>? qrCode;
  // app lưu
  TextEditingController txtQuantityController = TextEditingController();  // số lượng sẩn phẩm
  TextEditingController txtQuantityActualController = TextEditingController(); // số lượng thực tế --> phiếu xác nhạn
  TextEditingController txtQuantityQtyTransferController = TextEditingController(); // số lượng thực tế --> phiếu xác nhạn
  TextEditingController txtQuantityRemainController = TextEditingController();  // số lượng thực tế tồn
  TextEditingController txtQuantityLostController = TextEditingController(); // số lượng thất thoát
  TextEditingController txtSaleQuantityController = TextEditingController();  // số lượng sale nhập
  TextEditingController txtSPQuantityController = TextEditingController(); //  số lượng PG nhập
  TextEditingController txtAmountVNDController = TextEditingController(); // giá
  TextEditingController txtQuantityCreatedController = TextEditingController();  // số lượng thực tế jti

  DataPrdActInvGiftModel({this.amountVND,this.code,this.infoCode,this.infoSysCode,this.isnew, this.qtyCreated,
    this.product,this.quantity=0,this.qtyTransfer =0,this.reason,this.sysCode,this.quantityRemain =0,
    this.quantityLost =0,this.listItemConfirm,this.sPQuantity =0,this.saleQuantity =0,this.note,this.date,
    this.shop, this.quantityActual, this.amountVNDCreated, this.qrCode
  });
  
  factory DataPrdActInvGiftModel.fromJson(Map<String, dynamic>? json) {
    late DataPrdActInvGiftModel result = DataPrdActInvGiftModel();
    try {
      if (json != null) {
        List<String> listQrCode = (List.castFrom(json['qrCode']));
        result = DataPrdActInvGiftModel(
          product: (json['prd'] != null)?PrCodeName.fromJson(json['prd']):PrCodeName.fromJson(json['product']),
          quantity: (json['qty'])??(json['qtyRequest']) ??0,
          amountVND: (json['amountVND']) ?? 0,
          amountVNDCreated: (json['amountVNDCreated']) ?? 0,
          quantityRemain : (json['qtyRemain'])??0,
          quantityActual : (json['qtyActual'])??0,
          qtyTransfer : (json['qtyTransfer'])??0,
          qtyCreated : (json['qtyCreated'])??0,
          quantityLost : (json['qtyLost'])??0,
          sysCode: (json['sysCode']) ?? "",
          code: (json['code']) ?? "",
          reason: (json["reason"])??"",
          infoSysCode: (json["infoSysCode"])??"",
          infoCode: (json["infoCode"])??"",
          sPQuantity: (json["qtySP"])??0,
          saleQuantity: (json["qtySale"])??0,
          listItemConfirm: DataImageActModel.fromJsonListFileUpload(json["recordImage"]),
          note: (json['note']) ?? "",
          date: PrDate.fromJson(json["date"]),
          shop: PrCodeName.fromJson(json["shop"]),
          qrCode: listQrCode
        );
      }
      result.txtQuantityController.text = formatNumberDouble(result.quantity); // số lượng sẩn phẩm
      result.txtQuantityCreatedController.text = formatNumberDouble(result.qtyCreated); // số lượng thực tế jti
      result.txtQuantityActualController.text = formatNumberDouble(result.quantityActual); // số lượng thực tế --> phiếu xác nhạn
      result.txtQuantityQtyTransferController.text = formatNumberDouble(result.qtyTransfer).toString(); // số lượng thực tế --> phiếu xác nhạn
      result.txtQuantityRemainController.text =  result.quantityRemain.toString();  // số lượng thực tế tồn
      result.txtQuantityLostController.text = result.quantity.toString(); // số lượng thất thoát
      result.txtSaleQuantityController.text =  result.quantityLost.toString(); // số lượng sale nhập
      result.txtSPQuantityController.text =  result.saleQuantity.toString(); //  số lượng PG nhập
      result.txtAmountVNDController.text =  result.amountVND.toString(); // giá
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "DataPrdActInvGiftModel");
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prd'] = !PrCodeName.isEmpty(product)?product!.toJson():{};
    data['qty'] = (quantity) ?? 0;
    data['amountVND'] = (amountVND) ?? 0;
    data['amountVNDCreated'] = (amountVNDCreated) ?? 0;
    data['qtyRequest'] = (quantity)??0;
    data['qtyRemain'] = (quantityRemain)??0;
    data['qtyTransfer'] = (qtyTransfer)??0;
    data['qtyActual'] = (quantityActual)??0;
    data['qtyLost'] = (quantityLost)??0;
    data['qtyCreated'] = (qtyCreated)??0;
    data['sysCode'] = (sysCode)??"";
    data['code'] = (code)??"";
    data['reason'] = (reason)??"";
    data['infoCode'] = (infoCode)??"";
    data['infoSysCode'] = (infoSysCode)??"";
    data['isnew'] = (isnew)??1;
    data['sPQuantity'] = (sPQuantity)??0;
    data['saleQuantity'] = (saleQuantity)??0;
    data['note'] = (note)??"";
    data['date'] = (date??PrDate()).toJson();
    data['product'] = !PrCodeName.isEmpty(product)?product!.toJson():{};
    data['shop'] = !PrCodeName.isEmpty(shop)?shop!.toJson():{};
    data['qrCode'] = qrCode ?? <String>[];
    return data;
  }

  static List<DataPrdActInvGiftModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataPrdActInvGiftModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<DataPrdActInvGiftModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
