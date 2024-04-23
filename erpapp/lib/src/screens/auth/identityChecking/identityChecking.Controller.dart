import 'dart:io';

import 'package:camera/camera.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/providers/erp/profile.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdentityCheckingController extends GetxController with GetTickerProviderStateMixin{
  CameraController? cameraController;
  late AnimationController animationController;
  late AnimationController recognitionController;
  late Animation<double> recognitionAnimation;
  late List<CameraDescription> _cameras;
  RxBool cameraReady = false.obs;
  late Size size;
  RxDouble circleBoxSize = 10.0.obs;
  RxBool scanning = false.obs;
  RxDouble processRecognition = 0.0.obs;
  Rx<Color> processRecognitionColor = AppColor.jadeColor.obs;
  late ProfileProvider profileProvider;
  int totalCheck = 0;
  RxInt recognitionStatus = 0.obs;
  RxString recognitionMsg = "".obs;
  late AppController appController;
  @override
  void onInit() {
    profileProvider = ProfileProvider();
    appController = Get.find();
    recognitionController = AnimationController(duration: const Duration(seconds: 3),vsync: this,)..repeat();
    recognitionAnimation = CurvedAnimation(parent: recognitionController,curve: Curves.easeInOut);
    animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    
    super.onInit();
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      animationController.reverse(from: 1.0);
    } else {
      animationController.forward(from: 0.0);
    }
  }
  @override
  void onReady() {
    // set size default
    circleBoxSize.value = (size.width*.8);
    super.onReady();
  }

  void changeSizeFaceBox(Function callback) async{
    circleBoxSize.value = 10.0;
    await Future.delayed(const Duration(milliseconds: 400),(){
      callback();
    });
    await Future.delayed(const Duration(milliseconds: 200),(){
      circleBoxSize.value = (size.width*.8);
    });
  }

  // nhận sự kiện click bắt đầu nhận diện
  void onPressFaceRecognition(bool flag){
    changeSizeFaceBox((){
      cameraInit(flag);
    });
  }

  @override
  void onClose() {
    try{
      animationController.dispose();
      if(cameraController != null){
        cameraController!.dispose();
      }
      recognitionController.dispose();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onClose identityChecking.Controller");
    }
    super.onClose();
  }

  void cameraInit(bool flag) async{
    try{
       if(flag){
        _cameras = await availableCameras();
        if(_cameras.isNotEmpty){
          cameraController = CameraController(_cameras[1], ResolutionPreset.max);
          cameraController!.initialize().then((_) {
            cameraReady.value = true;
            animateScanAnimation(false);
            scanning.value = true;
            recognitionStatus.value= 0;
            processRecognitionColor.value = AppColor.jadeColor;
            recognitionMsg.value ="Đưa mặt vào trong hình tròn để tiến hành xác minh";
            Future.delayed(const Duration(seconds: 1),sendImageToServerChecking);
          }).catchError((Object e) {
            if (e is CameraException) {
              switch (e.code) {
                case 'CameraAccessDenied':
                  print('User denied camera access.');
                  break;
                default:
                  print('Handle other errors.');
                  break;
              }
            }
          });
        }
       }
       else{
          cameraController!.dispose();
          cameraReady.value= false;
          scanning.value= false;
          recognitionStatus.value= 0;
          processRecognitionColor.value = AppColor.jadeColor;
          recognitionMsg.value ="Đưa mặt vào trong hình tròn để tiến hành xác minh";
          animateScanAnimation(false);
       }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "cameraInit identityChecking.Controller");
    }
  }

  Future<void> sendImageToServerChecking() async{
    try{
      processRecognition.value = 1;
      var file = await cameraController!.takePicture();
      var imageFinal = await compressImage(File(Uri.parse(file.path).path));
      if(imageFinal != null && await imageFinal.exists()){
         print(await imageFinal.length());
         AppLogsUtils.instance.writeLogs("faceIdVerify start");
         var result = await profileProvider.faceIdVerify(imageFinal.path);
         if(result.statusCode == 0){
            appController.userProfle.refresh();
            AppLogsUtils.instance.writeLogs("faceIdVerify success!");
            processRecognition.value = 1;
            recognitionStatus.value =1;
            processRecognitionColor.value = AppColor.jadeColor;
            recognitionMsg.value ="Danh tính đã được xác minh";
            Future.delayed(const Duration(seconds: 2,),(){
              Get.back();
            });
         }
         else{
           AppLogsUtils.instance.writeLogs("faceIdVerify failed!");
            processRecognition.value = 1;
            recognitionStatus.value =-1;
            processRecognitionColor.value = AppColor.brightRed;
            recognitionMsg.value ="Không thể xác minh danh tính";
         }
      }
      else{
        processRecognition.value =1;
        processRecognitionColor.value = AppColor.brightRed;

      }
      Future.delayed(const Duration(microseconds: 500),()=>onPressFaceRecognition(false));
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "sendImageToServerChecking identityChecking.Controller");
    }
  } 
}