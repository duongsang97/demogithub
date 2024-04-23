import 'package:erpcore/utility/app.Utility.dart';

import 'prCodeName.Model.dart';

class UserInfoModel {
  String? sysCode = "";
  String? code = "";
  String? userName = "";
  String? fullName = "";
  String? displayName = "";
  String? token = "";
  bool? verified = false;
  String? urlAvatar ="";
  String? birthday = "";
  String? empNo = "";
  List<PrCodeName>? listNumberPhone;
  List<PrCodeName>? listEmail;
  PrCodeName? country;
  PrCodeName? city;
  PrCodeName? district;
  PrCodeName? ward;
  String? street;
  String get avatarImage{
    String result = "https://erp.acacy.com.vn/assets/images/avatar/default.png";
    if(urlAvatar != null && urlAvatar!.isNotEmpty){
      result="${getServerName(false)}/${urlAvatar??""}";
    }
    return result;
  }
  String get phoneDefault=> (!PrCodeName.isEmpty(listNumberPhone?.last))?(listNumberPhone!.last.code!):"";
  String get emailDetail=> (!PrCodeName.isEmpty(listEmail?.last))?(listEmail!.last.code!):"";

  UserInfoModel({this.displayName,this.fullName,this.sysCode,this.token,this.userName,this.verified,this.birthday,this.city,this.country,this.district,this.empNo,
    this.listEmail,this.listNumberPhone,this.street,this.urlAvatar,this.ward,this.code
  });

  factory UserInfoModel.fromJson(Map<String, dynamic>? json) {
    late UserInfoModel result = UserInfoModel();
    if (json != null) {
      result = UserInfoModel(
        code: (json["code"]),
        sysCode: (json["sysCode"]),
        userName: (json["userName"]),
        fullName: (json["fullName"]),
        displayName:(json["displayName"])??"",
        token:(json["token"])??"",
        verified:(json["verified"])??false,
        urlAvatar: (json["urlAvatar"])??"",
        birthday: (json["birthday"])??"",
        empNo: (json["empNo"])??"",
        country: PrCodeName.fromJson(json["country"]),
        city: PrCodeName.fromJson(json["city"]),
        district: PrCodeName.fromJson(json["district"]),
        ward: PrCodeName.fromJson(json["ward"]),
        street: (json["street"])??"",
      );
    }
    return result;
  }

  static List<PrCodeName> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PrCodeName.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PrCodeName>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "code": code,
      "sysCode": sysCode,
      "userName": userName,
      "fullName": fullName,
      "displayName": displayName,
      "token": token,
      "verified": verified,
      "urlAvatar": urlAvatar,
      "birthday": birthday,
      "empNo": empNo,
      "country": country?.toJson(),
      "city": city?.toJson(),
      "district": district?.toJson(),
      "ward": ward?.toJson(),
      "street": street,
    };
    return map;
  }
}