import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class ProjectCostModel {
  String? sysCode;
  PrCodeName? company;
  PrCodeName? project;
  PrCodeName? customer;
  List<PrCodeName>? hCBCC;
  List<PrCodeName>? hCCUSTOMER;
  List<PrCodeName>? expecteDCOST;
  List<PrCodeName>? revenuEFORECAST;
  double? alLEXPECTEDCOST;
  double? alLREVENUEFORECAST;
  double? pLFORECAST;
  PrDate? dataOfDate;
  String? dataOfDateString;
  String? note;
  PrCodeName? departmant;

  ProjectCostModel({String? sysCode,PrCodeName? company,PrCodeName? project,PrCodeName? customer,List<PrCodeName>? hCBCC,List<PrCodeName>? hCCUSTOMER,List<PrCodeName>? expecteDCOST,List<PrCodeName>? revenuEFORECAST,double? alLEXPECTEDCOST,double? alLREVENUEFORECAST,double? pLFORECAST,PrDate? dataOfDate,String? dataOfDateString,String? note,PrCodeName? departmant}){
    this.sysCode = sysCode??"";
    this.company = company??PrCodeName();
    this.project = project??PrCodeName();
    this.customer = customer??PrCodeName();
    this.hCBCC = hCBCC??List<PrCodeName>.empty(growable: true);
    this.hCCUSTOMER = hCCUSTOMER??List<PrCodeName>.empty(growable: true);
    this.expecteDCOST = expecteDCOST??List<PrCodeName>.empty(growable: true);
    this.revenuEFORECAST = revenuEFORECAST??List<PrCodeName>.empty(growable: true);
    this.alLEXPECTEDCOST = alLEXPECTEDCOST??0;
    this.alLREVENUEFORECAST = alLREVENUEFORECAST??0;
    this.pLFORECAST = pLFORECAST??0;
    this.dataOfDate = dataOfDate??PrDate();
    this.dataOfDateString = dataOfDateString??"";
    this.note = note??"";
    this.departmant = departmant??PrCodeName();
  }

  ProjectCostModel.fromJson(Map<String, dynamic> json) {
    sysCode = (json['sysCode'])??"";
    company = json['company'] != null ? new PrCodeName.fromJson(json['company']) : PrCodeName();
    project = json['project'] != null ? new PrCodeName.fromJson(json['project']) : PrCodeName();
    customer = json['customer'] != null ? new PrCodeName.fromJson(json['customer']) : PrCodeName();
    if (json['hC_BCC'] != null) {
      hCBCC = new List<PrCodeName>.empty(growable: true);
      json['hC_BCC'].forEach((v) {
        hCBCC?.add(new PrCodeName.fromJson(v));
      });
    }
    if (json['hC_CUSTOMER'] != null) {
      hCCUSTOMER = new List<PrCodeName>.empty(growable: true);
      json['hC_CUSTOMER'].forEach((v) {
        hCCUSTOMER?.add(new PrCodeName.fromJson(v));
      });
    }
    if (json['expecteD_COST'] != null) {
      expecteDCOST = new List<PrCodeName>.empty(growable: true);
      json['expecteD_COST'].forEach((v) {
        expecteDCOST?.add(new PrCodeName.fromJson(v));
      });
    }
    if (json['revenuE_FORECAST'] != null) {
      revenuEFORECAST = new List<PrCodeName>.empty(growable: true);
      json['revenuE_FORECAST'].forEach((v) {
        revenuEFORECAST?.add(new PrCodeName.fromJson(v));
      });
    }
    alLEXPECTEDCOST = (json['alL_EXPECTED_COST'])??0;
    alLREVENUEFORECAST = (json['alL_REVENUE_FORECAST'])??0;
    pLFORECAST = (json['pL_FORECAST'])??0;
    dataOfDate = json['dataOfDate'] != null ? new PrDate.fromJson(json['dataOfDate']) : PrDate();
    dataOfDateString = (json['dataOfDateString'])??"";
    note = (json['note'])??"";
    departmant = json['departmant'] != null ? new PrCodeName.fromJson(json['departmant']) : PrCodeName();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sysCode'] = (this.sysCode)??"";
    data['company'] = this.company != null?(this.company!.toJson()):{};
    data['project'] = this.project != null?(this.project!.toJson()):{};
    data['customer'] = this.customer != null?(this.customer!.toJson()):{};
    data['hC_BCC'] = this.hCBCC != null? (this.hCBCC?.map((v) => v.toJson()).toList()):[];
    data['hC_CUSTOMER'] = this.hCCUSTOMER != null?(this.hCCUSTOMER?.map((v) => v.toJson()).toList()):[];
    data['expecteD_COST'] = this.expecteDCOST != null?(this.expecteDCOST?.map((v) => v.toJson()).toList()):[];
    data['revenuE_FORECAST'] = this.revenuEFORECAST != null?(this.revenuEFORECAST?.map((v) => v.toJson()).toList()):[];
    data['alL_EXPECTED_COST'] = (this.alLEXPECTEDCOST)??0;
    data['alL_REVENUE_FORECAST'] = (this.alLREVENUEFORECAST)??0;
    data['pL_FORECAST'] = (this.pLFORECAST)??0;
    data['dataOfDate'] = this.dataOfDate != null?(this.dataOfDate?.toJson()):{};
    data['dataOfDateString'] = (this.dataOfDateString)??"";
    data['note'] =  (this.note)??"";
    data['departmant'] = this.departmant != null?this.departmant?.toJson():{};
    return data;
  }

   static List<ProjectCostModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ProjectCostModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<ProjectCostModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}