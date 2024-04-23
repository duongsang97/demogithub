import 'dart:async';
import 'dart:io';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/models/apps/signature/signatureAvailable.Model.dart';
import 'package:erpcore/providers/erp/esignature.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/components/selectBox/selectFile.Component.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignatureDetailController extends GetxController{
  RxInt type = 0.obs; // 0 => update | 1 => add
  RxBool isLoading = true.obs;
  Rx<SignatureAvailableModel> signature = SignatureAvailableModel().obs;
  Rx<PrCodeName> accountSelected = Rx<PrCodeName>(PrCodeName());
  RxBool isFocusCode = false.obs; 
  Timer? timer;
  Rx<ItemSelectDataActModel> fileSelected = ItemSelectDataActModel().obs;
  final ImagePicker picker = ImagePicker();
  Rx<File> fileImageChoose = File("").obs; // hiển thị
  Rx<PrFileUpload> fileImage = PrFileUpload().obs; // truyền api
  DocumentProvider documentProvider = DocumentProvider();
  String sysCode = "";
  RxList<PrCodeName> listUser = RxList.empty(growable: true);
  late AppController appController;
  Rx<ItemSelectDataActModel> typeSelected = ItemSelectDataActModel().obs; 
  RxList<ItemSelectDataActModel> listType = RxList.empty(growable: true);
  Rx<File> imageDefault = File("").obs;
  TextEditingController width = TextEditingController();
  TextEditingController height = TextEditingController();
  Rx<PrFileUpload> fileImageDefault = PrFileUpload().obs; // truyền api
  RxBool isLoadingImage = false.obs;
  List<String> listPathImage = List.empty(growable: true);

  @override
  void onReady() {
    appController = Get.find();
    initData();
    super.onReady();
  }

  @override
  void onClose() async {
    if (fileImageChoose.value.existsSync() && fileImageChoose.value.lengthSync() > 0) {
      await fileImageChoose.value.delete();
    }
    if (imageDefault.value.existsSync() && imageDefault.value.lengthSync() > 0) {
      await imageDefault.value.delete();
    }
    super.onClose();
  }

  Future<void> removeImageFromLocal() async {
    try {
      for (var imagePath in listPathImage) {
        if (File(imagePath).existsSync() && File(imagePath).lengthSync() > 0){
          await File(imagePath).delete();
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e,func: "removeImageFromLocal SignatureDetail.Component");
    }
  }

  void initData() async {
    try {
      isLoading.value = true;
      listType.add(ItemSelectDataActModel(code: "0", name: "Mặc định"));
      listType.add(ItemSelectDataActModel(code: "2", name: "Upload hình"));
      typeSelected.value = listType.last;
      signature.value.contentController.text = "Duyệt bởi";
      width.text = "250";
      height.text = "120";
      listType.refresh();
      await fetchUserData();
      Future.wait([
        // fetchImageDefault(),
        fetchData(),
      ]).then((value) {
        isLoading.value = false;
      });
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e,func: "initData SignatureDetail.Component");
    }
  }

  void onChangeType(ItemSelectDataActModel item) {
    try {
      for (var type in listType) {
        if (type.code == item.code) {
          typeSelected.value = item;
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e,func: "onChangeType SignatureDetail.Component");
    }
  }

  Future<ResponsesModel> fetchUserData({String keyword = "",int page = 1, int pageSize = 15}) async{
    ResponsesModel result = ResponsesModel();
    try {
      result = await documentProvider.getListUser(keyword: keyword,page: page,pageSize: pageSize);
      if (result.statusCode == 0) {
        listUser.value = result.data;
      }
    return result;
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e,func: "fetchUserData SignatureDetail.Component");
    }
    return result;
  }

  Future<void> fetchImageDefault({String content = "Duyệt bởi", String position = "", String name = "" }) async {
    try {
      isLoadingImage.value = true;
      var result = await documentProvider.getDefaultImageSign(content: content, position: position, name: name);
      if (result.statusCode == 0) {
        await removeImageFromLocal();
        String base64 = result.data;
        String temp = base64.substring(base64.indexOf(',') + 1);
        var imageInt = base64Decode(temp);  
        String tempPath = Directory.systemTemp.path;
        var name  = "${generateKeyCode()}.jpg";
        String imagePath = '$tempPath/$name';
        listPathImage.add(imagePath);
        imageDefault.value = File(imagePath);
        await imageDefault.value.writeAsBytes(imageInt);
        fileImageDefault.value = fileToPrFileUpload(imageDefault.value);
        isLoadingImage.value = false;
      } else {
        isLoadingImage.value = false;
        AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
      }
    } catch (e) {
      isLoadingImage.value = false;
      AppLogsUtils.instance.writeLogs(e,func: "fetchImageDefault SignatureDetail.Component");
    }
  }

  PrFileUpload  fileToPrFileUpload(File file, {String fileName = ""}) {
    var result = PrFileUpload();
    try {
      var extension = p.extension(file.path);
      result.sysCode = generateKeyCode();
      result.fileAsset = file.path;
      result.fileName = fileName.isNotEmpty ? fileName : "${generateKeyCode()}.jpg";
      result.kind =  PrCodeName(code: "imageSign");
      result.fileExt = extension;
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e,func: "fileToPrFileUpload SignatureDetail.Component");
    }
    return result;
  }

  void onChangedText(String value) async {
    try {
      const oneSec = Duration(seconds: 1);
      if (timer != null) {
        timer!.cancel();
      }
      var counter = 1;
      timer = Timer.periodic(oneSec,(Timer timer) async {
        await  fetchImageDefault(name: signature.value.nameController.text, content: signature.value.contentController.text, position: signature.value.positionController.text).then((value) {
          timer.cancel();
        });
        counter--;
        if (counter == 0) {
        }
      });
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e,func: "fileToPrFileUpload SignatureDetail.Component");
    }
  }

  Future<void> fetchData() async {
    try {
      LoadingComponent.show(msg: "Đang tải dữ liệu...");
      if (type.value == 0) { // update
        isLoading.value = true;
        var result = await documentProvider.getOneSignature(sysCode: sysCode);
        if (result.statusCode == 0) {
          signature.value = result.data;
          signature.value.codeTextController.text = signature.value.code ?? "";
          signature.value.nameController.text = signature.value.name ?? "";
          signature.value.emailController.text = signature.value.email ?? "";
          signature.value.positionController.text = signature.value.position ?? "";
          signature.value.contentController.text = signature.value.content ?? "Duyệt bởi";
          accountSelected.value = signature.value.username ?? PrCodeName();
          signature.value.noteController.text = signature.value.note ?? "";
          fileImage.value = signature.value.imageSign ?? PrFileUpload();
          signature.value.contentController.text = signature.value.content ?? "";
          var resultPosition = await documentProvider.getPositionByUser(sysCode: accountSelected.value.code ?? "");
          if (resultPosition.statusCode == 0) {
            signature.value.positionController.text = signature.value.position != null && signature.value.position!.isNotEmpty ? signature.value.position : resultPosition.data;
          }
          width.text = signature.value.width.toString();
          height.text = signature.value.height.toString();
          await fetchImageDefault(content: signature.value.content ?? "", name: signature.value.name ?? "", position: signature.value.position ?? "");
          if (signature.value.imageSign != null && signature.value.imageSign!.fileUrl != null && signature.value.imageSign!.fileUrl!.isNotEmpty) {
            await urlImageToFile(signature.value.urlImage ?? "", signature.value.imageSign?.fileName ?? "");
          }
          isLoading.value = false;
        } else {
          AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
          isLoading.value = false;
        }
      } else if (type.value == 1){
        var usernameCode = appController.userProfle.value.sysCode;
        for (var user in listUser) {
          if (user.code == usernameCode) {
            accountSelected.value = user;
          }
        }
        signature.value.nameController.text = accountSelected.value.name ?? "";
        var result = await documentProvider.getPositionByUser(sysCode: accountSelected.value.code ?? "");
        if (result.statusCode == 0) {
          signature.value.positionController.text = result.data;
          signature.value.position = result.data;
        } else {
          AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
        }
        await fetchImageDefault(content: signature.value.contentController.text, name: signature.value.nameController.text, position: signature.value.position ?? "");
        isLoading.value = false;
      }
      LoadingComponent.dismiss();
    } catch (e) {
      isLoading.value = false;
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e,func: "fetchData SignatureDetail.Component");
    }
  }

  Future<void> urlImageToFile(String imageUrl, String fileName) async {
    var response = await http.get(Uri.parse(imageUrl));
    var bytes = response.bodyBytes;
    String tempPath = Directory.systemTemp.path;
    String imagePath = '$tempPath/$fileName.jpg';
    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(bytes);
    fileImageChoose.value = imageFile;
  }

  void startTimer(FocusNode focusNode) {
    const oneSec = Duration(seconds: 10);
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(oneSec,(Timer timer) {
      if (focusNode.hasFocus == false) {
        isFocusCode.value = false;
      }
    }
  );}

  void onChangeStatusFocusCode (BuildContext context, FocusNode focusNode, {bool isAction = false}) {
    if (isAction) {
      isFocusCode.value = true;
    }
    startTimer(focusNode);
  }

  Future<void> onSelectFile(String type) async {
    PrFileUpload fileImageTemp = PrFileUpload();
    try {
      if (type == "image") {
        var image = await picker.pickImage(
            source: ImageSource.camera, maxWidth: 1280, imageQuality: 90);
        if (image != null) {
          if (fileImageChoose.value.existsSync() && fileImageChoose.value.lengthSync() > 0) {
            await fileImageChoose.value.delete();
          }
          var file = PrFileUpload();
          file.sysCode = generateKeyCode();
          final extension = p.extension(image.path);
          file.fileAsset = image.path;
          file.fileName = image.name;
          file.kind = PrCodeName(code: "imageSign");
          file.fileExt = extension;
          fileImageTemp = file;
        }
      } else if (type == "gallery") {
        var gallery = await picker.pickMultiImage(maxWidth: 1280, imageQuality: 90);
        if (gallery.isNotEmpty) {
          if (fileImageChoose.value.existsSync() && fileImageChoose.value.lengthSync() > 0) {
            await fileImageChoose.value.delete();
          }
          for (var fileTemp in gallery) {
            var file = PrFileUpload();
            var extension = p.extension(fileTemp.path);
            file.sysCode = generateKeyCode();
            file.fileAsset = fileTemp.path;
            file.fileName = fileTemp.name;
            file.kind =  PrCodeName(code: "imageSign");
            file.fileExt = extension;
            fileImageTemp = file;
          }
        }
      }
      if (fileImageTemp.fileAsset != null && fileImageTemp.fileAsset!.isNotEmpty) {
        File file = File(fileImageTemp.fileAsset!);
        fileImageChoose.value = file;
        fileImage.value = fileImageTemp;
      }
    } catch (ex) {
      AlertControl.push("Có lỗi trong quá trình chọn file, vui lòng thử lại", type: AlertType.ERROR);
      AppLogsUtils.instance.writeLogs(ex,func: "onSelectFile SignatureDetail.Component");
    }
  }

  void removeImageSignature() {
    try {
      if (fileImageChoose.value.existsSync() && fileImageChoose.value.lengthSync() > 0) {
        fileImageChoose.value.deleteSync();
      }
      fileImageChoose.value = File("");
      fileImage.value = PrFileUpload();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "removeImageSignature SignatureDetail.Controller");
    }
  }

  Future<void> onActionImage (int type, BuildContext context) async {
    // type 1: Change Image - 0 : Delete
    try {
      if (type == 1) {
        await ModalSheetComponent.showBarModalBottomSheet(
          SelectFileBoxComponent(
            onSelectedType: (type){
              onSelectFile(type);
            },
            isChooseImage: true,
          ),
          formSize: 0.4,
          isDismissible: false,
          expand: true,
          enableDrag: true
        );
      } else if (type == 0) {
        var result = await Alert.showDialogConfirm("Xóa chữ ký", "Bạn muốn xóa chữ ký không?");
        if (result) {
          removeImageSignature();
        }
      } 
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onActionImage SignatureDetail.Controller");
    }
  }

  bool validDataInput () {
    bool result = false;
    try {
      if (signature.value.nameController.text.isNotEmpty && signature.value.emailController.text.isNotEmpty && accountSelected.value.code != null && accountSelected.value.code!.isNotEmpty) {
        result = true;
      }
    return result;
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "validDataInput SignatureDetail.Controller");
    }
    return result;
  }

  Future<String> convertToBase64(File file) async {
    String base64 = "";
    try {
      List<int> fileBytes = await file.readAsBytes();
      base64 = base64Encode(fileBytes);
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "convertToBase64 SignatureDetail.Controller");
    }
    return base64;
  }

  Future<void> onSaveSignature() async {
    try {
      bool validResult = validDataInput();
      if (validResult) {
        // 1 => add
        if (type.value == 1) {
          LoadingComponent.show(msg: "Đang xử lý dữ liệu");
          String imageBase64 = await convertToBase64(typeSelected.value.code == "0" ? imageDefault.value : fileImageChoose.value);
          signature.value.code = signature.value.codeTextController.text;
          signature.value.email = signature.value.emailController.text;
          signature.value.name = signature.value.nameController.text;
          signature.value.username = accountSelected.value;
          signature.value.note = signature.value.noteController.text;
          signature.value.position = signature.value.positionController.text;
          signature.value.isNew = 1;
          signature.value.editMode = false;
          signature.value.p12Url = imageBase64;
          signature.value.imageName = imageBase64;
          signature.value.typeSign = int.parse(typeSelected.value.code ?? "");
          if (typeSelected.value.code == "0") { // chữ kí mặc định
            signature.value.width = int.parse(width.text.isNotEmpty ? width.text : "250");
            signature.value.height = int.parse(height.text.isNotEmpty ? height.text : "120");
            signature.value.content = signature.value.contentController.text;
          } else {
            signature.value.content = "";
            width.text = "";
            height.text = "";
          }
          var result = await documentProvider.saveSignature(signature.value, typeSelected.value.code == "0" ? fileImageDefault.value : fileImage.value);
          if (result.statusCode == 0) {
            if (fileImageChoose.value.existsSync() && fileImageChoose.value.lengthSync() > 0) {
              await fileImageChoose.value.delete();
            }
            Get.back(result: result.data);
            AlertControl.push("Thêm chữ ký thành công", type: AlertType.ERROR);
            LoadingComponent.dismiss();
          } else {
            AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
            LoadingComponent.dismiss();
          }
        } else if (type.value == 0) {
          LoadingComponent.show(msg: "Đang xử lý dữ liệu");
          String imageBase64 = await convertToBase64(typeSelected.value.code == "0" ? imageDefault.value : fileImageChoose.value);
          signature.value.code = signature.value.codeTextController.text;
          signature.value.email = signature.value.emailController.text;
          signature.value.name = signature.value.nameController.text;
          signature.value.username = accountSelected.value;
          signature.value.note = signature.value.noteController.text;
          signature.value.position = signature.value.positionController.text;
          signature.value.isNew = 0;
          signature.value.editMode = true;
          signature.value.p12Url = imageBase64;
          signature.value.imageName = imageBase64;
          signature.value.typeSign = int.parse(typeSelected.value.code ?? "");
          if (typeSelected.value.code == "0") { // chữ kí mặc định
            signature.value.width = int.parse(width.text.isNotEmpty ? width.text : "250");
            signature.value.height = int.parse(height.text.isNotEmpty ? height.text : "120");
            signature.value.content = signature.value.contentController.text;
          } else {
            signature.value.content = "";
            width.text = "";
            height.text = "";
          }
          var result = await documentProvider.saveSignature(signature.value, typeSelected.value.code == "0" ? fileImageDefault.value : fileImage.value, isUpdate: true);
          if (result.statusCode == 0) {
            if (fileImageChoose.value.existsSync() && fileImageChoose.value.lengthSync() > 0) {
              await fileImageChoose.value.delete();
            }
            Get.back(result: result.data);
            AlertControl.push("Lưu chữ ký thành công", type: AlertType.SUCCESS);
            LoadingComponent.dismiss();
          } else {
            AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
            LoadingComponent.dismiss();
          }
        }
      } else {
        AlertControl.push("Hãy điền thông tin cần thiết", type: AlertType.ERROR);
      }
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "onSaveSignature SignatureDetail.Controller");
    }
  }
} 