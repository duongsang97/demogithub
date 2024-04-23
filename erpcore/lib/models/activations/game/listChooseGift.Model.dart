// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:erpcore/models/activations/game/chooseGift.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class ListChooseGiftModel {
  int? indexGroup; // số thứ tự của nhóm sản phẩm
  List<ChooseGiftInfoModel>? listGift = List.empty(growable: true);
  int? totalDivide; // Dùng để chia - thay đổi 
  int? totalDivideInit; // Dùng để chia - không thay đổi
  int? dataSum; // Tổng sản phẩm có thể chọn

  ListChooseGiftModel({
    this.indexGroup,
    this.listGift,
    this.totalDivide,
    this.dataSum,
    this.totalDivideInit,
  });

  factory ListChooseGiftModel.fromJson(Map<String, dynamic>? json) {
    late ListChooseGiftModel result = ListChooseGiftModel();
    if (json != null){
      result = ListChooseGiftModel(
        listGift: ChooseGiftInfoModel.fromJsonList(json["items"]),
        totalDivide: (json["totalDivide"]) ?? 0,
        totalDivideInit: (json["totalDivide"]) ?? 0,
      );
    }
    return result;
  }

  static List<ListChooseGiftModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ListChooseGiftModel.fromJson(item)).toList();
  }


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
}
