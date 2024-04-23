import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
class RegisterController extends GetxController{
  RxBool isLoading = false.obs;
  
  TextEditingController txtUsernameController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  TextEditingController txtPasswordRetypeController = TextEditingController();
  TextEditingController txtFullnameController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPhoneNumberController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> onPress() async{
    try{

    }
    catch(ex){
      
    }
  }
}