import 'dart:ui';

import 'package:erp/src/routers/app.Router.dart';
import 'package:erp/src/screens/auth/elements/itemSocial.element.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/checkBox/checkBox.Component.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/components/textInputs/textInputLogin.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'signIn.Controller.dart';

class SignInScreen extends GetWidget<SignInController>{
  late Size size;
  final SignInController signInController = Get.find();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
          bottom: MediaQuery.paddingOf(context).bottom
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => _buildHeader()),
              _buildBody(),
              Obx(()=>Visibility(
                visible: signInController.biometricList.isNotEmpty,
                child: _buildFooter()
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Container(
      width: size.width,
      color: AppColor.whiteColor,
      child: Align(
        alignment: Alignment.center,
        child: controller.appLogo,
      ),
    );
  }
  Widget _buildBody(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Đăng nhập",textAlign: TextAlign.left,style: TextStyle(
              color: AppColor.darkText,fontSize: 25,fontWeight: FontWeight.bold
            )),
          ),
          SizedBox(height: size.width*.1,),
          TextInputLoginComponent(
            hintText: "Tên đăng nhập",
            icon: const Icon(Icons.alternate_email_outlined),
            txtController: signInController.userNameTextController,
          ),
          const SizedBox(height: 30,),
          TextInputLoginComponent(
            hintText: "Mật khẩu",
            isPassword: true,
            icon: const Icon(Icons.lock,),
            txtController: signInController.passWordTextController,
          ),
          const SizedBox(height: 10,),
          Obx(() => Padding(
            padding: const EdgeInsets.only(bottom: 10,top: 10,left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CheckBoxComponent(
                item: controller.rememberMe.value,
                callback: () => controller.onChangeRememberMe,
              ),
            )
          )),
          Obx(() => Visibility(
            visible: controller.wrongLogin.value>1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    ModalSheetComponent.showBarModalBottomSheet(
                      buildBoxContainerRecovery(),
                      formSize: 0.6,
                      title: "Khôi phục mật khẩu",
                      expand: true,
                      onCancel: (){
                        controller.userNameTextController.clear();
                        controller.emailTextController.clear();
                        controller.passWordTextController.clear();
                        controller.rePassWordTextController.clear();
                        controller.codeTextController.clear();
                        controller.stepRecovery.value = 0;
                        controller.recoveryPass.value = ResponsesModel.create();
                        Get.back();
                      }
                    );
                  }, 
                  child: const Text("Quên mật khẩu",style: TextStyle(color: AppColor.bluePen),)
                ),
              ),
            ),
          )),
          SizedBox(height: size.width*.05,),
          Obx(()=>ButtonDefaultComponent(
            width: size.width*.6,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            titleStyle:  const TextStyle(color: AppColor.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),
            title: "Đăng nhập",
            isLoading: signInController.isLoading.value,
            onPress: signInController.loginOnpress,
          ))
        ],
      ),
    );
  }
  Widget buildBoxContainerRecovery(){
    return Obx(() => controller.stepRecovery.value == 0?buildBoxUpdatePassword():buildBoxSetPassword());
  }
  Widget buildBoxSetPassword(){
    return Column(
      children: [
        const SizedBox(height: 20,),
         Padding(
          padding:const EdgeInsets.only(left: 15,right: 5),
          child: Text("Vui lòng nhập mã xác minh trong Email: ${controller.emailTextController.text} và Mật khẩu mới cần thay đổi."),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextInputComponent(
            title: "Mã xác minh",
            placeholder: "Mã xác minh gửi trong email",
            controller: controller.codeTextController,
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextInputComponent(
            title: "Mật khẩu mới",
            controller: controller.passWordTextController,
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextInputComponent(
            title: "Nhập lại mật khẩu mới",
            controller: controller.rePassWordTextController,
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ButtonDefaultComponent(
            isLoading: controller.isLoading.value,
            title: "Xác nhận", 
            onPress: () async{
              controller.passwordSet();
            }
          )
        ),
      ],
    );
  }
  Widget buildBoxUpdatePassword(){
    return Column( 
      children: [
        const SizedBox(height: 20,),
        const Padding(
          padding: EdgeInsets.only(left: 15,right: 5),
          child: Text("Nhập Username và địa chỉ Email liên kết với Username cần khôi phục mật khẩu."),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextInputComponent(
            title: "Username",
            controller: controller.userNameTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextInputComponent(
            title: "Email",
            controller: controller.emailTextController,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ButtonDefaultComponent(
            isLoading: controller.isLoading.value,
            title: "Xác nhận", 
            onPress: () async{
              controller.passwordRecovery();
            }
          )
        ),
        Obx(() => Visibility(
          visible: (controller.recoveryPass.value.msg??"").isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 10),
            child: Text(( controller.recoveryPass.value.msg??""),style: TextStyle(
            color: (controller.recoveryPass.value.statusCode) ==0?AppColor.laSalleGreen:AppColor.brightRed,fontSize: 13
            ),),
          )
        )
        )
      ],
    );
  }
  Widget _buildFooter(){
    return Container(
      margin: const EdgeInsets.only(top: 10,bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text("hoặc với",style: TextStyle(color: AppColor.darkGreyMonth,fontSize: 14),),
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: signInController.biometricList.map((element) => _buildSocialItem(element)).toList(),
          ),
          // SizedBox(height: 20,),
          // registerBox(),
        //  Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20),
        //     child: Align(
        //       child: _buildBoxSocial(),
        //     )
        //   )
        ],
      ),
    );
  }

  Widget registerBox(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Chưa có tài khoản?",style: TextStyle(fontSize: 13)),
        const SizedBox(width: 5,),
        GestureDetector(
          onTap: (){
            Get.toNamed(AppRouter.signUp);
          },
          child: const Text("Đăng ký mới",style: TextStyle(color: AppColor.brightBlue,fontSize: 13),),
        )
      ],
    );
  }

  Widget _buildBoxSocial(){
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ItemSocialElement(type: SocialType.ACCOUNT,),
            SizedBox(width: 20,),
            ItemSocialElement(type: SocialType.PHONE,)
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ItemSocialElement(type: SocialType.GOOGLE,),
            ItemSocialElement(type: SocialType.FACEBOOK,),
            ItemSocialElement(type: SocialType.APPPLE,),
            ItemSocialElement(type: SocialType.ZALO,),
            ItemSocialElement(type: SocialType.LINKEDIN,)
          ],
        )
      ],
    );
  }

  Widget _buildSocialItem(BiometricType item){
    return GestureDetector(
      onTap: (){
        if(item == BiometricType.face){
          signInController.onPressLoginWithFaceId();
        }
        else{
          signInController.onPressLoginWithFingerprint(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(width: 0.5,color: AppColor.darkGreyMonth),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))
        ),
        child: Image.asset(signInController.getImageAuthenLocalByType(item),width: 30,height: 30,),
      ),
    );
  }
}