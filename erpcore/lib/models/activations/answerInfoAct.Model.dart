import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';

class AnswerInfoAct{
 String? code ="";
 String? name="";
 String? imageUrl="";
 int? isCorrect=0;
 int? isCheck=0;
 String? note="";
 DataImageActModel? file;

  AnswerInfoAct({this.code,this.file,this.imageUrl,this.isCheck,this.isCorrect,this.name,this.note});
  factory AnswerInfoAct.fromJson(Map<String, dynamic>? json) {
    late AnswerInfoAct result = AnswerInfoAct();
    if(json != null){
      result = AnswerInfoAct(
        code: (json["code"])??"",
        name: (json["name"])??"",
        imageUrl: (json["imageUrl"])??"",
        isCorrect: (json["isCorrect"])??0,
        isCheck: (json["isCheck"])??0,
        note:(json["note"])??"",
        file: DataImageActModel.fromPrFileUploadKindFile(json["file"])
      );
    }
    return result;
  }

  static AnswerInfoAct create(){
    return new AnswerInfoAct(code: generateKeyCode(),name: "",imageUrl: "",isCorrect: 0,isCheck: 0,note:"");
  }

  static List<AnswerInfoAct> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => AnswerInfoAct.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": (this.code)??"",
      "name": (this.name)??"",
      "imageUrl": (this.imageUrl)??"",
      "isCorrect": (this.isCorrect)??0,
      "isCheck": (this.isCheck)??0,
      "note":(this.note)??""
    };
    return map;
  }
}