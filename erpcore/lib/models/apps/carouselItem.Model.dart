import 'package:erpcore/models/apps/PrDate.Model.dart';

class CarouselItemModel{
  String? code="";
  String? name="";
  String? link ="";
  int? index;
  PrDate? exp;

  CarouselItemModel({String? code,PrDate? exp,int? index,String? link,String? name}){
    this.code = code??"";
    this.name = name??"";
    this.link = link??"";
    this.index = index??0;
    this.exp = exp??PrDate();
  }

  factory CarouselItemModel.fromJson(Map<String, dynamic>? json) {
    late CarouselItemModel result = CarouselItemModel();
    if (json != null){
    result = CarouselItemModel(
      code: (json["code"])??"",
      name: (json["name"])??"",
      link: (json["link"])??"",
      index: (json["index"])??0,
      exp: PrDate.fromJson(json["exp"])
    );
    }
    return result;
  }

  static List<CarouselItemModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => CarouselItemModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": this.code,
      "name": this.name,
      "link": (this.link)??"",
      "index": (this.index)??0,
      "exp": this.exp!=null?this.exp!.toJson():PrDate().toJson()
    };
    return map;
  }

}