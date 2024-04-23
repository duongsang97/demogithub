import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class AttributesModel {
  PrCodeName? kind;
  // String? item;
  String? info;
  String? text;
  int? number;
  String? note;

  AttributesModel({
    this.kind,
    this.info,
    this.text,
    this.number,
    this.note,
  });

  AttributesModel.fromJson(Map<String, dynamic>? json) {
    try {
      if (json != null) {
        kind = PrCodeName.fromJson(json['kind']);
        info = json['info'] ?? "";
        text = json['text'] ?? "";
        number = json['number'] ?? 0;
        note = json['note'] ?? "";
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex, func: "AttributesModel.fromJson");
    }
  }

  static List<AttributesModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => AttributesModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    try {
      data['Kind'] = kind != null ? (kind!.toJson()) : PrCodeName().toJson();
      data['Info'] = info ?? "";
      data['Text'] = text ?? "";
      data['Number'] = number ?? "";
      data['Note'] = note ?? "";
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex, func: "AttributesModel.toJson");
    }
    return data;
  }
  
  static  List<Map<String, dynamic>> toJsonList(List<AttributesModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}