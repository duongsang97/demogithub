import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
class OffDateResultModel{
  PrDate? numDayOff;
  PrDate? numDayOffYear;
  PrDate? date;
  String? sysCode;
  String? sign;
  PrCodeName? employee;
  PrCodeName? kindDayOff;
  PrDate? applyFromDate;
  PrCodeName? numDayFrom;
  PrDate? applyToDate;
  PrCodeName? numDayTo;
  String? note;
  PrDate? insFromDate;
  PrDate? insToDate;
  int? sysStatus;
  String? strResult;
  int? type;

  OffDateResultModel({this.applyFromDate,this.applyToDate,this.date,this.employee,this.insFromDate,this.insToDate,this.kindDayOff,this.note,
    this.numDayFrom,this.numDayOff,this.numDayOffYear,this.numDayTo,this.sign,this.strResult,this.sysCode,this.sysStatus,
    this.type,
  });

  factory OffDateResultModel.fromJson(Map<String, dynamic>? json) {
    late OffDateResultModel result = OffDateResultModel();
    if(json != null){
      result = OffDateResultModel(
        numDayOff : json['numDayOff'] != null ? new PrDate.fromJson(json['numDayOff']): PrDate(),
        numDayOffYear : json['numDayOffYear'] != null? new PrDate.fromJson(json['numDayOffYear']): PrDate(),
        date : json['date'] != null ? new PrDate.fromJson(json['date']) : PrDate(),
        sysCode : (json['sysCode'])??"",
        sign : (json['sign'])??"",
        employee : json['employee'] != null? new PrCodeName.fromJson(json['employee']): PrCodeName(),
        kindDayOff : json['kindDayOff'] != null? new PrCodeName.fromJson(json['kindDayOff']): PrCodeName(),
        applyFromDate : json['applyFromDate'] != null? new PrDate.fromJson(json['applyFromDate']): PrDate(),
        numDayFrom : json['numDayFrom'] != null? new PrCodeName.fromJson(json['numDayFrom']): PrCodeName(),
        applyToDate : json['applyToDate'] != null? new PrDate.fromJson(json['applyToDate']): PrDate(),
        numDayTo : json['numDayTo'] != null? new PrCodeName.fromJson(json['numDayTo']): PrCodeName(),
        note : (json['note'])??"",
        insFromDate : json['insFromDate'] != null? new PrDate.fromJson(json['insFromDate']): PrDate(),
        insToDate : json['insToDate'] != null ? new PrDate.fromJson(json['insToDate']) : PrDate(),
        sysStatus : (json['sysStatus'])??0,
        strResult : (json['strResult'])??"",
        type : (json['type'])??0,
      );
    }
    return result;
  }

   static List<OffDateResultModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => OffDateResultModel.fromJson(item)).toList();
  }
  // static  List<Map<String, dynamic>> toJsonList(List<PrCodeName> list) {
  //   if (list == null) return null;
  //   return list.map((item) => item.toJson()).toList();
  // }
}