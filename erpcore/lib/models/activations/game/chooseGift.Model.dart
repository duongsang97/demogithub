import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class ChooseGiftInfoModel{
  int? total;
  String? sysCode;
  String? code;
  String? name;
  String? image;
  String? imageLucky;
  String? note;
  int? target;
  int? initTarget;
  bool? isSelected;
  int? indexGroup;
  int? dataSum;
  ChooseGiftInfoModel({this.code,this.image,this.name,this.note,this.sysCode,this.total = 0, this.target, this.dataSum, this.initTarget, this.indexGroup, this.imageLucky});

  factory ChooseGiftInfoModel.fromJson(Map<String, dynamic>? json) {
    late ChooseGiftInfoModel result = ChooseGiftInfoModel();
    if (json != null){
    result = ChooseGiftInfoModel(
      sysCode: (json["sysCode"])??"",
      code: (json["code"])??"",
      name: (json["name"])??"",
      image: (json["image"])??"",
      imageLucky: (json["imageLucky"])??"",
      note: (json["note"])??"",
      target: (json["target"])??"",
      initTarget: (json["target"])??"",
      total:  (json["total"])??0,
    );
    }
    return result;
  }

  static List<ChooseGiftInfoModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ChooseGiftInfoModel.fromJson(item)).toList();
  }

  // static  List<Map<String, dynamic>> toJsonList(List<ChooseGiftInfoModel>? list) {
  //   if (list == null) return [];
  //   return list.map((item) => item.toJson()).toList();
  // }

  static List<PrCodeName> toPrCodeNameList(List<ChooseGiftInfoModel>? list){
    var result = new List<PrCodeName>.empty(growable: true);
    try{
      if(list != null && list.isNotEmpty){
        for(var item in list){
          if(item.code != null && item.code!.isNotEmpty){
            var temp =  new PrCodeName(code: item.code!, name: item.name??"",codeDisplay: item.total.toString());
            result.add(temp);
          }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "toPrCodeNameList chooseGift.Model");
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "total": total??0,
      "sysCode": sysCode??"",
      "code": code??"",
      "name": name??"",
      "image": image??"",
      "imageLucky": imageLucky??"",
      "note": note??"",
      "target": target??"",
    };
    return map;
  }
}