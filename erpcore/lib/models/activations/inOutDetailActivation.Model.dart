// class InOutDetailActivationModel{
 
//   String name = "";
//   String codeDisplay = "";

//   InOutDetailActivationModel({@required this.code, @required this.name, this.codeDisplay});

//   factory InOutDetailActivationModel.fromJson(Map<String, dynamic> json) {
//     if (json == null) return null;
//     return InOutDetailActivationModel(
//       code: json["code"],
//       name: json["name"],
//       codeDisplay: json["codeDisplay"] != null ? json["codeDisplay"] : "",
//     );
//   }

//   static InOutDetailActivationModel create(){
//     return new InOutDetailActivationModel(code: "", name: "");
//   }

//   static List<InOutDetailActivationModel> fromJsonList(List list) {
//     if (list == null) return null;
//     return list.map((item) => InOutDetailActivationModel.fromJson(item)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> map = {
//       "code": this.code,
//       "name": this.name,
//       "codeDisplay": this.codeDisplay
//     };
//     return map;
//   }
// }