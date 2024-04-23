// import 'package:erpcore/models/activations/dataImageAct.Model.dart';
// import 'package:erpcore/models/activations/questionsAct.Model.dart';

// class CustomerActModel{
//   String? id ="";
//   int? isNew=1;
//   String? sysCode="";
//   String? name = "";
//   String? phone =""; //Số điện thoại
//   String? address=""; //Địa chỉ khách hàng
//   String? note="";
//   List<DataImageActModel>? images =new List<DataImageActModel>.empty(growable: true);
//   List<QuestionsActModel>? questions = new List<QuestionsActModel>.empty(growable: true);
//   CustomerActModel({this.address,this.id,this.images,this.isNew,this.name,this.note,this.phone,this.questions,this.sysCode});


//  static CustomerActModel create(){
//     return new CustomerActModel(sysCode: "",name: "",isNew:1,phone: "",address: "",images: new List<DataImageActModel>.empty(growable: true),note: "",questions:new List<QuestionsActModel>.empty(growable: true));
//   }
  
//  factory CustomerActModel.fromJson(Map<String, dynamic>? json) {
//     late CustomerActModel result = CustomerActModel();
//     if(json != null){
//     result = CustomerActModel(
//       sysCode: (json["sysCode"])??"",
//       name: (json["name"])??"",
//       phone: (json["phone"])??"",
//       address: (json["address"])??"",
//       images: (json["images"]!=null&&json["images"].length>0)?DataImageActModel.fromJsonListFileUpload(json["images"]):new List<DataImageActModel>.empty(growable: true),
//       note: (json["note"])??"",
//       isNew: (json["isNew"])??0,
//       questions:(json["questions"]!=null&&json["questions"].length>0)?QuestionsActModel.fromJsonList(json["questions"]):new List<QuestionsActModel>.empty(growable: true),
//     );
//     }
//     return result;
//   }

//    static List<CustomerActModel> fromJsonList(List? list) {
//     if (list == null) return [];
//     return list.map((item) => CustomerActModel.fromJson(item)).toList();
//   }
 

//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> map = {
//       "sysCode": (this.sysCode)??"",
//       "name": (this.name)??"",
//       "phone": (this.phone)??"",
//       "address": (this.address)??"",
//       "images": this.images!=null?this.images!.map((e)=>e.toJson()).toList():[],
//       "note": (this.note)??"",
//       "isNew":(this.isNew)??1,
//       "questions":this.questions!=null?this.questions!.map((e)=>e.toJson()).toList():[]
//     };
//     return map;
//   }
// }