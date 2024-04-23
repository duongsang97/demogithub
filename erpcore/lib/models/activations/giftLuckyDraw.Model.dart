class GiftLuckyDrawModel{
  int? index;
  String? sysCode;
  String? code;
  String? name;
  String? image;
  String? imageLucky;
  String? assetImage;
  int? rate;
  int? target;
  String? note;
  String? colorCode;

  GiftLuckyDrawModel({this.assetImage,this.code,this.colorCode,this.image,this.index,this.name,this.note,this.rate,this.sysCode,this.target, this.imageLucky});

  factory GiftLuckyDrawModel.fromJson(Map<String, dynamic>? json) {
    late GiftLuckyDrawModel result = GiftLuckyDrawModel();
    if(json != null){
    result = GiftLuckyDrawModel(
      sysCode: (json["sysCode"])??"",
      code: (json["code"])??"",
      name: (json["name"])??"",
      image: (json["image"])??"",
      imageLucky: (json["imageLucky"])??"",
      rate: (json["rate"])??0,
      note: (json["note"])??"",
      colorCode: (json["colorCode"])??"",
      target: (json["target"])??0,
      assetImage: (json["assetImage"])??"",
      index: (json["index"])??0,
    );
    }
    return result;
  }

  static List<GiftLuckyDrawModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => GiftLuckyDrawModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": (this.sysCode)??"",
      "code": (this.code)??"",
      "name": (this.name)??"",
      "image": (this.image)??"",
      "imageLucky": (this.imageLucky)??"",
      "rate": (this.rate)??0,
      "note": (this.note)??"",
      "colorCode": (this.colorCode)??"",
      "target": (this.target)??0,
    };
    return map;
  }
}