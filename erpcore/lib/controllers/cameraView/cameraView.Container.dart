import 'dart:io';
import 'dart:ui';
import 'package:erpcore/components/buttons/iconButton.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/controllers/cameraView/models/zoomScale.Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cameraView.Controller.dart';

class CameraViewScreen extends GetWidget<CameraViewController>{
  
  late Size size;
  final CameraViewController cameraViewController = Get.find();
  double topPadding = 0.0;
  double bottomPadding = 0.0;

  CameraViewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    topPadding = MediaQuery.of(context).padding.top+10;
    bottomPadding = MediaQuery.of(context).padding.bottom+10;
    return PopScope(
      onPopInvoked:(bool v){
        if(Get.isRegistered<CameraViewController>()){
          Get.delete<CameraViewController>();
        }
      },
      child: Scaffold(
        body: Obx(()=>SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              _buildHeaderCamera(),
              Expanded(child: (cameraViewController.cameraFlag.value)?(!cameraViewController.isLoading.value && cameraViewController.cameraController.value.isInitialized)
                ?(!cameraViewController.isInitFirst.value ? _buildCameraPreview() : waitCamera()) : (cameraViewController.isInitFirst.value ? const Center(child: Text("Camera Loading ..."),) : waitCamera())
                  :_buildResultView()),
               _buildFooterCamera()
            ],
          ),
        )),
      ),
    );
  }

  Widget waitCamera() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), 
      child: Container(width: size.width, color: AppColor.darkText));
  }

  Widget _buildCameraPreview(){
    return Stack(
      children: [
        GestureDetector(
          onScaleStart: (details) {
          },
          onScaleUpdate: (details) {
            if (controller.isVisibleZoom.value) {
              controller.onScaleUpdate( details, size.width, size.height);
            }
          }, 
          onScaleEnd: (details) {
            if (controller.isVisibleZoom.value) {
              controller.onScaleEnd(details);
            }
          },
          child: cameraViewController.cameraController.buildPreview()
        ),
        Obx(() => Visibility(
          visible: controller.isVisibleZoom.value,
          child: Positioned(
            bottom: 30,
            left: size.width / 2 - (14 * 3),
            child: Obx(() => SizedBox(
              width: size.width,
              height: 30,
              child: ListView.builder(
                itemCount: controller.listZoomScale.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return buttonZoomScale(controller.listZoomScale[index]);
                },
              ),
            )) 
          ),
        )),
        Obx(() => Visibility(
          visible: cameraViewController.isMultiTakePhoto.value && cameraViewController.listImageMulti.isNotEmpty,
          child: Positioned(
            left: 20,
            right: 20,
            bottom: 80,
            child: Container(
              width: size.width,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: cameraViewController.listImageMulti.length,
                itemBuilder: (BuildContext context, int index){
                  EdgeInsets margin;
                  if (index == 0) {
                    margin = const EdgeInsets.only(right: 5.0);
                  } else if (index == (cameraViewController.listImageMulti.length - 1)) {
                    margin = const EdgeInsets.only(left: 5.0);
                  } else {
                    margin = const EdgeInsets.symmetric(horizontal: 5.0);
                  }
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap:(){
                          
                        },
                        child: Container(
                          width: size.width * 0.2,
                          height: 70,
                          padding: const EdgeInsets.all(5.0),
                          margin: margin,
                          child: Image.file(File(cameraViewController.listImageMulti[index].path), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap:(){
                            cameraViewController.removeImageFromListMulti(cameraViewController.listImageMulti[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: AppColor.brightRed,
                            ),
                            width: 16,
                            height: 16,
                            child: const Icon(Icons.close, size: 10, color: AppColor.whiteColor,),
                          ),
                        )
                      ),
                    ],
                  );
                }  
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget buttonZoomScale(ZoomScaleModel zoomScale) {
    return GestureDetector(
      onTap:(){
        controller.setZoomScale(zoomScale);
      },
      child: zoomScale.isChoose == true ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: AppColor.whiteColor
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        alignment: Alignment.center,
        child: Text(zoomScale.title ?? "", textAlign: TextAlign.center, style: const TextStyle(color: AppColor.darkText , fontSize: 12, fontWeight: FontWeight.bold),),
      ) : Container(margin: const EdgeInsets.symmetric(horizontal: 5.0),child: const Icon(Icons.circle, size: 14, color: AppColor.whiteColor)),
    );
  }

  Widget _buildResultView(){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(Uri.parse(cameraViewController.imageResult.path).path,))
        )
      ),
    );
  }

  Widget _buildHeaderCamera(){
    return Container(
      color: AppColor.grey,
      height: topPadding+40,
      padding: EdgeInsets.only(top: topPadding,bottom: 5, left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Visibility(
            visible: cameraViewController.cameraFlag.value,
            child: IconButtonComponent(icon: Icon(cameraViewController.getIconFlashStatus(cameraViewController.flashMode.value),size: 30,color: AppColor.whiteColor,), onPress: (){
              cameraViewController.onPressChangeFlashMode().then((value){
              });
            })
          )),
          const SizedBox(width: 20,),
          Obx(() => Visibility(
            visible: cameraViewController.isMultiTakePhoto.value && cameraViewController.listImageMulti.isNotEmpty,
            child: IconButtonComponent(icon: const Icon(Icons.check,size: 30,color: AppColor.whiteColor,), onPress: (){
              cameraViewController.onPressSaveResult();
            })
          )),
        ],
      ),
    );
  }

  Widget _buildFooterCamera(){
    return Container(
      color: AppColor.grey,
      height: bottomPadding+80,
      padding: EdgeInsets.only(top: 5,bottom: bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: (cameraViewController.cameraFlag.value)?[
          _buildBoxButton(IconButtonComponent(icon: const Icon(Icons.clear_outlined,size: 28,color: AppColor.whiteColor,), onPress: (){
            if (cameraViewController.isMultiTakePhoto.value) {
              Get.back(result: List<File?>.empty(growable: true));
            } else {
              Get.back();
            }
          })),
          IconButtonComponent(
            icon: const Icon(Icons.camera_outlined,size: 60,color: AppColor.whiteColor,), 
            onPress: (){
              cameraViewController.takePicture();
            }
          ),
          _buildBoxButton(IconButtonComponent(icon: const Icon(Icons.flip_camera_ios_outlined,size: 26,color: AppColor.whiteColor,), onPress: (){ cameraViewController.swichCamera();}))
          
        ]:[
          _buildBoxButton(IconButtonComponent(icon: const Icon(Icons.clear_outlined,size: 26,color: AppColor.whiteColor,), onPress: (){
              cameraViewController.imageCancel();
          })),
          Obx(() => _buildBoxButton(IconButtonComponent(icon: const Icon(Icons.done_outlined,size: 26,color: AppColor.whiteColor,),isLoading:cameraViewController.flagHandleResult.value, onPress: (){
              cameraViewController.onPressSaveResult();
          })),)
        ],
      ),
    );
  }

  Widget _buildBoxButton(Widget child){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.whiteColor.withOpacity(0.4),
        //borderRadius: BorderRadius.all(Radius.circular(40))
      ),
      child: Center(child: child),
    );
  }
  
}