import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/textInputs/textInputLogin.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'register.controller.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
class RegisterScreen extends GetWidget<RegisterController>{
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
          bottom: MediaQuery.paddingOf(context).bottom
        ),
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/images/background/register_background.png"),
          //   fit: BoxFit.cover
          // )
          color: AppColor.whiteColor
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              _buildHeader(),
              SizedBox(height: 20,),
              _buildBody(),
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
        child: SvgPicture.asset("assets/illustrations/signup.svg",width: size.height * .35),
      ),
    );
  }
  Widget _buildBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Register",textAlign: TextAlign.left,style: TextStyle(
              color: AppColor.darkText,fontSize: 25,fontWeight: FontWeight.bold
            )),
          ),
          SizedBox(height: size.width*.1,),
          TextInputLoginComponent(
            hintText: "Tên đăng nhập",
            icon: Icon(Icons.alternate_email_outlined),
            txtController: controller.txtUsernameController,
          ),
          SizedBox(height: 10,),
          TextInputLoginComponent(
            hintText: "Mật khẩu",
            isPassword: true,
            icon: Icon(Icons.lock,),
            txtController: controller.txtPasswordController,
          ),
          SizedBox(height: 10,),
          TextInputLoginComponent(
            hintText: "Nhập lại mật khẩu",
            isPassword: true,
            icon: Icon(Icons.lock,),
            txtController: controller.txtPasswordController,
          ),
          SizedBox(height: 10,),
          TextInputLoginComponent(
            hintText: "Họ và tên",
            icon: Icon(Icons.person,),
            txtController: controller.txtPasswordController,
          ),
          SizedBox(height: 10,),
          TextInputLoginComponent(
            hintText: "Email",
            icon: Icon(Icons.email,),
            txtController: controller.txtPasswordController,
          ),
          SizedBox(height: 10,),
          TextInputLoginComponent(
            hintText: "Số điện thoại",
            icon: Icon(Icons.phone,),
            txtController: controller.txtPasswordController,
          ),
          SizedBox(height: size.width*.15,),
          Obx(()=>ButtonDefaultComponent(
            width: size.width*.6,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            titleStyle: TextStyle(color: AppColor.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),
            title: "Đăng ký",
            isLoading: controller.isLoading.value,
            onPress: controller.onPress,
          ))
        ],
      ),
    );
  }
}