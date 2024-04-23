import 'package:erpcore/models/apps/PrDate.Model.dart';

class MessageSendingModel {
  String? sysCode;
  String? company;
  String? senderChanel;
  String? sender;
  int? sendtime;
  String? receiver;
  String? receiverChanel;
  int? type;
  String? content;
  String? refdata;
  //List<Null> readerTracks;
  int? syslock;
  int? sysStatus;
  int? sysApproved;
  int? isQC;
  PrDate? createDate;
  String? createUser;
  int? createKindInput;
  int? modifyKindInput;
  int? mustCalSearch;

  MessageSendingModel({this.company,this.content,this.createDate,this.createKindInput,this.createUser,this.isQC,this.modifyKindInput,
    this.mustCalSearch,this.receiver,this.receiverChanel,this.refdata,this.sender,this.senderChanel,this.sendtime,this.sysApproved,
    this.sysCode,this.sysStatus,this.syslock,this.type,
  });

  factory MessageSendingModel.fromJson(Map<String, dynamic>? json) {
    late MessageSendingModel result = MessageSendingModel();
    if(json != null){
      result = MessageSendingModel(
        sysCode : json['sysCode'],
        company : json['company'],
        senderChanel : json['senderChanel'],
        sender : json['sender'],
        sendtime : json['sendtime'],
        receiver : json['receiver'],
        receiverChanel : json['receiverChanel'],
        type : json['type'],
        content : json['content'],
        refdata : json['refdata'],
        syslock : json['syslock'],
        sysStatus : json['sysStatus'],
        sysApproved : json['sysApproved'],
        isQC : json['isQC'],
        createDate : json['createDate'] != null ? new PrDate.fromJson(json['createDate']) : null,
        createUser : json['createUser'],
        createKindInput : json['createKindInput'],
        modifyKindInput : json['modifyKindInput'],
        mustCalSearch : json['mustCalSearch'],
        // if (json['readerTracks'] != null) {
        //   readerTracks = new List<Null>();
        //   json['readerTracks'].forEach((v) {
        //     readerTracks.add(new Null.fromJson(v));
        //   });
        // }
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sysCode'] = (this.sysCode)??"";
    data['company'] = (this.company)??"";
    data['senderChanel'] = (this.senderChanel)??"";
    data['sender'] = (this.sender)??"";
    data['sendtime'] = (this.sendtime)??0;
    data['receiver'] = (this.receiver)??"";
    data['receiverChanel'] = (this.receiverChanel)??"";
    data['type'] = (this.type)??0;
    data['content'] = (this.content)??"";
    data['refdata'] = (this.refdata)??"";
    data['syslock'] = (this.syslock)??0;
    data['sysStatus'] = (this.sysStatus)??0;
    data['sysApproved'] = (this.sysApproved)??0;
    data['isQC'] = (this.isQC)??0;
    data['createDate'] = this.createDate != null?(this.createDate!.toJson()):{};
    data['createUser'] =( this.createUser)??"";
    data['createKindInput'] =( this.createKindInput)??0;
    data['modifyKindInput'] =( this.modifyKindInput)??0;
    data['mustCalSearch'] =( this.mustCalSearch)??0;
    // if (this.readerTracks != null) {
    //   data['readerTracks'] = this.readerTracks.map((v) => v.toJson()).toList();
    // }
    return data;
  }

   static List<MessageSendingModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => MessageSendingModel.fromJson(item)).toList();
  }
  static  List<Map<String, dynamic>> toJsonList(List<MessageSendingModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }
}