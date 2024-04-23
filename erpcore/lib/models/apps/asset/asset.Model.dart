import 'dart:math';

import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/asset/attributes.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class AssetModel {
  PrCodeName? customer;
  PrCodeName? project;
  List<AttributesModel>? attributes;
  String? code;
  String? name;
  PrCodeName? supplier;
  PrCodeName? assetsrc;
  PrCodeName? assettype;
  PrCodeName? orderPurchase;
  PrCodeName? location;
  PrCodeName? department;
  int? assetCost;
  double? residualValue;
  PrDate? depreciationDate;
  PrDate? transDate;
  PrCodeName? status;
  PrCodeName? transactionStatus;
  String? note;
  String? imageName;
  List<PrFileUpload>? files;
  List<PrFileUpload>? delFiles;
  // List<PrFileUpload>? historyTrans;
  PrCodeName? employee;
  int? sysStatus;
  String? info01;
  String? info02;
  String? info03;
  String? info04;
  String? strResult;
  var noteKQCN;
  var listErr;
  int? type;
  String? urlImage;

  AssetModel({
    this.customer, 
    this.project,
    this.attributes,
    this.code,
    this.name,
    this.supplier,
    this.assetsrc,
    this.assettype,
    this.orderPurchase,
    this.location,
    this.department, 
    this.assetCost,
    this.residualValue,
    this.depreciationDate,
    this.transDate,
    this.status,
    this.transactionStatus,
    this.note,
    this.imageName,
    this.files,
    this.delFiles,
    this.employee,
    this.sysStatus,
    this.info01,
    this.info02,
    this.info03,
    this.info04,
    this.strResult,
    this.noteKQCN,
    this.listErr,
    this.type,
    this.urlImage,
  });

  AssetModel.fromJson(Map<String, dynamic>? json) {
    try {
      if (json != null) {
        customer = PrCodeName.fromJson(json['customer']);
        project = PrCodeName.fromJson(json['project']);
        attributes = AttributesModel.fromJsonList(json['attributes']);
        code = json['code'] ?? "";
        name = json['name'] ?? "";
        supplier = PrCodeName.fromJson(json['supplier']);
        assetsrc = PrCodeName.fromJson(json['assetsrc']);
        assettype = PrCodeName.fromJson(json['assettype']);
        orderPurchase = PrCodeName.fromJson(json['orderPurchase']);
        location = PrCodeName.fromJson(json['location']);
        department = PrCodeName.fromJson(json['department']);
        assetCost = json['assetCost'] ?? 0;
        residualValue = json['residualValue'] ?? 0.0;
        depreciationDate = PrDate.fromJson(json['depreciationDate']);
        transDate = PrDate.fromJson(json['transDate']);
        status = PrCodeName.fromJson(json['status']);
        transactionStatus = PrCodeName.fromJson(json['transactionStatus']);
        note = json['note'] ?? "";
        imageName = json['imageName'] ?? "";
        files = PrFileUpload.fromJsonList(json['files']);
        delFiles = PrFileUpload.fromJsonList(json['delFiles']);
        // historyTrans = PrFileUpload.fromJsonList(json['historyTrans']);
        employee = PrCodeName.fromJson(json['employee']);
        sysStatus = json['sysStatus'] ?? 0;
        info01 = json['info01'] ?? "";
        info02 = json['info02'] ?? "";
        info03 = json['info03'] ?? "";
        info04 = json['info04'] ?? "";
        strResult = json['strResult'] ?? "";
        if (json["files"].isNotEmpty) {
          if (json["files"][0]["fileUrl"] != null) {
            urlImage = createPathServer(json["files"][0]["fileUrl"], json["files"][0]["fileName"]);
          }
        } else {
          urlImage = "";
        }
        noteKQCN = json['noteKQCN'] ?? [];
        listErr = json['listErr'] ?? [];
        type = json['type'] ?? "";
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex, func: "AssetModel.fromJson");
    }
  }

  static List<AssetModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => AssetModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    try {
      data['customer'] = customer != null ? (customer!.toJson()) : PrCodeName().toJson();
      data['project'] = project != null ? (project!.toJson()) : PrCodeName().toJson();
      data['attributes'] = attributes != null ? (AttributesModel.toJsonList(this.attributes!)):[];
      data['code'] = code ?? "";
      data['name'] = name ?? "";
      data['supplier'] = supplier != null ? (supplier!.toJson()) : PrCodeName().toJson();
      data['assetsrc'] = assetsrc != null ? (assetsrc!.toJson()) : PrCodeName().toJson();
      data['assettype'] = assettype != null ? (assettype!.toJson()) : PrCodeName().toJson();
      data['orderPurchase'] = orderPurchase != null ? (orderPurchase!.toJson()) : PrCodeName().toJson();
      data['location'] = location != null ? (location!.toJson()) : PrCodeName().toJson();
      data['department'] = department != null ? (department!.toJson()) : PrCodeName().toJson();
      data['assetCost'] = assetCost ?? 0;
      data['residualValue'] = residualValue ?? 0.0;
      data['depreciationDate'] = depreciationDate != null ? (depreciationDate!.toJson()) : PrDate().toJson();
      data['transDate'] = transDate != null ? (transDate!.toJson()) : PrDate().toJson();
      data['status'] = status != null ? (status!.toJson()) : PrCodeName().toJson();
      data['transactionStatus'] = transactionStatus != null ? (transactionStatus!.toJson()) : PrCodeName().toJson();
      data['note'] = note ?? "";
      data['imageName'] = imageName ?? "";
      data['files'] = files != null ? (PrFileUpload.toJsonList(this.files!)):[];
      data['delFiles'] = delFiles != null ? (PrFileUpload.toJsonList(this.delFiles!)):[];
      data['employee'] = employee != null ? (employee!.toJson()) : PrCodeName().toJson();
      data['sysStatus'] = sysStatus ?? 0;
      data['info01'] = info01 ?? "";
      data['info02'] = info02 ?? "";
      data['info03'] = info03 ?? "";
      data['info04'] = info04 ?? "";
      data['strResult'] = strResult ?? "";
      data['noteKQCN'] =(this.noteKQCN)??[];
      data['listErr'] =(this.listErr)??[];
      data['type'] = type ?? 0;

    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex, func: "AssetModel.toJson");
    }
    return data;
  }

}