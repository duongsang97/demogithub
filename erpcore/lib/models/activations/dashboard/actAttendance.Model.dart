import 'package:erpcore/utility/logs/appLogs.Utility.dart';

import 'actAttendanceDetail.dart';

class ActAttendanceModel {
  String? workdate; // yyyy-MM-dd
  DateTime? workDateTime;
  int? totalTarget;
  
  bool? isTeam; // true --> team , false cá nhân
  int? totalCheckIn;
  int? totalCheckOut;
  ActAttendanceModel({this.workdate, this.totalTarget, this.totalCheckIn,this.totalCheckOut,this.isTeam,this.workDateTime});

  ActAttendanceModel.fromJson(Map<String, dynamic> json) {
    workdate = json['workdate'];
    totalTarget = json['totalTarget'];
    totalCheckIn = json['totalCheckIn'];
    totalCheckOut = json['totalCheckOut'];
    isTeam = json['isTeam']??false;
    try{
      workDateTime = DateTime.parse(workdate??"");
    }
    catch(ex){
      workDateTime = DateTime(1900);
      AppLogsUtils.instance.writeLogs(ex,func: "ActAttendanceModel.fromJson actAttendance.Model");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workdate'] = workdate;
    data['totalTarget'] = totalTarget;
    data['totalCheckIn'] = totalCheckIn;
    data['totalCheckOut'] = totalCheckOut;
    data['isTeam'] = isTeam??false;
    return data;
  }

  static List<ActAttendanceModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ActAttendanceModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ActAttendanceModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
