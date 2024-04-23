import 'dart:convert';

import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/actInventoryTracking/actInvGiftModel/dataPrdActInvGift.Model.dart';
import 'package:erpcore/models/apps/actInventoryTracking/infoUserGift.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class RequestItemModel {
  String? sysCode;
  String? refSysCodeRequest; // sysCode của phiếu yêu cầu --> phiếu xuất , phiếu nhập cho phiếu yêu cầu nào
  String? refSysCodeDebit; // sysCode của phiếu nợ --> phiếu xuất , phiếu nhập cho phiếu nợ nào
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
  
  int sysApproved;//1 chưa duyệt :2 duyệt : 3 từ chối
  String? userApproved;
  List? historyApproved;
  int? isUpdate;//= 1 hiện nút update 
  int sysStatus ;
  String createUser;
  PrDate? createDate;
  String modifyUser;
  PrDate? modifyDate;
  int createKindInput;
  PrCodeName? company;
  PrCodeName? customer;
  PrCodeName? project;
  PrCodeName? employee;
  int? isCheckDeviationQty;
  
  PrCodeName? shift;//ca làm việc
  PrCodeName? workPlace;//nơi làm việc
  PrCodeName? position;//vị trí (TLD,SUP,PG)  
  String? sWorkingDay;//ngày làm việc
  String? fromTime;//từ ca làm
  String? toTime;//đến ca làm

  int? isHandlerBill;//0:Ẩn nút xử lí , 1: Hiện nút xử lí
  List<PrFileUpload>? files;  
  List<PrFileUpload>? delFiles;  
  List<DataImageActModel>? imageDocument;
  PrCodeName? userConfirm;
  PrCodeName? userCreate;
  String? userNameApproved;
  int? isConfirm;

  RequestItemModel({
    this.userConfirm, this.userCreate, this.userNameApproved, this.refKind = 0,this.isNew = 1,this.code,this.date,this.program,this.status,this.kind,this.toStore,this.fromStore,this.sysCode,this.items,this.note,this.totalQty,this.totalAmountVND,this.consumer,this.reason,this.shop,this.trackingCode,this.user,this.store,
    this.sysApproved = 0,this.sysStatus = 0,this.createUser = "",this.createDate,this.modifyUser = "",this.modifyDate,this.createKindInput = 0,this.company,this.customer,this.project,this.refSysCodeRequest,this.userApproved,this.refSysCodeDebit,this.isCheckDeviationQty,
    this.shift,this.workPlace,this.position,this.sWorkingDay,this.fromTime,this.toTime,this.isHandlerBill,this.isUpdate,this.historyApproved, this.imageDocument, this.files, this.delFiles,this.employee, this.isConfirm
  });

  factory RequestItemModel.fromJson(Map<String, dynamic>? json) {
    late RequestItemModel result = RequestItemModel();
    if(json !=null){
      result = RequestItemModel(
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
        refSysCodeRequest: (json['refSysCodeRequest'])??"",
        refSysCodeDebit: (json['refSysCodeGiftDebt'])??"",
        refKind: (json['refKind'])??0,
        userApproved: (json['userApproved'])??"",
        isCheckDeviationQty: (json['IsCheckDeviationQty'])??0,
        shift: PrCodeName.fromJson(json['shift']),
        workPlace: PrCodeName.fromJson(json['workplace']),
        position: PrCodeName.fromJson(json['position']),
        sWorkingDay: (json['sWorkingDay'])??"",
        fromTime: (json['fromTime'])??"",
        toTime: (json['toTime'])??"",
        isHandlerBill: (json['isHandlerBill'])??0,
        isUpdate: (json['isUpdate'])??0,
        historyApproved: (json['historyApproved'])??[],
        files: PrFileUpload.fromJsonList(json['files']),
        delFiles:  PrFileUpload.fromJsonList(json['delFiles']),
        imageDocument: DataImageActModel.fromJsonListFileUploadV2(json["files"]),
        userConfirm : PrCodeName.fromJson(json['userConfirm']),
        userCreate : PrCodeName.fromJson(json['userCreate']),
        userNameApproved : (json['userNameApproved'] ?? ""),
        employee : PrCodeName.fromJson(json['employee']),
        isConfirm: (json['isConfirm'])??0,
      );
    }
    return result;
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['program'] = (program)!=null ? program!.toJson():{};
    data['refOwner'] = (program)!=null ? program!.toJson():{};
    data['shop'] = (shop)!=null ? shop!.toJson():{};
    data['store'] = (store)!=null ? store!.toJson():{};
    data['toStore'] = (toStore)!=null ? toStore!.toJson():{};
    data['fromStore'] = (fromStore)!=null ? fromStore!.toJson():{};
    data['status'] = (status)!=null ? status!.toJson():{};
    data['statusRequest'] = (status)!=null ? status!.toJson():{};
    data['consumer'] = (consumer)!=null?consumer!.toJson():{};
    data['user'] = (user)!=null ? user!.toJson():{};
    data['reason'] = (reason)!=null?reason!.toJson():{};
    data['kind'] = (kind)!=null ? kind!.toJson():{};
    data['vcKind'] = (kind)!=null ? kind!.toJson():{};
    data['kindRequest'] = (kind)!=null ? kind!.toJson():{};
    data['items'] = (items)!=null?DataPrdActInvGiftModel.toJsonList(items):[];
    data['products'] = (items)!=null?jsonEncode(items):[];
    data['sysCode'] = (sysCode)??"";
    data['code'] = (code)??"";
    data['trackingCode'] = (trackingCode)??"";
    data['note'] = (note)??"";
    data['totalQty'] = (totalQty)??0;
    data['totalAmountVND'] = (totalAmountVND)??0;
    data['isnew'] = isNew??1;
    data['refKind'] = refKind??0;
    data['sysApproved'] = sysApproved;
    data['sysStatus'] = sysStatus;
    data['createUser'] = (createUser);
    data['createDate'] = (createDate)!=null?createDate!.toJson():PrDate();
    data['modifyUser'] = modifyUser;
    data['modifyDate'] =(modifyDate)!=null?modifyDate!.toJson():PrDate();
    data['createKindInput'] = createKindInput;
    data['employee'] = employee?.toJson();

    data['company'] = (company)!=null ? company!.toJson():{};
    data['customer'] = (customer)!=null ? customer!.toJson():{};
    data['project'] = (project)!=null ? project!.toJson():{};
    data['refKind'] = refKind??0;
    data['userApproved'] = userApproved??"";
	  data['refSysCodeRequest'] = (refSysCodeRequest)??"";
    data['refSysCodeGiftDebt'] = (refSysCodeDebit)??"";
    data["IsCheckDeviationQty"] = isCheckDeviationQty??0;

    data['Shift'] = (shift)!=null ? shift!.toJson():{};
    data['Workplace'] = (workPlace)!=null ? workPlace!.toJson():{};
    data['Position'] = (position)!=null ? position!.toJson():{};
    data['sWorkingDay'] = (sWorkingDay)??"";
    data['FromTime'] = (fromTime)??"";
    data['ToTime'] = (toTime)??"";

    data['isHandlerBill'] = (isHandlerBill)??0;
    data['isUpdate'] = (isUpdate)??0;
    data['historyApproved'] = (historyApproved)??[];
    data['files'] = (files)!=null?PrFileUpload.toJsonList(files):[];
    data['delFiles'] = (delFiles)!=null?PrFileUpload.toJsonList(delFiles):[];
    data['userConfirm'] = (userConfirm)!=null ? userConfirm!.toJson():{};
    data['userCreate'] = (userCreate)!=null ? userCreate!.toJson():{};
    data['userNameApproved'] = (userNameApproved)??"";
    data['isConfirm'] = (isConfirm)??0;
    return data;
  }

  static List<RequestItemModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => RequestItemModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<RequestItemModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
