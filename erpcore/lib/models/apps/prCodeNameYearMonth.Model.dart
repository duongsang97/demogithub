class PrCodeNameYearMonth {
  String code = "";
  String name = "";
  int? year = 0;
  int? month = 0;
  String? codeDisplay = "";

  PrCodeNameYearMonth({required String code, required String name,int? year,int? month, String? codeDisplay}){
    this.code = code;
    this.name = name;
    this.year = year??0;
    this.month = month??0;
    this.codeDisplay = codeDisplay??"";
  }

  factory PrCodeNameYearMonth.fromJson(Map<String, dynamic>? json) {
    late PrCodeNameYearMonth result = PrCodeNameYearMonth(code: "",name: "");
    if (json != null){
    result = PrCodeNameYearMonth(
      code: (json["code"])??"",
      name: (json["name"])??"",
      year: (json["year"])??0,
      month: (json["month"])??0,
      codeDisplay: (json["codeDisplay"]) ?? "",
    );
    }
    return result;
  }

  static PrCodeNameYearMonth create(){
    return new PrCodeNameYearMonth(code: "", name: "",year: 0,month: 0,codeDisplay: "");
  }

  static List<PrCodeNameYearMonth> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PrCodeNameYearMonth.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": this.code,
      "name": this.name,
      "year": (this.year)??0,
      "month": (this.month)??0,
      "codeDisplay": (this.codeDisplay)??""
    };
    return map;
  }
}
