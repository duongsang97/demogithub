import 'package:erp/src/screens/profile/pages/identify/pages/verifiability/elements/itemStatusVerify.element.dart';
import 'package:erp/src/screens/profile/pages/identify/pages/verifiability/statusVerify.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
class StatusVerifyScreen extends GetWidget<StatusVerifyController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return ItemStatusVerifyElement(item: item,onPress: (item, value) {
            controller.onSelectedStatusItem(item, value);
          });
        },
      ),)
    );
  }
}