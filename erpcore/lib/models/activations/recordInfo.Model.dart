class RecordInfoModel{
  String workingPlanCode = "";
  String? shopName;
  bool? status;
  DateTime? createdAt;

  RecordInfoModel({this.createdAt,this.shopName,this.status,required this.workingPlanCode});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "workingPlanCode": this.workingPlanCode,
      "status": (this.status)??false,
      "createdAt": this.createdAt!=null?this.createdAt.toString():DateTime.now(),
      "shopName":(this.shopName)??""
    };
    return map;
  }

  factory RecordInfoModel.fromJson(Map<String, dynamic>? json) {
    late RecordInfoModel result = RecordInfoModel(workingPlanCode: "");
    if (json != null){
    result = RecordInfoModel(
      workingPlanCode: (json["workingPlanCode"])??"",
      status: (json["status"])??false,
      createdAt: (json["createdAt"] !=null && json["createdAt"] != "null")?DateTime.parse(json["createdAt"]):DateTime.now(),
      shopName: (json["shopName"])??"",
    );
    }
    return result;
  }
}