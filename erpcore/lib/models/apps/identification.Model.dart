class IdentificationModel {
  String? qrCodeBase64;
  String? entrySetupCode;
  bool? validate;
  IdentificationModel({this.qrCodeBase64,this.entrySetupCode,this.validate});


  factory IdentificationModel.fromJson(Map<String, dynamic>? json) {
    late IdentificationModel result = IdentificationModel();
    if (json != null) {
      result = IdentificationModel(
        qrCodeBase64: json["qrCodeBase64"] ?? "",
        entrySetupCode: json["entrySetupCode"] ?? "",
        validate: json["validate"] ?? false,
      );
    }
    return result;
  }

  static List<IdentificationModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => IdentificationModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<IdentificationModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "qrCodeBase64": (qrCodeBase64) ?? "",
      "entrySetupCode": (entrySetupCode) ?? "",
      "validate": (validate) ?? false,
    };
    return map;
  }

}
