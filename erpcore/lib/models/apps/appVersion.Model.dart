import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class AppVersionModel{
  String? sId;
  PrCodeName? company;
  String? sysCode;
  PrCodeName? customer;
  String? code;
  String? name;
  String? version;
  String? linkAndroid;
  String? linkIOS;
  String? note;
  int? syslock;
  int? sysStatus;
  int? sysApproved;
  int? isQC;
  PrDate? createDate;
  String? createUser;
  int? createKindInput;
  PrDate? modifyDate;
  String? modifyUser;
  int? modifyKindInput;
  int? mustCalSearch;
  int? mustCal01;
  int? mustSync01;
  int? sortOrder;

  AppVersionModel({String? code,PrCodeName? company,PrDate? createDate,int? createKindInput,String? createUser,PrCodeName? customer,int? isQC,String? linkAndroid,String? linkIOS,PrDate? modifyDate,int? modifyKindInput,
    String? modifyUser,int? mustCal01,int? mustCalSearch,int? mustSync01,String? name,String? note,String? sId,int? sortOrder,int? sysApproved,String? sysCode,
    int? sysStatus,int? syslock,String? version,
  }){
    this.sId = sId?? "";
    this.company = company?? PrCodeName();
    this.sysCode = sysCode?? "";
    this.customer = customer?? PrCodeName();
    this.code = code?? "";
    this.name = name?? "";
    this.version = version?? "";
    this.linkAndroid = linkAndroid?? "";
    this.linkIOS = linkIOS?? "";
    this.note = note?? "";
    this.syslock = syslock??0;
    this.sysStatus = sysStatus??0;
    this.sysApproved = sysApproved??0;
    this.isQC = isQC??0;
    this.createDate = createDate??PrDate();
    this.createUser = createUser?? "";
    this.createKindInput = createKindInput??0;
    this.modifyDate = modifyDate??PrDate();
    this.modifyUser = modifyUser?? "";
    this.modifyKindInput = modifyKindInput??0;
    this.mustCalSearch = mustCalSearch??0;
    this.mustCal01 = mustCal01??0;
    this.mustSync01 = mustSync01??0;
    this.sortOrder = sortOrder??0;
  }

  factory AppVersionModel.fromJson(Map<String, dynamic>? json) {
    late AppVersionModel result = AppVersionModel();
    if(json != null){
      result = AppVersionModel(
        sId : (json['_id'])??"",
        company :  PrCodeName.fromJson(json['company']),
        sysCode : (json['sysCode'])??"",
        customer : PrCodeName.fromJson(json['customer']),
        code : (json['code'])??"",
        name : (json['name'])??"",
        version : (json['version'])??"",
        linkAndroid : (json['linkAndroid'])??"",
        linkIOS : (json['linkIOS'])??"",
        note : (json['note'])??"",
        syslock : (json['syslock'])??0,
        sysStatus : (json['sysStatus'])??0,
        sysApproved : (json['sysApproved'])??0,
        isQC : (json['isQC'])??0,
        createDate : PrDate.fromJson(json['createDate']),
        createUser : (json['createUser'])??"",
        createKindInput : (json['createKindInput'])??0,
        modifyDate : PrDate.fromJson(json['modifyDate']),
        modifyUser : (json['modifyUser'])?? "",
        modifyKindInput : (json['modifyKindInput'])?? 0,
        mustCalSearch : (json['mustCalSearch'])?? 0,
        mustCal01 : (json['mustCal01'])?? 0,
        mustSync01 : (json['mustSync01'])?? 0,
        sortOrder : (json['sortOrder'])?? 0,
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.company != null?(this.company!.toJson()):{};
    data['sysCode'] = (this.sysCode)??"";
    data['customer'] = this.customer != null?(this.customer!.toJson()):{};
    data['code'] = (this.code)??"";
    data['name'] = (this.name)??"";
    data['version'] = (this.version)??"";
    data['linkAndroid'] = (this.linkAndroid)??"";
    data['linkIOS'] = (this.linkIOS)??"";
    data['note'] = (this.note)??"";
    data['syslock'] = (this.syslock)??0;
    data['sysStatus'] = (this.sysStatus)??0;
    data['sysApproved'] = (this.sysApproved)??0;
    data['isQC'] = (this.isQC)??0;
    data['createDate'] = this.createDate != null?(this.createDate!.toJson()):{};
    data['createUser'] = (this.createUser)??"";
    data['createKindInput'] = (this.createKindInput)??0;
    data['modifyDate'] = this.modifyDate != null?(this.modifyDate!.toJson()):{};
    data['modifyUser'] = (this.modifyUser)??"";
    data['modifyKindInput'] = (this.modifyKindInput)??0;
    data['mustCalSearch'] = (this.mustCalSearch)??0;
    data['mustCal01'] = (this.mustCal01)??0;
    data['mustSync01'] = (this.mustSync01)??0;
    data['sortOrder'] = (this.sortOrder)??0;
    return data;
  }

  static List<AppVersionModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => AppVersionModel.fromJson(item)).toList();
  }

}