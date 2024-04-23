import 'package:erpcore/models/activations/answerInfoAct.Model.dart';

class QuestionsActModel{
  String? code="";//Câu hỏi
  String? name =""; //Câu hỏi
  List<AnswerInfoAct>? answers = new List<AnswerInfoAct>.empty(); //Câu trả lời
  String? note ="";

  QuestionsActModel({this.answers,this.code,this.name,this.note});
  factory QuestionsActModel.fromJson(Map<String, dynamic>? json) {
    late QuestionsActModel result = QuestionsActModel();
    if (json != null){
    result = QuestionsActModel(
      code: (json["code"])??"",
      name: (json["name"])??"",
      note: (json["note"])??"",
      answers: AnswerInfoAct.fromJsonList(json["answers"])
    );
    }
    return result;
  }

  static QuestionsActModel create(){
    return new QuestionsActModel(code: "", name: "");
  }

  static List<QuestionsActModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => QuestionsActModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": (this.code)??"",
      "name": (this.name)??"",
      "note": (this.note)??""
    };
    return map;
  }
}

class QuestionDisplayAtcModel{
  int questionTotal=0;
  int questionAnswer=0;
  int correctTotal=0;
}