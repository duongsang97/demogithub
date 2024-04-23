class ItemNXT {
  String? prdCode;
  String? prdName;
  String? unit;
  double? qtyBg;
  double? qtyIn;
  double? qtyOut;
  double? qtyEnd;

  ItemNXT({String? prdCode,String? prdName,String? unit,double? qtyBg,double? qtyIn,double? qtyOut,double? qtyEnd}){
    this.prdCode = prdCode?? "";
    this.prdName = prdName?? "";
    this.unit = unit?? "";
    this.qtyBg = qtyBg?? 0;
    this.qtyIn = qtyIn?? 0;
    this.qtyOut = qtyOut?? 0;
    this.qtyEnd = qtyEnd?? 0;
  }

  factory ItemNXT.fromJson(Map<String, dynamic>? json) {
    late ItemNXT result = ItemNXT();
    if (json != null){
    result = ItemNXT(
        prdCode: (json['prdCode'])??"",
        prdName: (json['prdName'])??"",
        unit: (json['unit'])??"",
        qtyBg: (json['qtyBg'])??0,
        qtyIn: (json['qtyIn'])??0,
        qtyOut: (json['qtyOut'])??0,
        qtyEnd: (json['qtyEnd'])??0);
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prdCode'] = (this.prdCode)??"";
    data['prdName'] = (this.prdName)??"";
    data['unit'] = (this.unit)??"";
    data['qtyBg'] = (this.qtyBg)??0;
    data['qtyIn'] = (this.qtyIn)??0;
    data['qtyOut'] = (this.qtyOut)??0;
    data['qtyEnd'] = (this.qtyEnd)??0;
    return data;
  }

  static List<ItemNXT> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => ItemNXT.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ItemNXT>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}
