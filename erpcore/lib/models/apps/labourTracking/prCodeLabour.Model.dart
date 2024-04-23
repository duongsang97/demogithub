class NXTMonthSum {
  String? prdCode;
  String? prdName;
  String? unit;
  NXTMonthSumMonth? t01;
  NXTMonthSumMonth? t02;
  NXTMonthSumMonth? t03;
  NXTMonthSumMonth? t04;
  NXTMonthSumMonth? t05;
  NXTMonthSumMonth? t06;
  NXTMonthSumMonth? t07;
  NXTMonthSumMonth? t08;
  NXTMonthSumMonth? t09;
  NXTMonthSumMonth? t10;
  NXTMonthSumMonth? t11;
  NXTMonthSumMonth? t12;
  NXTMonthSumMonth? sum12Month;

  NXTMonthSum({String? prdCode,String? prdName,String? unit,NXTMonthSumMonth? t01,NXTMonthSumMonth? t02,NXTMonthSumMonth? t03,NXTMonthSumMonth? t04,NXTMonthSumMonth? t05,NXTMonthSumMonth? t06,NXTMonthSumMonth? t07,NXTMonthSumMonth? t08,NXTMonthSumMonth? t09,NXTMonthSumMonth? t10,NXTMonthSumMonth? t11,NXTMonthSumMonth? t12,NXTMonthSumMonth? sum12Month}){
    this.prdCode = prdCode?? "";
    this.prdName = prdName?? "";
    this.unit = unit?? "";
    this.t01 = t01?? NXTMonthSumMonth();
    this.t02 = t02?? NXTMonthSumMonth();
    this.t03 = t03?? NXTMonthSumMonth();
    this.t04 = t04?? NXTMonthSumMonth();
    this.t05 = t05?? NXTMonthSumMonth();
    this.t06 = t06?? NXTMonthSumMonth();
    this.t07 = t07?? NXTMonthSumMonth();
    this.t08 = t08?? NXTMonthSumMonth();
    this.t09 = t09?? NXTMonthSumMonth();
    this.t10 = t10?? NXTMonthSumMonth();
    this.t11 = t11?? NXTMonthSumMonth();
    this.t12 = t12?? NXTMonthSumMonth();
    this.sum12Month = sum12Month?? NXTMonthSumMonth();
  }

  factory NXTMonthSum.fromJson(Map<String, dynamic>? json) {
    late NXTMonthSum result = NXTMonthSum();
    if (json != null){
    result = NXTMonthSum(
      prdCode: (json['prdCode'])??"",
      prdName: (json['prdName'])??"",
      unit: (json['unit'])??"",
      t01: NXTMonthSumMonth.fromJson(json['t01']),
      t02: NXTMonthSumMonth.fromJson(json['t02']),
      t03: NXTMonthSumMonth.fromJson(json['t03']),
      t04: NXTMonthSumMonth.fromJson(json['t04']),
      t05: NXTMonthSumMonth.fromJson(json['t05']),
      t06: NXTMonthSumMonth.fromJson(json['t06']),
      t07: NXTMonthSumMonth.fromJson(json['t07']),
      t08: NXTMonthSumMonth.fromJson(json['t08']),
      t09: NXTMonthSumMonth.fromJson(json['t09']),
      t10: NXTMonthSumMonth.fromJson(json['t10']),
      t11: NXTMonthSumMonth.fromJson(json['t11']),
      t12: NXTMonthSumMonth.fromJson(json['t12']),
      sum12Month: NXTMonthSumMonth.fromJson(json['sum12Month']),
    );
    }
    return result;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prdCode'] = (this.prdCode)??"";
    data['prdName'] = (this.prdName)??"";
    data['unit'] = (this.unit)??"";
    data['t01'] = (this.t01)??NXTMonthSumMonth();
    data['t02'] = (this.t02)??NXTMonthSumMonth();
    data['t03'] = (this.t03)??NXTMonthSumMonth();
    data['t04'] = (this.t04)??NXTMonthSumMonth();
    data['t05'] = (this.t05)??NXTMonthSumMonth();
    data['t06'] = (this.t06)??NXTMonthSumMonth();
    data['t07'] = (this.t07)??NXTMonthSumMonth();
    data['t08'] = (this.t08)??NXTMonthSumMonth();
    data['t09'] = (this.t09)??NXTMonthSumMonth();
    data['t10'] = (this.t10)??NXTMonthSumMonth();
    data['t11'] = (this.t11)??NXTMonthSumMonth();
    data['t12'] = (this.t12)??NXTMonthSumMonth();
    data['sum12Month'] = (this.sum12Month)??NXTMonthSumMonth();
    return data;
  }

  static List<NXTMonthSum> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => NXTMonthSum.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<NXTMonthSum>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}

class NXTMonthSumMonth {
  double? qtyBg;
  double? qtyIn;
  double? qtyOut;
  double? qtyEnd;

  NXTMonthSumMonth({double? qtyBg, double? qtyIn, double? qtyOut, double? qtyEnd}){
    this.qtyBg = qtyBg??0;
    this.qtyIn = qtyIn??0;
    this.qtyOut = qtyOut??0;
    this.qtyEnd = qtyEnd??0;
  }

  factory NXTMonthSumMonth.fromJson(Map<String, dynamic>? json) {
    late NXTMonthSumMonth result = NXTMonthSumMonth();
    if (json != null){
    result = NXTMonthSumMonth(  
      qtyBg: (json['qtyBg'])??0,
      qtyIn: (json['qtyIn'])??0,
      qtyOut: (json['qtyOut'])??0,
      qtyEnd: (json['qtyEnd'])??0);
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qtyBg'] = (this.qtyBg)??0;
    data['qtyIn'] = (this.qtyIn)??0;
    data['qtyOut'] = (this.qtyOut)??0;
    data['qtyEnd'] = (this.qtyEnd)??0;
    return data;
  }
}
