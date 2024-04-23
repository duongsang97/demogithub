import 'package:erp/src/screens/auth/signIn/pages/verification.Controller.dart';
import 'package:erpcore/components/appbars/appBarTab.component.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class VerificationScreen extends GetWidget<VerificationController>{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBarTabComponent(
        height: 100,
        title: const Text("Xác thực 2 bước",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.whiteColor)),
      ),
      body: Container(
        width: size.width,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/icons/security.png", width: 80, height: 80, fit: BoxFit.cover),
            SizedBox(height: 15.0,),
            const Text("Nhập mã xác thực Google Authenticator để đăng nhập", style: TextStyle(color: AppColor.nearlyBlack, fontSize: 13), textAlign: TextAlign.center),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              width: size.width * .5,
              child: Row(
                children: [
                  Expanded(
                    child: TextInputComponent(
                      heightBox: 40,
                      title: "Mã xác thực", 
                      controller: controller.verifyController,
                    ),
                  ),
                ],
              ),
            ),
            ButtonDefaultComponent(title: "Xác thực", onPress: () {
              controller.onVerifyAuthCode();
            }, width: 100)
          ],
        ),
    ));
  }

}