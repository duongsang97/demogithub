import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class PrIdNoModel{
  String? idNo;
  PrDate? idDate;
  int? active;
  PrDate? approveIdDate;
  String?  approveIdUser;
  String? approveNote;
  int? approveStatus;
  String? idNoCheck;
  PrCodeName? idPlace;
  int? mustApproveIdNo;

  PrIdNoModel({int? active,PrDate? approveIdDate,String? approveIdUser,String? approveNote,int? approveStatus,PrDate? idDate,String? idNo,String? idNoCheck,PrCodeName? idPlace,int? mustApproveIdNo}){
    this.idNo = idNo??"";
    this.idDate = idDate??PrDate();
    this.active = active??0;
    this.approveIdDate = approveIdDate??PrDate();
    this. approveIdUser = approveIdUser??"";
    this.approveNote = approveNote??"";
    this.approveStatus = approveStatus??0;
    this.idNoCheck = idNoCheck??"";
    this.idPlace = idPlace??PrCodeName();
    this.mustApproveIdNo = mustApproveIdNo??0;
  }

  factory PrIdNoModel.fromJson(Map<String, dynamic>? json) {
    late PrIdNoModel result = PrIdNoModel();
    if (json != null){
    result = PrIdNoModel(
      idNo: (json["idNo"])??"",
      idDate: PrDate.fromJson(json["idDate"]),
      active: (json["active"])??0,
      approveIdDate: PrDate.fromJson(json["approveIdDate"]),
      approveIdUser: (json["approveIdUser"])??"",
      approveNote: (json["approveNote"])??"",
      approveStatus: (json["approveStatus"])??0,
      idNoCheck: (json["idNoCheck"])??"",
      idPlace: PrCodeName.fromJson(json["idPlace"]),
      mustApproveIdNo: (json["mustApproveIdNo"])??0,
    );
    }
    return result;
  }


  static List<PrIdNoModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PrIdNoModel.fromJson(item)).toList();
  }
  static List<Map<String, dynamic>> toJsonList(List<PrIdNoModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "idNo": (this.idNo)??"",
      "idDate": this.idDate!=null?(this.idDate!.toJson()):{},
      "active": (this.active)??0,
      "approveIdDate": this.approveIdDate!=null?(this.approveIdDate!.toJson()):{},
      "approveIdUser": (this.approveIdUser)??"",
      "approveNote": (this.approveNote)??"",
      "approveStatus": (this.approveStatus)??0,
      "idNoCheck":(this.idNoCheck)??"",
      "idPlace": this.idPlace!=null?(this.idPlace!.toJson()):{},
      "mustApproveIdNo":(this.mustApproveIdNo)??0,
    };
    return map;
  }
}