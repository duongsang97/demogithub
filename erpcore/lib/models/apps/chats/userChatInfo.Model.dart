import 'package:erpcore/utility/dateTime.Utility.dart';

class UserChatInfoModel {
  String? chanel;
  String? username;
  String? nickname;
  String? avatar;
  String? content;
  String? sendtime;
  DateTime? get lastSendTime => DateTimeUtils().getDateFromVNDate(sendtime??"",getTime: true);
  bool? online;
  int? logon;
  int? logout;
  int? seen;

  UserChatInfoModel({this.avatar,this.chanel,this.logon,this.logout,this.nickname,this.online,this.username,this.content,this.sendtime,this.seen = 1});

  factory UserChatInfoModel.fromJson(Map<String, dynamic>? json) {
    late UserChatInfoModel result = UserChatInfoModel();
    if(json != null){
      result = UserChatInfoModel(
        chanel : (json['chanel'])??"",
        username : (json['username'])??"",
        nickname : (json['nickname'])??"",
        avatar : (json['avatar'])??"",
        online : (json['online'])??false,
        logon : (json['logon'])??0,
        logout : (json['logout'])??0,
        content : (json['content'])??"",
        sendtime : (json['sendtime'])??"",
        seen : (json['seen'])??1,
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['chanel'] = (chanel)??"";
    data['username'] = (username)??"";
    data['nickname'] = (nickname)??"";
    data['avatar'] = (avatar)??"";
    data['online'] = (online)??false;
    data['logon'] = (logon)??0;
    data['logout'] = (logout)??0;
    data['content'] = (content)??"";
    data['sendtime'] = (sendtime)??"";
    data['seen'] = (seen)??1;
    return data;
  }

    static List<UserChatInfoModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => UserChatInfoModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<UserChatInfoModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}