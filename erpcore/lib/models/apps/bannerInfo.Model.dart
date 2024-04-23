import 'package:erpcore/utility/app.Utility.dart';

class BannerInfoModel{
  String sysCode="";
  DateTime? extDate;
  String? image;
  int? index;
  int? status;
  String? url;
  BannerInfoModel({required String sysCode,DateTime? extDate,String? image,int? index,int? status,String? url}){
    this.sysCode = sysCode;
    this.extDate = extDate?? DateTime.now();
    this.image = image??"";
    this.index = index??0;
    this.status = status??0;
    this.url = url??"";
  }
  factory BannerInfoModel.fromJson(Map<String, dynamic>? json) {
    late BannerInfoModel result = BannerInfoModel(sysCode: "");
    if (json != null){
    result = BannerInfoModel(
      sysCode: (json["uId"])??"",
      extDate: (json["extDate"])??DateTime.now(),
      image: (json["image"])??"",
      index: (json["index"])??0,
      status: (json["status"])??0,
      url: (json["url"])??"",
    );
    }
    return result;
  }

  static BannerInfoModel create(){
    return new BannerInfoModel(sysCode: generateKeyCode());
  }

  static List<BannerInfoModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => BannerInfoModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": this.sysCode,
      "extDate":(this.extDate)??DateTime.now(),
      "image": (this.image)??"",
      "index": (this.index)??0,
      "status": (this.status)??0,
      "url": (this.url)??"",
    };
    return map;
  }
}