import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class ItemSelectDataActModel{
  String? code="";
  String? name="";
  bool? isChoose = false;
  bool? selectType = false; // false = checkbox;
  String? linkFile =""; // link file, hình ảnh
  int point; // điểm theo câu
  bool visibility;

  ItemSelectDataActModel({this.code,this.isChoose =false,this.name,this.selectType,this.linkFile,this.point=-1,this.visibility=true});

  factory ItemSelectDataActModel.fromJson(Map<String, dynamic>? json) {
    late ItemSelectDataActModel result = ItemSelectDataActModel();
    try{
      if (json != null){
        result = ItemSelectDataActModel(
          code: (json["code"])??"",
          name: (json["name"])??"",
          isChoose: (json["isChoose"])??false,
          selectType: (json["selectType"])??false,
          linkFile: (json["linkFile"])??"",
          point: (json["point"])??-1,
          visibility: (json["visibility"])??true,
        );
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "ItemSelectDataActModel.fromJson");
    }
    return result;
  }

  static ItemSelectDataActModel create(){
    return ItemSelectDataActModel(code: "", name: "");
  }

  static List<ItemSelectDataActModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ItemSelectDataActModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": (code)??"",
      "name": (name)??"",
      "isChoose": (isChoose)??false,
      "selectType": (selectType)??false,
      "linkFile": (linkFile)??"",
      "point": point,
      "visibility": visibility
    };
    return map;
  }

   static List<Map<String, dynamic> > toJsonList(List<ItemSelectDataActModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

}