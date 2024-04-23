import 'dart:ui';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/components/textInputs/textInputLogin.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/components/alerts/elements/itemSocial.element.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erpcore/routers/app.Router.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/localStorage/permission.dbLocal.dart';
import 'package:erpcore/utility/permission.utils.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../../../datas/appData.dart';

class SignInAlert extends StatefulWidget {
  const SignInAlert({super.key});

  @override
  State<SignInAlert> createState() => _SignInAlertState();
}

class _SignInAlertState extends State<SignInAlert> {
  Rx<bool> isLoading = false.obs;
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController passWordTextController = TextEditingController();
  AuthenProvider authenProvider = AuthenProvider();
  late AppController appController;
  final LocalAuthentication auth = LocalAuthentication();
  RxList<BiometricType> biometricList = RxList<BiometricType>.empty(growable: true);
  late PermissionDBLocal permissionDBLocal;
  late Size size;

  Future<void> checkLocalAuthen() async{
    biometricList.clear();
    var result = await auth.getAvailableBiometrics();
    if(result.isNotEmpty && result.indexWhere((element) => element == BiometricType.fingerprint || element == BiometricType.strong) >=0){
      biometricList.add(BiometricType.fingerprint);
      await PreferenceUtility.saveBool(AppKey.keyFingerprintStatus,true);
    }
    biometricList.add(BiometricType.face);
  }

  bool validateInputData() {
    if (userNameTextController.text == "") {
      AlertControl.push("Tài khoản không được bỏ trống", type: AlertType.ERROR);
      return false;
    }
    if (passWordTextController.text == "") {
      AlertControl.push("Mật khẩu không được bỏ trống", type: AlertType.ERROR);
      return false;
    }
    return true;
  }
  Future<void> loginOnpress() async {
    if (validateInputData()) {
      isLoading.value = true;
      await PermisstionUtils.encryptLoginInfo(userNameTextController.text, passWordTextController.text);
      var result = await authenProvider.doLogin(username: userNameTextController.text,password: passWordTextController.text);
      if (result.statusCode == 0) {
        var resultUser = await authenProvider.getUserPermission();
        isLoading.value = false;
        if (resultUser.statusCode == 0) {
          appController.isAuthentication.value = true;
          appController.userProfle.value = resultUser.data;
          appController.loginAlertNavigation();
        } else {
          AlertControl.push(result.msg??"", type: AlertType.ERROR);
        }
      } else {
        isLoading.value = false;
        AlertControl.push(result.msg??"", type: AlertType.ERROR);
      }
    }
  }

  String getImageAuthenLocalByType(BiometricType type){
    String result = "assets/images/icons/fingerprint.png";
    if(type == BiometricType.face){
      result= "assets/images/icons/face-recognition.png";
    }
    return result;
  }

  Future<void> onPressLoginWithFaceId() async{
    LoadingComponent.show();
    var result = await authenProvider.registerWithFingerprintID();
    LoadingComponent.dismiss();
  }

  Future<void> onPressLoginWithFingerprint(BiometricType type) async{
    try{
      String fingerprintID = PreferenceUtility.getString(AppKey.keybiometricstoken);
      if(fingerprintID.isNotEmpty){
        bool authenticated = await auth.authenticate(
        localizedReason: 'Vui lòng xác thực để tiếp tục',
          options: const AuthenticationOptions(
            biometricOnly: false,
          ),
        );
        if(authenticated){
          passWordTextController.text = "123456";
          Future.delayed(const Duration(milliseconds: 300));
          isLoading.value = true;
          var result = await authenProvider.doLogin(fingerprintToken: fingerprintID);
          isLoading.value = false;
            if (result.statusCode == 0) {
            var resultUser = await authenProvider.getUserPermission();
            isLoading.value = false;
            if (resultUser.statusCode == 0) {
              appController.isAuthentication.value = true;
              appController.userProfle.value = resultUser.data;
              appController.loginAlertNavigation();
            } else {
              AlertControl.push(result.msg??"", type: AlertType.ERROR);
            }
          } else {
            isLoading.value = false;
            AlertControl.push(result.msg??"", type: AlertType.ERROR);
          }
        }
        else{
          AlertControl.push("Không thể xác minh danh tính!", type: AlertType.ERROR);
        }
      }
      else{
        AlertControl.push("Vân tay chưa được đăng ký với hệ thống", type: AlertType.ERROR);
      }
    }on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        AlertControl.push("Sinh trắc học không khả dụng trên thiết bị của bạn!", type: AlertType.ERROR);
      } else if (e.code == auth_error.notEnrolled) {
        AlertControl.push("Sinh trắc học chưa được đăng ký trên thiết bị của bạn!", type: AlertType.ERROR);
      }
      else {
        AlertControl.push("Có lỗi xảy ra, vui lòng thử lại!", type: AlertType.ERROR);
      }
    }
  }

  @override
  void initState() {
    appController = Get.find();
    permissionDBLocal = PermissionDBLocal();
    checkLocalAuthen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
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
                _buildBody(),
                Obx(()=>Visibility(
                  visible: biometricList.isNotEmpty,
                  child: _buildFooter()
                  )
                )
              ],
            ),
          ),
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
          SizedBox(height: size.width*.05,),
          TextInputLoginComponent(
            hintText: "Tên đăng nhập",
            icon: const Icon(Icons.alternate_email_outlined),
            txtController: userNameTextController,
          ),
          const SizedBox(height: 30,),
          TextInputLoginComponent(
            hintText: "Mật khẩu",
            isPassword: true,
            icon: const Icon(Icons.lock,),
            txtController: passWordTextController,
          ),
          SizedBox(height: size.width*.15,),
          Obx(()=>ButtonDefaultComponent(
            width: size.width*.6,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            titleStyle: const TextStyle(color: AppColor.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),
            title: "Đăng nhập",
            isLoading: isLoading.value,
            onPress: loginOnpress,
          ))
        ],
      ),
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
            children: biometricList.map((element) => _buildSocialItem(element)).toList(),
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
            ItemSocialElement (type: SocialType.ACCOUNT,),
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
          onPressLoginWithFaceId();
        }
        else{
          onPressLoginWithFingerprint(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(width: 0.5,color: AppColor.darkGreyMonth),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))
        ),
        child: Image.asset(getImageAuthenLocalByType(item),width: 30,height: 30,),
      ),
    );
  }
}