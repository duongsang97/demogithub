import 'package:erpcore/controllers/scanner/elements/scannerOverlay.element.dart';
import 'package:erpcore/controllers/scanner/model/scannerOutput.model.dart';
import 'package:erpcore/controllers/scanner/scanner.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../configs/appStyle.Config.dart';
import 'elements/scannerError.element.dart';
class ScannerScreen extends GetWidget<ScannerController>{
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Size size;
  double scanArea = 0.0;
  EdgeInsets padding = EdgeInsets.zero;
  @override
  Widget build(BuildContext context) {
    padding = MediaQuery.paddingOf(context);
    scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)? 200.0: 330.0;
    size = MediaQuery.sizeOf(context);
    return PopScope(
      onPopInvoked:(bool v){
        if(Get.isRegistered<ScannerController>()){
          Get.delete<ScannerController>();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildQrView(context),
            Positioned(
              bottom: controller.config.isMultiple==false?padding.top+50:null,
              top: controller.config.isMultiple==true?size.height*.1:null,
              child: _buildBoxAction()
            ),
            Positioned(
              top: (size.height / 2)+(scanArea/2)+50,
              child: _buildBoxResult()
            ),
          ],
        )
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return MobileScanner(
      key: qrKey,
      controller: controller.cameraController,
      errorBuilder: (context, error, child) {
        return ScannerErrorWidget(error: error);
      },
      onDetect: controller.onDetect,
      overlay: ScannerOverlayElement(overlayColour: AppColor.grey.withOpacity(0.8)),
      scanWindow: Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: scanArea, height: scanArea)
    );
  }

  Widget _buildBoxAction(){
    Widget child = Container();
    if(controller.config.isMultiple == true){
      child = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    controller.onPressFlash();
                  },
                  child: Obx(()=>Icon(controller.flashFlag.value?Icons.flash_off:Icons.flash_on,color: Colors.white,size: 40,)),
                ),
                GestureDetector(
                  onTap: (){
                    controller.onPressSwitch();
                  },
                  child: const Icon(Icons.switch_camera,color: Colors.white,size: 40,),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            const Text("Đưa vào khung để quét mã",style: TextStyle(
              color: Colors.white,fontSize: 16
            ),),
          ],
        ),
      ); 
    }
    else{
      child = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Đưa vào khung để quét mã",style: TextStyle(
              color: Colors.white,fontSize: 16
            ),),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    controller.onPressFlash();
                  },
                  child: Obx(()=>Icon(controller.flashFlag.value?Icons.flash_off:Icons.flash_on,color: Colors.white,size: 40,)),
                ),
                GestureDetector(
                  onTap: (){
                    controller.onPressSwitch();
                  },
                  child: const Icon(Icons.switch_camera,color: Colors.white,size: 40,),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                controller.onCloseScanner();
              },
              child: const Text("Đóng",style: TextStyle(color: AppColor.azureColor,fontSize: 18,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      );
    }
    return child;
  }

  Widget get buildOverViewResultList{
    int resultValidate = 0;
    int resultIllegal = 0;
    for(var item in controller.totalResult){
      if(item.isValid){
        resultValidate++;
      }
      else{
        resultIllegal++;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),
        child: Text("($resultValidate hợp lệ)",maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 12,color: AppColor.greenMonth,fontWeight: FontWeight.bold),),
      )
    );
  }

  Widget buildStatusResult(ScannerOutputModel value){
    Widget child = const SizedBox();
    if(value.isChecking){
      child= LoadingAnimationWidget.fallingDot(color: Colors.white,size: 30,);
    }
    else if(value.isWait){
      child= Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: const Text("Chờ xác minh",style: TextStyle(color: AppColor.bluePen,fontSize: 12),),
      );
    }
    else if(value.isValid){
      child= Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: const Text("Hợp lệ",style: TextStyle(color: AppColor.greenMonth,fontSize: 12),),
      );
    }
    else{
      child= Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: const Text("Không hợp lệ",style: TextStyle(color: AppColor.brightRed,fontSize: 12,decoration: TextDecoration.underline),)
      );
    }
    return GestureDetector(
      onTap: (){

      },
      child: child,
    );
  }

  Widget _buildBoxResult(){
    double maxSize = size.height - ((size.height / 2)+(scanArea/2))-60;
    return Visibility(
      visible: controller.config.isMultiple ==true,
      child: Obx(() => Container(
        height: maxSize,
        width: size.width,
        padding: EdgeInsets.only(bottom: padding.bottom),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("STT",style: TextStyle(color: AppColor.whiteColor,fontSize: 12,fontWeight: FontWeight.bold),),
                  const SizedBox(width: 20),
                  Expanded(child: Row(
                    children: [
                      const Text("Dữ liệu",style: TextStyle(color: AppColor.whiteColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      buildOverViewResultList
                    ],
                  )),
                  const Text("Trạng thái",style: TextStyle(color: AppColor.whiteColor,fontSize: 12,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Expanded(
              child: (controller.totalResult.isNotEmpty)?Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  shrinkWrap: true,
                  itemCount: controller.totalResult.length,
                  itemBuilder: (context,index){
                    var item = controller.totalResult[index];
                    return Slidable(
                      enabled: controller.config.removeItem==true,
                      endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context)async{
                            controller.removeScanItem(item.code??"");
                          },
                          backgroundColor: AppColor.brightRed,
                          foregroundColor: AppColor.whiteColor,
                          label: "Xoá",
                          ),
                        ]
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        color: item.hightLightColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${index+1},",style: const TextStyle(color: AppColor.whiteColor,fontSize: 12),),
                            const SizedBox(width: 20),
                            Expanded(child: Text(item.data??'result error',style: const TextStyle(color: AppColor.whiteColor,fontSize: 12,),)),
                            buildStatusResult(item)
                            //Text(item.createdAt!= null?DateFormat('yyyy-MM-dd hh:mm:ss').format(item.createdAt!):'n/a',style: const TextStyle(color: AppColor.whiteColor,fontSize: 12),),
                          ],
                        ),
                      )
                    );
                  }
                )
              ):SizedBox(
                width: size.width,
                child: const Center(child: Text("Không có dữ liệu",style: TextStyle(color: AppColor.whiteColor,fontSize: 12),),),
              )
            ),
            GestureDetector(
              onTap: (){
                controller.onCloseScanner();
              },
              child: Obx(()=>Text(controller.config.isMultiple == true && controller.totalResult.isNotEmpty?"Xác nhận":"Đóng",style: const TextStyle(color: AppColor.azureColor,fontSize: 18,fontWeight: FontWeight.bold),)),
            ),
          ],
        ),
      ))
    );
  }

}

