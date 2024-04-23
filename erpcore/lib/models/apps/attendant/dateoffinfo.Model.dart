
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class DateOffInfo {
    int? isnew =1;
    PrDate? startoff;
    PrDate? endoff;
    bool? mode = false;
    PrCodeName? employee;
    PrDate? insfromdate ;
    PrDate? instodate ;
    PrCodeName? kinddayoff;
    PrCodeName? timeslotstart;
    PrCodeName? timeslotend;
    String? note;
    String? sign="";
    String? sysCode="";
    int? yearFrom=-1;

  DateOffInfo({this.employee,this.endoff,this.insfromdate,this.instodate,this.isnew,this.kinddayoff,this.mode,this.note,
    this.sign,this.startoff,this.sysCode,this.timeslotend,this.timeslotstart,this.yearFrom
  });

  factory DateOffInfo.fromJson(Map<String, dynamic>? json) {
    late DateOffInfo result = DateOffInfo();
    if (json != null){
    result = DateOffInfo(
      isnew: (json["isNew"])??1,
      startoff: (json["applyFromDate"])??PrDate(),
      endoff:  (json["applyToDate"])??PrDate(),
      mode: (json["editMode"])??false,
      employee: (json["employee"])??PrCodeName(),
      insfromdate: (json["insFromDate"])??PrDate(),
      instodate: (json["insToDate"])??PrDate(),
      kinddayoff: (json["kindDayOff"])??PrCodeName(),
      note: (json["note"])??"",
      timeslotstart: (json["numDayFrom"])??PrCodeName(),
      timeslotend: (json["numDayTo"])??PrCodeName(),
      sign: (json["sign"])??"",
      sysCode: (json["sysCode"])??"",
      yearFrom: (json["yearFrom"])??-1
    );
    }
    return result;
  }

  static PrCodeName create(){
    return new PrCodeName(code: "", name: "");
  }

  static List<PrCodeName> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PrCodeName.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<PrCodeName>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
    'isNew':(this.isnew)??1,
    'applyFromDate':(this.startoff != null)?(this.startoff!.toJson()):{},
    'applyToDate':(this.endoff!= null)?(this.endoff!.toJson()):{},
    'editmode':(this.mode)??false,
    'insFromDate':(this.insfromdate!=null)?(this.insfromdate!.toJson()):{},
    'insToDate':(this.instodate != null)?(this.instodate!.toJson()):{},
    'kindDayOff':(this.kinddayoff!= null)?(this.kinddayoff!.toJson()):{},
    'note':(this.note)??"",
    'numDayFrom':(this.timeslotstart!= null)?(this.timeslotstart!.toJson()):{},
    'numDayTo': (this.timeslotend!= null)?(this.timeslotend!.toJson()):{},
    'sign':(this.sign)??"",
    'sysCode':(this.sysCode)??"",
    'yearFrom':(this.yearFrom)??-1
    };
    return map;
  }
}
