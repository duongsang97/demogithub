import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/components/selectBox/selectBoxVersatile.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erp/src/screens/profile/pages/profileDetail/profileDetail.Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:erpcore/utility/image.Utility.dart';

class ProfileDetailScreen extends GetWidget<ProfileDetailController>{
  final ProfileDetailController profileDetailController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarComponent(
        borderRadius: BorderRadius.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 5,),
            IconButton(icon: const Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
              onPressed: () async{
                Get.back();
              }
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("Thông tin nhân viên",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor))
              ),
            ),
            const SizedBox(width: 20,),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: Obx(()=>_buildHeader(),)
            ),
            // Visibility(
            //   //visible: profileDetailController.userProfile.value.verified==false,
            //   child: Padding(
            //     padding: EdgeInsets.only(top: 20),
            //     child: ButtonDefaultComponent(
            //       backgroundColor: AppColor.orangeColor,
            //       borderRadius: BorderRadius.all(Radius.circular(20)),
            //       title: "Xác minh tài khoản",
            //       onPress: () 
            //     ),
            //   )
            // ),
            const SizedBox(height: 30,),
            Obx(() => _buildBody())
          ], 
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return GestureDetector(
      onTap: ()async{
        await Get.toNamed(AppRouter.verifyDashboard);
        profileDetailController.fetchEmpProfile();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: (){
                  controller.onPressAvatar();
                },
                child: CachedNetworkImage(
                  imageUrl: ImageUtils.getURLImage(profileDetailController.userProfile.value.avatarImage),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColor.azureColor,
                      backgroundImage: imageProvider 
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColor.azureColor,
                      backgroundImage: AssetImage("assets/images/icons/default_avatar.png") 
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColor.azureColor,
                      backgroundImage: AssetImage("assets/images/icons/default_avatar.png") 
                    ),
                ),
              ),
              Obx(() => Positioned(
                  bottom: 0,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: profileDetailController.userProfile.value.verified==true?AppColor.greenMonth:AppColor.brightRed,
                      shape: BoxShape.circle
                    ),
                    child: Icon(profileDetailController.userProfile.value.verified==true?Icons.task_alt_outlined:Icons.highlight_off_outlined,size: 20,color: AppColor.whiteColor,),
                  )//Image.asset("assets/images/icons/acount-verify.png",width: 15,height: 15,)
                ))
            ],
          ),
          const SizedBox(height: 10,),
          Text(profileDetailController.userProfile.value.displayName??"",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppConfig.appColor),)
        ],
      ),
    );
  }

  Widget _buildBody(){
    return Column(
      children: [
        TextInputComponent(
          icon: const Icon(Icons.card_membership),
          title: 'Họ & tên',
          txtInputAction: TextInputAction.done,
          controller: profileDetailController.txtFullNameController
        ),
        TextInputComponent(
          title: 'Sinh nhật',
          icon: const Icon(Icons.calendar_today),
          txtInputAction: TextInputAction.done,
          controller: profileDetailController.txtbirthdayController
        ),
        TextInputComponent(
          icon: const Icon(Icons.phone_android),
          title: 'Sdt',
          txtInputAction: TextInputAction.done,
          controller: profileDetailController.txtPhoneController
        ),
        TextInputComponent(
          icon: const Icon(Icons.email),
          title: 'Email',
          txtInputAction: TextInputAction.done,
          controller: profileDetailController.txtEmailController
        ),
        Row(
          children: [
            Expanded(
              child: SelectBoxVersatileComponent(
                displayType: true,
                label: "Quốc gia",
                selectedItem: profileDetailController.userProfile.value.country,
                listData: const [],
              )
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: SelectBoxVersatileComponent(
                displayType: true,
                label: "Tỉnh/TP",
                selectedItem: profileDetailController.userProfile.value.city,
                listData: const [],
              )
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: SelectBoxVersatileComponent(
                displayType: true,
                label: "Quận/huyện",
                selectedItem: profileDetailController.userProfile.value.district,
                listData: const [],
              )
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: SelectBoxVersatileComponent(
                displayType: true,
                label: "Phường xã",
                selectedItem: profileDetailController.userProfile.value.ward,
                listData: const [],
              )
            ),
          ],
        ),
        const SizedBox(height: 5,),
        TextInputComponent(
          title: 'Địa chỉ',
          txtInputAction: TextInputAction.done,
          controller: profileDetailController.txtAddressController
        ),
      ],
    );
  }
  
}