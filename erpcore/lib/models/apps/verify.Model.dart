class VerifyModel {
  bool? isFace;
  bool? isFingerprint;
  bool? isIDNumber;

  VerifyModel({
    this.isFace,
    this.isFingerprint,
    this.isIDNumber,
  });

  factory VerifyModel.fromJson(Map<String, dynamic>? json) {
    late VerifyModel result = VerifyModel();
    if (json != null) {
      result = VerifyModel(
        isFace: (json["isFace"] ?? false),
        isFingerprint: (json["isFingerprint"] ?? false),
        isIDNumber: (json["isIDNumber"] ?? false),
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "isFace": isFace,
      "isFingerprint": isFingerprint,
      "isIDNumber": isIDNumber,
    };
    return map;
  }
}
