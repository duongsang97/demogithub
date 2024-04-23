import 'package:erp/src/screens/profile/elements/changePassword/changePassword.Controller.dart';
import 'package:erpcore/components/buttons/buttonLogin.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';

class ChangePasswordScreen extends GetWidget<ChangePasswordController>{
  final ChangePasswordController changePasswordController = Get.find();
  @override
  Widget build(BuildContext context) {
    changePasswordController.context = context;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBarComponent(
        borderRadius: BorderRadius.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
              onPressed: () async{
                Get.back();
              }
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("Đổi mật khẩu",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor))
              ),
            ),
            SizedBox(width: 40,),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() => TextInputComponent(
                  controller: changePasswordController.txtOldPassword,
                  icon: GestureDetector(
                    onTap: () {
                      controller.onChangeStatusHidePassword(0);
                    },
                    child: Icon(!controller.isHideOldPassword.value ? Icons.visibility : Icons.visibility_off,)
                  ),
                  title: "Mật khẩu cũ",
                  isPassword: !controller.isHideOldPassword.value,
                  placeholder:"Nhập mật khẩu hiện tại"
                )) 
              ),
              SizedBox(height: 5,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child:Obx(() => TextInputComponent(
                  controller: changePasswordController.txtNewPassword,
                  icon: GestureDetector(
                    onTap:() {
                      controller.onChangeStatusHidePassword(1);
                    },
                    child: Icon(!controller.isHideNewPassword.value ? Icons.visibility : Icons.visibility_off,)
                  ),
                  isPassword: !controller.isHideNewPassword.value,
                  title: "Mật khẩu mới",
                  placeholder:"Nhập mật khẩu mới"
                )) 
              ),
              SizedBox(height: 5,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child:Obx(() => TextInputComponent(
                  controller: changePasswordController.txtConfirmNewPassword,
                  icon: GestureDetector(
                    onTap: (){
                      controller.onChangeStatusHidePassword(2);
                    },
                    child: Icon(!controller.isHideConfirmNewPassword.value ? Icons.visibility : Icons.visibility_off,)
                  ),
                  isPassword: !controller.isHideConfirmNewPassword.value,
                  title: "Nhập lại mật khẩu mới",
                  placeholder:"Nhập lại mật khẩu mới"
                ))
              ),
              ButtonLoginComponent(
                onPressed: ()=>changePasswordController.onChangePassword(),
                btnLabel: "Xác nhận",
              )
            ],
          ),
        ),
      ),
    );
  }
}
