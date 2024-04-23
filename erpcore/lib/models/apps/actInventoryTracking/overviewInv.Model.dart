import 'package:erpcore/models/apps/prCodeName.Model.dart';

class OverviewInv extends PrCodeName {
  String? color;
  String? note;
  OverviewInv({code,name,codeDisplay,this.color,this.note}):super(code: code,name: name,codeDisplay: codeDisplay){
    this.color = color??"";
    this.note = note??"";
    this.code = code??"";
    this.codeDisplay = codeDisplay??"";
    this.name = name??"";
  }
  factory OverviewInv.fromJson(Map<String, dynamic>? json) {
    late OverviewInv result = OverviewInv();
    if(json != null){
      result = OverviewInv(
        code: (json["code"]) ?? "",
        name: (json["name"]) ?? "",
        codeDisplay: (json["codeDisplay"]) ?? "",
        color: (json['color'])??"",
        note : (json['note'])??"",
      ); 
    }
    return result;
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['code'] = (this.code) ?? "";
      data['name'] = (this.name) ?? "";
      data['codeDisplay'] = (this.codeDisplay) ?? "";
      data['note'] = (this.note)??"";
      data['color'] = (this.color)??"";
    return data;
  }

  static List<OverviewInv> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => OverviewInv.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<OverviewInv>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
  }
