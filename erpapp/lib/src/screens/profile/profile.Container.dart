import 'package:erp/src/screens/profile/pages/devMode/devMode.container.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/boxs/boxERPTitleContent.Component.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erp/src/screens/profile/profile.Controller.dart';
import 'package:erpcore/utility/localStorage/permission.dbLocal.dart';
import 'package:erpcore/utility/permission.utils.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'elements/itemProfileFunc.Element.dart';

class ProfileScreen extends GetWidget<ProfileController>{
  final ProfileController profileController = Get.find();
  final AppController appController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: profileController.controller,
      child: Column(
        children: [
          const SizedBox(height: 20,),
          BoxERPTitleContentComponent(
            title: "Hồ sơ",
            isExtend: false,
            callback: (){
            },
            child: Column(
              children: [
                const SizedBox(height: 10,),
                ItemProfileFuncElement(
                  label: "Hồ sơ nhân viên",
                  callback: () async{
                    await Get.toNamed(AppRouter.profileDetail);
                    controller.isDevMode.value = PreferenceUtility.getBool(AppKey.keyDevMode);
                  },
                ),
                    ItemProfileFuncElement(
                      label: "Phiếu lương",
                      callback: (){
                        Get.toNamed(AppRouter.payslipHome);
                      },
                    ),
                    ItemProfileFuncElement(
                      label: "Chữ ký số",
                      callback: (){
                        Get.toNamed(AppRouter.esignatureSign);
                      },
                    ),
                    ItemProfileFuncElement(
                      label: "Danh sách tài sản",
                      callback: (){
                        Get.toNamed(AppRouter.assetHome);
                      },
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),
              BoxERPTitleContentComponent(
                title: "Cấu hình",
                isExtend: false,
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    const ItemProfileFuncElement(
                      label: "Cài đặt",
                    ),
                    ItemProfileFuncElement(
                      callback: (){
                        Get.toNamed(AppRouter.identification);
                      },
                      label: "Định danh điện tử",
                    ),
                    ItemProfileFuncElement(
                      callback: (){
                        Get.toNamed(AppRouter.helper);
                      },
                      label: "Báo cáo sự cố",
                    ),
                  ],
                ),
                callback: (){
                  
                },
              ),
              BoxERPTitleContentComponent(
                title: "Hệ thống",
                isExtend: false,
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    ItemProfileFuncElement(
                      label: "Thông tin hệ thống",
                      callback: (){
                        Get.toNamed(AppRouter.systemInfo);
                      },
                    ),
                    ItemProfileFuncElement(
                      label: "Đổi mật khẩu",
                      callback: (){
                        Get.toNamed(AppRouter.actChangePassword);
                      },
                    ),
                    ItemProfileFuncElement(
                      label: "Yêu cầu xoá tài khoản",
                      labelStyle: const TextStyle(color: AppColor.brightRed),
                      callback: () async{
                        if(!controller.isLoading.value){
                          await controller.requestDeleteAccount();
                        }
                      },
                    ),
                    Obx(() => Visibility(
                      visible: controller.isDevMode.value,
                      child: ItemProfileFuncElement(
                      label: "Chế độ nhà phát triển",
                      labelStyle: const TextStyle(color: AppColor.brightRed,fontWeight: FontWeight.bold),
                      callback: () async{
                        ModalSheetComponent.showBarModalBottomSheet(
                          const DevModeScreen(),
                          formSize: 0.6,
                          expand: true,
                          title: "Chế độ nhà phát triển"
                        ).whenComplete((){
                          controller.isDevMode.value = PreferenceUtility.getBool(AppKey.keyDevMode);
                        });
                      },
                    ),
                    ))
                  ],
                ),
                callback: (){
                  
                },
              ),
              const SizedBox(height: 10,),
              TextButton(
                onPressed: () async{
                  var resultQuesion = await Alert.showDialogConfirm("Thông báo","Bạn chắc chắn muốn thoát khỏi ứng dụng?");
                  if(resultQuesion){
                    appController.logout();
                  }
                }, 
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Đăng xuất",style: TextStyle(
                      color: AppColor.brightRed,fontSize: 15
                    ),),
                    SizedBox(width: 10,),
                    Icon(Icons.logout,color: Colors.red,)
                  ],
                )
              )
            ],
          ),
        );
  }

   Widget _buildItemAction(String icon,VoidCallback callback){
    return GestureDetector(
      onTap: ()=> callback(),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
              BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]
        ),
        child: Center(
          child: Image.asset(icon,height: 20,width: 20,),
        ),
      ),
    );
  }

  Widget _buildAvatar(){
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColor.azureColor,
          backgroundImage: AssetImage("assets/images/icons/default_avatar.png"),//NetworkImage("https://tiemanhsky.com/wp-content/uploads/2020/03/61103071_2361422507447925_6222318223514140672_n_1.jpg"),
        ),
      ],
    );
  }
}