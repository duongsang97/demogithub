import 'package:erpcore/models/apps/prCodeName.Model.dart';

import 'actBreakTime.Model.dart';

class ActAttendanceDetailModel{
  PrCodeName? shop; //CH   
  PrCodeName? employee; //Nhân viên
  PrCodeName? shift; //Ca làm việc
  int? iSCheckIn; // 0: chưa check in; 1: đã check in
  String? time; // số lượng (chi tiết doanh thủ)
  String? imageCheckIn; // hình ảnh checkIn
  String? imageCheckOut; // hình ảnh checkout
  String? checkInTime; // giờ checkin
  String? checkOutTime; // giờ checkOut
  List<BreakTimeItemModel>? items;


  ActAttendanceDetailModel({this.employee,this.iSCheckIn,this.imageCheckIn,this.imageCheckOut,this.shift,this.shop,this.time,this.checkInTime,this.checkOutTime,this.items});

  ActAttendanceDetailModel.fromJson(Map<String, dynamic> json) {
    shop = PrCodeName.fromJson(json['shop']);
    employee =PrCodeName.fromJson(json['employee']);
    shift = PrCodeName.fromJson(json['shift']);
    iSCheckIn = json['iSCheckIn']??0;
    time = json['time']??"";
    imageCheckIn = json['imageCheckIn']??"";
    imageCheckOut = json['imageCheckOut']??"";
    checkInTime = json['checkInTime']??"";
    checkOutTime = json['checkOutTime']??"";
    items= BreakTimeItemModel.fromJsonList(json["items"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shop'] = (shop??PrCodeName.create()).toJson();
    data['employee'] = (employee??PrCodeName.create()).toJson();
    data['shift'] = (shift??PrCodeName.create()).toJson();
    data['iSCheckIn'] = iSCheckIn??0;
    data['time'] = time??"";
    data['imageCheckIn'] = imageCheckIn??"";
    data['imageCheckOut'] = imageCheckOut??"";
    data['checkInTime'] = checkInTime??"";
    data['checkOutTime'] = checkOutTime??"";
    return data;
  }

  static List<ActAttendanceDetailModel> fromJsonList(List? list) {
    if (list == null) return List<ActAttendanceDetailModel>.empty(growable: true);
    return list.map((item) => ActAttendanceDetailModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ActAttendanceDetailModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}