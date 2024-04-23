import 'package:erpcore/models/activations/dashboard/actAttendanceDetail.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class ActAttendanceListModel {
  PrCodeName? employee; //Nhân viên
  int? totalTarget; //sl Lịch làm việc
  int? totalAcutal; //SL NV đã check in - out
  int? totalCheckIn;  //SL NV đã check in 
  int? totalCheckOut;  //SL NV đã check out
  List<ActAttendanceDetailModel>? items; // danh sách châm công theo nhân viên
  String? phoneNumber;

  ActAttendanceListModel({
    this.employee,
    this.totalTarget,
    this.totalAcutal,
    this.totalCheckIn,
    this.totalCheckOut,
    this.items,
    this.phoneNumber
  });

  ActAttendanceListModel.fromJson(Map<String, dynamic> json) {
    employee =PrCodeName.fromJson(json['employee']);
    totalTarget = json['totalTarget'] ?? 0;
    totalAcutal = json['totalAcutal'] ?? 0;
    totalCheckIn = json['totalCheckIn'] ?? 0;
    totalCheckOut = json['totalCheckOut'] ?? 0;
    phoneNumber = json['phoneNumber'] ?? "";
    items = ActAttendanceDetailModel.fromJsonList(json["items"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee'] = (employee??PrCodeName.create()).toJson();
    data['totalTarget'] = totalTarget ??0;
    data['totalAcutal'] = totalAcutal ??0;
    data['totalCheckIn'] = totalCheckIn ??0;
    data['totalCheckOut'] = totalCheckOut ??0;
    data['phoneNumber'] = phoneNumber ??"";
    data['items'] = ActAttendanceDetailModel.toJsonList(items);
    return data;
  }

  static List<ActAttendanceListModel> fromJsonList(List? list) {
    if (list == null) return List<ActAttendanceListModel>.empty(growable: true);
    return list.map((item) => ActAttendanceListModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ActAttendanceListModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
