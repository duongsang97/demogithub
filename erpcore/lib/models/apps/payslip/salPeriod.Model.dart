class SalPeriodModel {
  String? code = "";
  String? name = "";
  int? year = 0;
  int? month = 0;

  SalPeriodModel({String? code, String? name, int? month, int? year}){
    this.code = code??"";
    this.name = name??"";
    this.year = year??0;
    this.month = month??0;
  }

  factory SalPeriodModel.fromJson(Map<String, dynamic>? json) {
    late SalPeriodModel result = SalPeriodModel();
    if (json != null) {
      result = SalPeriodModel(
        code: (json["code"]) ?? "",
        name: (json["name"]) ?? "",
        year: (json["year"]) ?? 0,
        month: (json["month"]) ?? 0,
      );
    }
    return result;
  }

  static List<SalPeriodModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => SalPeriodModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<SalPeriodModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": (this.code)??"",
      "name": (this.name)??"",
      "year": (this.year)??0,
      "month": (this.month)??0,
    };
    return map;
  }
}
