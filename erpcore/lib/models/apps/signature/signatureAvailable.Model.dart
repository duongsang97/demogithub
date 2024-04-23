import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

class SignatureAvailableModel {
  String? sysCode;
  PrCodeName? company;
  String? code;
  String? name;
  PrFileUpload? imageSign;
  PrFileUpload? p12Sign;
  PrCodeName? username;
  String? email;
  String? note;
  int? sortOrder;
  int? sysStatus;
  String? strResult;
  int? type;
  List<DataImageActModel>? imageData = List<DataImageActModel>.empty(growable: true);
  String? urlImage;
  TextEditingController codeTextController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String? p12Url;
  String? imageName;
  int? isNew;
  bool? editMode;
  int? sysApproved;
  int? isQC;
  String? createUser;
  String? position;
  int? typeSign;
  String? content;
  int? width;
  int? height;

  SignatureAvailableModel({
    this.sysCode,
    this.company,
    this.code,
    this.name,
    this.imageSign,
    this.p12Sign,
    this.username,
    this.email,
    this.note,
    this.sortOrder,
    this.sysStatus,
    this.strResult,
    this.type,
    this.imageData,
    this.urlImage,
    this.p12Url,
    this.imageName,
    this.isNew,
    this.editMode = false,
    this.sysApproved,
    this.isQC,
    this.createUser,
    this.position,
    this.typeSign,
    this.content,
    this.width,
    this.height
  });

  SignatureAvailableModel.fromJson(Map<String, dynamic>? json) {
    try {
      if (json != null) {
        sysCode = json['sysCode'] ?? "";
        company = PrCodeName.fromJson(json['company']);
        code = json['code'] ?? "";
        name = json['name'] ?? "";
        imageSign = PrFileUpload.fromJson(json["imageSign"]);
        p12Sign = PrFileUpload.fromJson(json["p12Sign"]);
        username = PrCodeName.fromJson(json['username']);
        email = json['email'] ?? "";
        note = json['note'] ?? "";
        sortOrder = json['sortOrder'] ?? 0;
        sysStatus = json['sysStatus'] ?? 0;
        strResult = json['strResult'] ?? "";
        type = json['type'] ?? 0;
        // imageData = DataImageActModel.fromJsonListFileUpload(json["imageSign"]);
        // urlImage = (json["imageSign"]["fileUrl"] != null)? createPathServer(json["imageSign"]["fileUrl"], json["imageSign"]["rootFileName"]):(json["imageSign"]["urlImage"])??"";
        urlImage = (json["imageSign"]["fileUrl"] != null)? createPathServer(json["imageSign"]["fileUrl"], json["imageSign"]["fileName"]):(json["imageSign"]["urlImage"])??"";
        p12Url = json['p12Url'] ?? "";
        isNew = json['isNew'] ?? 0;
        editMode = json['editMode'] ?? false;
        sysApproved = json['sysApproved'] ?? 0;
        isQC = json['isQC'] ?? 0;
        createUser = json['createUser'] ?? "";
        position = json['position'] ?? "";
        typeSign = json['typeSign'] ?? 0;
        content = json['content'] != null && json['content'] != "" ? json['content'] :  "Duyệt bởi";
        width = (json['width'] != null && json['width'] != 0) ? json['width'] : 250;
        height = (json['height'] != null && json['height'] != 0) ? json['height'] : 120;
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex, func: "SignatureAvailableModel.fromJson");
    }
  }

  static List<SignatureAvailableModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => SignatureAvailableModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    try {
      data['SysCode'] = sysCode ?? "";
      data['Company'] = company != null ? (company!.toJson()) : PrCodeName().toJson();
      data['Code'] = code ?? "";
      data['Name'] = name ?? "";
      data['ImageSign'] = imageSign != null ? imageSign!.toJson() : PrFileUpload().toJson();
      data['P12Sign'] = p12Sign != null ? p12Sign!.toJson() : PrFileUpload().toJson();
      data['Username'] = username != null ? (username!.toJson()) : PrCodeName().toJson();
      data['Email'] = email ?? "";
      data['Note'] = note ?? "";
      data['SortOrder'] = sortOrder ?? 0;
      data['SysStatus'] = sysStatus ?? 0;
      data['StrResult'] = strResult ?? "";
      data['Type'] = type ?? 0;
      data['p12Url'] = p12Url ?? "";
      data['imageName'] = imageName ?? "";
      data['IsNew'] = isNew ?? "";
      data['editMode'] = editMode ?? false;
      data['sysApproved'] = sysApproved ?? 0;
      data['isQC'] = isQC ?? 0;
      data['CreateUser'] = createUser ?? "";
      data['Position'] = position ?? "";
      data['TypeSign'] = typeSign ?? 0;
      data['Content'] = content ?? "Duyệt bởi";
      data['Width'] = width ?? 250;
      data['Height'] = height ?? 120;
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex, func: "SignatureAvailableModel.toJson");
    }
    return data;
  }

}
