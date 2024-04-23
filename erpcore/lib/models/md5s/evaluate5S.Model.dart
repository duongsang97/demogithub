import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/md5s/criterias5s.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';

class Evaluate5SModel{
  String? code="";
  String? sysCode="";
  bool? isEdit=false;
  PrCodeName? company = PrCodeName(code: generateKeyCode(),name: ""); // công ty
  PrCodeName? project =  PrCodeName(code: generateKeyCode(),name: ""); // dự án
  PrCodeName? customer=  PrCodeName(code: generateKeyCode(),name: ""); // khách hàng
  PrCodeName? checkedBy=  PrCodeName(code: generateKeyCode(),name: ""); // người đánh giá
  PrCodeName? responsible=  PrCodeName(code: generateKeyCode(),name: ""); // người chịu trách nhiệm
  PrCodeName? checkedAreas=  PrCodeName(code: generateKeyCode(),name: ""); // khu vực kiểm tra
  PrCodeName? shift=  PrCodeName(code: generateKeyCode(),name: ""); // ca làm việc
  PrCodeName? factorys=  PrCodeName(code: generateKeyCode(),name: ""); // nhà máy
  PrCodeName? parts=  PrCodeName(code: generateKeyCode(),name: ""); // bộ phận
  PrCodeName? kind=  PrCodeName(code: "",name: ""); // loại báo cáo
  List<Criterias5sModel>? criterias; // các tiêu chí đánh giá
  String? note; // ghi chú
  PrDate? createdAt = PrDate(); // thời gian tạo phiếu
  PrCodeName? createdBy; // người tạo phiếu

   Evaluate5SModel({ PrCodeName? factorys,PrCodeName? parts,this.isEdit:false,
    String? code,PrDate? createdAt,PrCodeName? createdBy,String? sysCode,PrCodeName? company,PrCodeName? project,PrCodeName? customer,PrCodeName? checkedAreas,PrCodeName? responsible,PrCodeName? checkedBy,PrCodeName? shift,String? note,List<Criterias5sModel>? criterias,
    PrCodeName? kind
  }){
    this.code= code??"";
    this.sysCode= sysCode??"";
    this.company = company?? PrCodeName(code: generateKeyCode(),name: ""); 
    this.project =  project?? PrCodeName(code: generateKeyCode(),name: ""); 
    this.customer=  customer?? PrCodeName(code: generateKeyCode(),name: "");
    this.checkedBy=  checkedBy?? PrCodeName(code: generateKeyCode(),name: "");
    this.responsible= responsible??  PrCodeName(code: generateKeyCode(),name: "");
    this.checkedAreas=  checkedAreas?? PrCodeName(code: generateKeyCode(),name: ""); 
    this.shift=  shift?? PrCodeName(code: generateKeyCode(),name: "");
    this.factorys= factorys ?? PrCodeName(code: generateKeyCode(),name: "");
    this.parts=  parts?? PrCodeName(code: generateKeyCode(),name: "");
    this.kind= kind??  PrCodeName(code: "",name: "");
    this.criterias = criterias??List<Criterias5sModel>.empty(growable: true);
    this.note = note??"";
    this.createdAt = createdAt??PrDate();
    this.createdBy =  createdBy??PrCodeName(); 
  }

   factory Evaluate5SModel.fromJson(Map<String, dynamic>? json) {
    late Evaluate5SModel result = Evaluate5SModel();
    if (json != null){
    result = Evaluate5SModel(
      code: (json["code"])??"",
      sysCode: (json["sysCode"])??"",
      company: PrCodeName.fromJson(json["company"]),
      project: PrCodeName.fromJson(json["project"]),
      customer: PrCodeName.fromJson(json["customer"]),
      checkedAreas: PrCodeName.fromJson(json["checkedAreas"]),
      responsible:  PrCodeName.fromJson(json["responsible"]),
      checkedBy: PrCodeName.fromJson(json["checkedBy"]),
      shift: PrCodeName.fromJson(json["shift"]),
      factorys: PrCodeName.fromJson(json["factory"]),
      parts: PrCodeName.fromJson(json["parts"]),
      kind: PrCodeName.fromJson(json["kind"]),
      note: (json["note"])??"",
      createdAt: PrDate.fromJson(json["createdAt"]),
      createdBy:PrCodeName.fromJson(json["createdBy"]),
      criterias: Criterias5sModel.fromJsonList(json["criterias"])
    );
    }
    return result;
  }

  static Evaluate5SModel create(){
    return Evaluate5SModel(sysCode: generateKeyCode(),code: "",company:  PrCodeName(code: generateKeyCode(),name: ""),
    project:  PrCodeName(code: generateKeyCode(),name: ""),
    customer:  PrCodeName(code: generateKeyCode(),name: ""),
    checkedBy:  PrCodeName(code: generateKeyCode(),name: ""),
    responsible:  PrCodeName(code: generateKeyCode(),name: ""),
    checkedAreas:  PrCodeName(code: generateKeyCode(),name: ""),
    shift:  PrCodeName(code: generateKeyCode(),name: ""),
    factorys:  PrCodeName(code: generateKeyCode(),name: ""),
    parts:  PrCodeName(code: generateKeyCode(),name: ""),
    kind:  PrCodeName(code: "",name: ""),
    note: "",
    createdAt: PrDate(),
    createdBy:  PrCodeName(code: generateKeyCode(),name: ""),
    criterias: List<Criterias5sModel>.empty(growable: true)
    );
  }

  static List<Evaluate5SModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => Evaluate5SModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": (sysCode)??"",
      "code": (code)??"",
      "IsNew": (isEdit!=null && isEdit == true)?0:1,
      //"company":this.company.toJson(),
      "project":project!=null?(project!.toJson()):{},
      "customer": customer!=null?(customer!.toJson()):{},
      "checkedAreas":checkedAreas!=null?(checkedAreas!.toJson()):{},
      "responsible":responsible!=null?(responsible!.toJson()):{},
      //"checkedBy":this.checkedBy.toJson(),
      "shift":shift!=null?(shift!.toJson()):{},
      "factory":factorys!=null?(factorys!.toJson()):{},
      "parts":parts!=null?(parts!.toJson()):{},
      "kind":(kind != null)?kind?.toJson():{},
      "note":(note)??"",
     // "createdAt": this.createdAt.toJson(),
      //"createdBy":this.createdBy.toJson(),
      "criterias": Criterias5sModel.toListJson(criterias)
    };
    return map;
  }

}