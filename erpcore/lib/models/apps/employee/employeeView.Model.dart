import 'package:erpcore/models/apps/prCodeName.Model.dart';

class EmployeeViewModel {
  String? birthDay;
  String? code;
  String? codeofCus;
  PrCodeName? company;
  List<PrCodeName>? customers;
  String? empNo;
  String? imageName;
  String? name;
  String? sex;
  String? cus;
  String? cmnd;

  EmployeeViewModel({this.birthDay,this.cmnd,this.code,this.codeofCus,this.company,this.cus,this.customers,this.empNo,
    this.imageName,this.name,this.sex
  });

  factory EmployeeViewModel.fromJson(Map<String, dynamic>? json) {
    late EmployeeViewModel result = EmployeeViewModel();
    if (json != null){
    result = EmployeeViewModel(
      birthDay: (json["birthDay"])??"",
      code: (json["code"])??"",
      codeofCus: (json["codeofCus"])??"",
      company: PrCodeName.fromJson(json["company"]),
      customers: PrCodeName.fromJsonList(json["customers"]),
      empNo: (json["empNo"])??"",
      imageName: (json["imageName"])??"",
      name: (json["name"])??"",
      sex: (json["sex"])??"",
      cus: (json["cus"])??"",
      cmnd: (json["cmnd"])??"",
    );
    }
    return result;
  }



  static List<EmployeeViewModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => EmployeeViewModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "birthDay": (this.birthDay)??"",
      "code": (this.code)??"",
      "codeofCus": (this.codeofCus)??"",
      "company": this.company!=null?(this.company!.toJson()):{},
      "customers": this.customers!=null?(this.customers):[],
      "empNo": (this.empNo)??"",
      "imageName": (this.imageName)??"",
      "name": (this.name)??"",
      "sex": (this.sex)??"",
      "cus": (this.cus)??"",
      "cmnd": (this.cmnd)??""
    };
    return map;
  }
}