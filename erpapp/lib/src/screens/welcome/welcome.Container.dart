import 'dart:io';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erp/src/screens/welcome/welcome.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends GetWidget<WelcomeController>{
  final WelcomeController welcomeController = Get.find();
  final AppController appController = Get.find();
  @override
  Widget build(BuildContext context) {
    welcomeController.context = context;

    Size size = MediaQuery.sizeOf(context);
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(()=>Stack(
          children: [
            Container(
             width: double.infinity,
             decoration: BoxDecoration(
              color: welcomeController.colorWelcome.isNotEmpty?HexColor.fromHex(welcomeController.colorWelcome.value):AppConfig.appColor,
            ),
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: welcomeController.logoWelcome.isNotEmpty
                    ?Image.file(
                      File(welcomeController.logoWelcome.value),
                      width: size.width*0.8, height:size.width*0.5,
                      errorBuilder: (context, exception, stackTrace) {
                          return const SizedBox();
                      },
                    )
                    :const SizedBox(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoadingStatus(),
                    Obx(()=>Text("version: ${welcomeController.packageInfo.value.version}",style: TextStyle(fontSize: 14,color: controller.colorByPackage,),)),
                    SizedBox(height: bottomPadding,)
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              right: 0,
              bottom: 0,
              child: controller.subLogoByPackage??const SizedBox()
            ),
          ],
        )),
      ),
    );
  }
  Widget _buildLoadingStatus(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(color: controller.colorByPackage,),
        ),
        const SizedBox(height: 10,),
        Obx(()=> Text(welcomeController.msgProcess.value,style: TextStyle(fontSize: 15,color: controller.colorByPackage,),textAlign: TextAlign.center,))
      ],
    );
  }
}


