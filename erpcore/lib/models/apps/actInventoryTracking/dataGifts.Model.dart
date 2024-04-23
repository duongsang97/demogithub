import 'package:erpcore/models/apps/prCodeName.Model.dart';

class DataGiftsModel {
  String? sysCode;
  PrCodeName? shop;
  PrCodeName? kind;
  int? quantityQuota;
  int? quantityInShop;
  int? quantityOfGiven;
  int? isHighlight;
  int? quantityBefore;
  String? highlightColor;
  double? qtySale;
  double? qtySP;
  double? amountQuantityQuota;
  double? amountQuantityInShop;
  double? amountQuantityOfGiven;
  String? highlightTextColor;

  DataGiftsModel({this.sysCode, this.amountQuantityInShop, this.amountQuantityOfGiven, this.amountQuantityQuota, this.highlightColor,this.isHighlight,this.kind,this.qtySP,this.qtySale,this.quantityBefore,this.quantityInShop,this.quantityOfGiven,this.quantityQuota,this.shop, this.highlightTextColor});
  factory DataGiftsModel.fromJson(Map<String, dynamic>? json) {
    late DataGiftsModel result = DataGiftsModel();
    if(json != null){
      result = DataGiftsModel(
        shop : PrCodeName.fromJson(json['shop']),
        kind : PrCodeName.fromJson(json['kind']),
        quantityQuota : (json['quantityQuota'])??0,
        quantityInShop : (json['quantityInShop'])??0,
        quantityOfGiven : (json['quantityOfGiven'])??0,
        isHighlight : (json['isHighlight'])??2,
        quantityBefore : (json['quantityBefore'])??0,
        highlightColor : (json['highlightColor']),
        qtySale : (json['qtySale'])??0,
        qtySP : (json['qtySP'])??0,
        sysCode: (json['sysCode'])??"",
        amountQuantityQuota: json["amountQuantityQuota"] ?? 0,
        amountQuantityInShop: json["amountQuantityInShop"] ?? 0,
        amountQuantityOfGiven: json["amountQuantityOfGiven"] ?? 0,
        highlightTextColor: json["highlightTextColor"] ?? "",
      ); 
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['shop'] = shop!=null?(shop!.toJson()):{};
      data['kind'] = kind!=null?(kind!.toJson()):{};
      data['quantityQuota'] = (quantityQuota)??0;
      data['quantityInShop'] = (quantityInShop)??0;
      data['quantityOfGiven'] = (quantityOfGiven)??0;
      data['isHighlight'] = (isHighlight)??2;
      data['quantityBefore'] = (quantityBefore)??0;
      data['highlightColor'] = (highlightColor);
      data['qtySale'] = (qtySale);
      data['qtySP'] = (qtySP);
      data['sysCode'] = (sysCode);
      data['amountQuantityQuota'] = (amountQuantityQuota)??0;
      data['amountQuantityInShop'] = (amountQuantityInShop)??0;
      data['amountQuantityOfGiven'] = (amountQuantityOfGiven)??0;
      data['highlightTextColor'] = (highlightTextColor)??"";
    return data;
  }

  static List<DataGiftsModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataGiftsModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<DataGiftsModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
