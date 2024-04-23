import 'package:camera/camera.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/auth/identityChecking/identityChecking.Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'elements/imageScannerAnimation.Element.dart';

class IdentityCheckingScreen extends GetWidget<IdentityCheckingController>{
  final IdentityCheckingController identityCheckingController = Get.find();
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    identityCheckingController.size = size;
    return PopScope(
      onPopInvoked:(bool v){
        if(Get.isRegistered<IdentityCheckingController>()){
          Get.delete<IdentityCheckingController>();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor.withOpacity(0.8),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Column(
                  children: [
                    Obx(()=>identityCheckingController.recognitionStatus.value == 0?
                      ClipOval(
                      child: Obx(()=>Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SizedBox(
                            height: (size.width*.8)+5,
                            width: (size.width*.8)+5,
                            child: Obx(()=>CircularProgressIndicator(
                              value: identityCheckingController.processRecognition.value,
                              strokeWidth: 10,
                              backgroundColor: AppColor.grey.withOpacity(0.6),
                              color: identityCheckingController.processRecognitionColor.value,
                            ),)
                          ),
                          AnimatedSize(
                            duration:const Duration(seconds: 1),
                            curve: Curves.easeOutCirc,
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              height: (identityCheckingController.circleBoxSize.value)-10,
                              width: (identityCheckingController.circleBoxSize.value)-10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.whiteColor,
                              ),
                              child: identityCheckingController.cameraReady.value
                                ?ClipOval(child:CameraPreview(identityCheckingController.cameraController!))
                                :Center(
                                  child: Image.asset("assets/images/face-recognition.png",height: size.width*.4,width: size.width*.4,),
                                ),
                              ),
                          ),
                          ImageScannerAnimation(!identityCheckingController.scanning.value,(size.width*.8)-10,
                            animation: identityCheckingController.animationController,
                          ),
                          ],
                        )
                      )
                    ):Center(
                      child: Obx(()=>_buildImageResult()),
                    )),
                    _buildFooter()
                  ],
                )
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _buildImageResult(){
    Widget child = Image.asset("assets/images/warning.png",height: size.width*.5,width: size.width*.5,); 
    if(identityCheckingController.recognitionStatus.value ==1){
      child = Image.asset("assets/images/check.png",height: size.width*.5,width: size.width*.5,); 
    }
    return child;
  }

  Widget _buildHeader(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios,color: AppColor.grey,),
              )
            ],
          ),
          SizedBox(height: size.height*.1,),
          Obx(()=>
            !identityCheckingController.scanning.value?
            const Text("XÁC MINH DANH TÍNH",style: TextStyle(color: AppColor.brightBlue,fontSize: 18,fontWeight: FontWeight.bold),)
            :const Text("Đang xác minh...",style: TextStyle(color: AppColor.brightBlue,fontSize: 18,fontWeight: FontWeight.bold),)
          ),
          const SizedBox(height: 30,),
        ],
      )
    );
  }

  Widget _buildFooter(){
    return Obx(()=>
      Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: identityCheckingController.scanning.value,
              child:  Text(identityCheckingController.recognitionMsg.value,
              textAlign: TextAlign.center,
                style: const TextStyle(
                color: AppColor.brightBlue,fontSize: 16
              ),),
            ),
            const SizedBox(height: 20,),
            Visibility(
              visible: !identityCheckingController.scanning.value,
              child: CupertinoButton(
                color: CupertinoColors.activeGreen,
                  onPressed: () {
                    identityCheckingController.onPressFaceRecognition(!identityCheckingController.scanning.value);
                  },
                  child: const Text("Bắt đầu"),
                ),
            ),
          ],
        )
      ),
    );
  }

}