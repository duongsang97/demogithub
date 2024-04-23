import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class EmployeeModelOff {
  PrCodeName? typeoff ;
  PrCodeName? name;
  PrDate? startoff;
  PrCodeName? timelinestart;
  PrCodeName? timelineend;
  PrDate? endoff;
  PrDate? bhstart;
  PrDate? bhend;
  String? note;
  EmployeeModelOff({PrCodeName? typeoff,PrCodeName? name,PrDate? startoff,PrDate? endoff,PrCodeName? timelinestart,PrCodeName? timelineend,PrDate? bhstart,PrDate? bhend,String? note}){
    this.typeoff  = typeoff?? PrCodeName();
    this.name = name?? PrCodeName();
    this.startoff = startoff?? PrDate();
    this.timelinestart = timelinestart?? PrCodeName();
    this.timelineend = timelineend?? PrCodeName();
    this.endoff = endoff?? PrDate();
    this.bhstart = bhstart?? PrDate();
    this.bhend = bhend?? PrDate();
    this.note = note?? "";
  }
  factory EmployeeModelOff.fromJson(Map<String, dynamic>? data){
    late EmployeeModelOff result = EmployeeModelOff();
  if(data !=null){
   result = EmployeeModelOff(
      typeoff:PrCodeName.fromJson( data['kindDayOff']) ,
      name:PrCodeName.fromJson(data['employee']),
      startoff:PrDate.fromJson( data['applyFromDate']),
      timelinestart:PrCodeName.fromJson(data['numDayFrom']) ,
      endoff:PrDate.fromJson( data['applyToDate']),
      timelineend:PrCodeName.fromJson(data['numDayTo']),
      bhstart:PrDate.fromJson(data['insFromDate']),
      bhend:PrDate.fromJson(data['insToDate']),
      note:(data['note'])??""
    );
  }
  return result;
  }
  static List<EmployeeModelOff> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) =>EmployeeModelOff.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<EmployeeModelOff>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "kindDayOff":(this.typeoff)??PrCodeName(),
      "employee":(this.name)??PrCodeName(),
      "applyFromDate":(this.startoff)??PrDate(),
      "numDayFrom":(this.timelinestart)??PrCodeName(),
      "applyToDate":(this.endoff)??PrDate(),
      "numDayTo":(this.timelineend)??PrCodeName(),
      "insFromDate":(this.bhstart)??PrDate(),
      "insToDate":(this.bhend)??PrDate(),
      "strResult":(this.note)??""
    };
    return map;
  }
}