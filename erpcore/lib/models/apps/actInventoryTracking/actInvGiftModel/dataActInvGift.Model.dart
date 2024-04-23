import 'dart:convert';

import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/actInventoryTracking/actInvGiftModel/dataPrdActInvGift.Model.dart';
import 'package:erpcore/models/apps/actInventoryTracking/infoUserGift.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class DataActInvGiftModel {
  String? sysCode;
  String? refSysCodeRequest; // sysCode của phiếu yêu cầu --> phiếu xuất , phiếu nhập cho phiếu yêu cầu nào
  String? code; 
  InfoUserGift? consumer; // thông tin khách hàng (dùng trong nợ quà)
  PrCodeName? shop; // cửa hàng
  PrCodeName? user; // nhân viên
  PrCodeName? reason; // loại lí do --> phiếu nợ quà
  PrCodeName? program; // chương trình
  PrCodeName? store; // thông tin kho xuất
  PrCodeName? fromStore; // thông tin kho xuất
  PrCodeName? toStore; // thông tin kho nhận
  PrCodeName? status;  // trạng thái của phiếu
  PrCodeName? kind; //loại phiếu
  PrDate? date; // ngày tạo
  String? trackingCode;
  String? note;
  double? totalQty;
  double? totalAmountVND; 
  List<DataPrdActInvGiftModel>? items;
  int? refKind;
  int? isNew;

  int sysApproved;
  String? userApproved;
  int sysStatus ;
  String createUser;
  PrDate? createDate;
  String modifyUser;
  PrDate? modifyDate;
  int createKindInput;
  PrCodeName? company;
  PrCodeName? customer;
  PrCodeName? project;
  DataActInvGiftModel({
    this.refKind = 0,this.isNew = 1,this.code,this.date,this.program,this.status,this.kind,this.toStore,this.fromStore,this.sysCode,this.items,this.note,this.totalQty,this.totalAmountVND,this.consumer,this.reason,this.shop,this.trackingCode,this.user,this.store,
    this.sysApproved = 0,this.sysStatus = 0,this.createUser = "",this.createDate,this.modifyUser = "",this.modifyDate,this.createKindInput = 0,
    this.company,this.customer,this.project,this.refSysCodeRequest,this.userApproved
    });

  factory DataActInvGiftModel.fromJson(Map<String, dynamic>? json) {
    late DataActInvGiftModel result = DataActInvGiftModel();
    if(json !=null){
      result = DataActInvGiftModel(
        sysCode : (json['sysCode'])??"",
        program : PrCodeName.fromJson(json['refOwner']??json['program']),
        store : PrCodeName.fromJson(json['store']),
        fromStore : PrCodeName.fromJson(json['fromStore']),
        toStore : PrCodeName.fromJson(json['toStore']),
        date : PrDate.fromJson((json['date'])??(json['vcDate'])),
        code : (json['code'])??"",
        status : PrCodeName.fromJson(json['status']??json['statusRequest']),
        kind : PrCodeName.fromJson(json['vcKind']??json['kind']??json['kindRequest']),
        items: DataPrdActInvGiftModel.fromJsonList(json['items']),
        note: (json['note'])??"",
        totalQty: (json['totalQty'])??0,
        totalAmountVND: (json['totalAmountVND'])??0,
        consumer: InfoUserGift.fromJson(json['consumer']),
        trackingCode : (json['trackingCode'])??"",
        reason: PrCodeName.fromJson(json['reason']),
        shop : PrCodeName.fromJson(json['shop']),
        user : PrCodeName.fromJson(json['user']),
        sysApproved : (json['sysApproved'])??0,
        sysStatus : (json['sysStatus'])??0,
        createUser : (json['createUser'])??"",
        createDate : PrDate.fromJson(json['createDate']),
        modifyUser : (json['modifyUser'])??"",
        modifyDate : PrDate.fromJson(json['modifyDate']),
        createKindInput : (json['createKindInput'])??0,
        company : PrCodeName.fromJson(json['company']),
        customer : PrCodeName.fromJson(json['customer']),
        project : PrCodeName.fromJson(json['project']),
        refSysCodeRequest: json['refSysCodeRequest']??"",
        refKind:json['refKind']??0,
        userApproved:json['userApproved']??"",
      );
    }
    return result;
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program'] = (this.program)!=null ? this.program!.toJson():{};
    data['refOwner'] = (this.program)!=null ? this.program!.toJson():{};
    data['shop'] = (this.shop)!=null ? this.shop!.toJson():{};
    data['store'] = (this.store)!=null ? this.store!.toJson():{};
    data['toStore'] = (this.toStore)!=null ? this.toStore!.toJson():{};
    data['fromStore'] = (this.fromStore)!=null ? this.fromStore!.toJson():{};
    data['status'] = (this.status)!=null ? this.status!.toJson():{};
    data['statusRequest'] = (this.status)!=null ? this.status!.toJson():{};
    data['consumer'] = (this.consumer)!=null?this.consumer!.toJson():{};
    data['user'] = (this.user)!=null ? this.user!.toJson():{};
    data['reason'] = (this.reason)!=null?this.reason!.toJson():{};
    data['kind'] = (this.kind)!=null ? this.kind!.toJson():{};
    data['vcKind'] = (this.kind)!=null ? this.kind!.toJson():{};
    data['kindRequest'] = (this.kind)!=null ? this.kind!.toJson():{};
    data['items'] = (this.items)!=null?DataPrdActInvGiftModel.toJsonList(this.items):[];
    data['products'] = (this.items)!=null?jsonEncode(this.items):[];
    data['sysCode'] = (this.sysCode)??"";
    data['code'] = (this.code)??"";
    data['trackingCode'] = (this.trackingCode)??"";
    data['note'] = (this.note)??"";
    data['totalQty'] = (this.totalQty)??0;
    data['totalAmountVND'] = (this.totalAmountVND)??0;
    data['isnew'] = this.isNew??1;
    data['refKind'] = this.refKind??0;
    data['sysApproved'] = this.sysApproved;
    data['sysStatus'] = this.sysStatus;
    data['createUser'] = (this.createUser);
    data['createDate'] = (this.createDate)!=null?this.createDate!.toJson():PrDate();
    data['modifyUser'] = this.modifyUser;
    data['modifyDate'] =(this.modifyDate)!=null?this.modifyDate!.toJson():PrDate();
    data['createKindInput'] = this.createKindInput;

    data['company'] = (this.company)!=null ? this.company!.toJson():{};
    data['customer'] = (this.customer)!=null ? this.customer!.toJson():{};
    data['project'] = (this.project)!=null ? this.project!.toJson():{};
    data["refKind"] = this.refKind??0;
    data["userApproved"] = this.userApproved??"";
    return data;
  }

  static List<DataActInvGiftModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataActInvGiftModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<DataActInvGiftModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
