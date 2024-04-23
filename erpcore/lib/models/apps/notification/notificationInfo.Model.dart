import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class NotificationInfoModel {
	String? sysCode;
	String? title;
	String? description;
	String? content;
	PrCodeName? nextFunction;
	List<PrCodeName>? tags;
	int? status;
	String? fileUrl;
  PrDate? createDate;
  String? createHour;
  String? createDay;
  dynamic refCode; // lưu thông tin sysCode phiếu

	NotificationInfoModel({this.sysCode, this.title, this.description, this.content, this.nextFunction, this.tags, this.status, this.fileUrl,this.createDate,this.refCode, this.createHour, this.createDay});

	NotificationInfoModel.fromJson(Map<String, dynamic> json) {
		try{
      sysCode = json['sysCode'] ?? (json['SysCode']);
      title = json['title']??json['name'] ?? (json['Title']??json['Name']);
      description = json['description'] ?? (json['Description']);
      content = json['content'] ?? (json['Content']);
      nextFunction = PrCodeName.fromJson(json['nextFunction']??json['NextFunction']);
      refCode = json['refCode'] ?? (json['RefCode']);
      tags = PrCodeName.fromJsonList(json['tags'] ?? json['Tags']);
      var statusTemp = json['status'] ?? (json['Status']);
      if (statusTemp is String) {
        statusTemp = int.parse(statusTemp);
      }
      status = statusTemp;
      fileUrl = json['fileUrl']??json['sFile'] ?? (json['FileUrl']??json['SFile']);
      createDate = PrDate.fromJson(json['createdAt'] ?? (json['CreatedAt']));
      createHour = getCreateInfo();
      createDay = getCreateInfo(isHour: false);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex);
    }
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['sysCode'] = sysCode;
		data['title'] = title;
		data['description'] = description;
		data['content'] = content;
		data['nextFunction'] = nextFunction!.toJson();
		data['tags'] = PrCodeName.toJsonList(tags);
		data['status'] = status;
		data['fileUrl'] = fileUrl;
		data['createdAt'] = createDate?.toJson();
    data['refCode'] = refCode;
		return data;
	}

  static List<NotificationInfoModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => NotificationInfoModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<NotificationInfoModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  String getCreateInfo({bool isHour = true}){
    String result = "";
    try {
      if (createDate != null && !PrDate.isEmpty(createDate) && createDate!.sD != null && createDate!.sD!.isNotEmpty) {
        if (isHour) {
          result = createDate!.sD!.split(" ").last;
        } else {
          result = createDate!.sD!.split(" ").first;
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getCreateHour");
    }
    return result;
  }
}