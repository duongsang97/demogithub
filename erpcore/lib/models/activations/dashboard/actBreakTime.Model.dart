class BreakTimeItemModel {
  String? startTime;
  String? endTime;
  String? totaltime;
  String? reason;
  String? imageStart;
  String? imageEnd;

  BreakTimeItemModel(
      {this.startTime,
      this.endTime,
      this.totaltime,
      this.reason,
      this.imageStart,
      this.imageEnd});

  BreakTimeItemModel.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    totaltime = json['totaltime'];
    reason = json['reason'];
    imageStart = json['imageStart'];
    imageEnd = json['imageEnd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['totaltime'] = totaltime;
    data['reason'] = reason;
    data['imageStart'] = imageStart;
    data['imageEnd'] = imageEnd;
    return data;
  }

  static List<BreakTimeItemModel> fromJsonList(List? list) {
    if (list == null) return List<BreakTimeItemModel>.empty(growable: true);
    return list.map((item) => BreakTimeItemModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<BreakTimeItemModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}