import 'package:erp/src/screens/profile/pages/statusVerify/elements/itemStatusVerify.element.dart';
import 'package:erp/src/screens/profile/pages/statusVerify/statusVerify.controller.dart';
import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
class StatusVerifyScreen extends GetWidget<StatusVerifyController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarComponent(
        borderRadius: BorderRadius.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
              onPressed: () async{
                Get.back();
              }
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("Xác minh",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor))
              ),
            ),
            const SizedBox(width: 40,),
          ],
        ),
      ),
      body: Obx(()=>GridView.builder(
        itemCount: controller.datas.length,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20
        ),
        itemBuilder: (context, index){
          var item = controller.datas[index];
          return ItemStatusVerifyElement(item: item,onPress: controller.onSelectedStatusItem,);
        },
      ),)
    );
  }
}