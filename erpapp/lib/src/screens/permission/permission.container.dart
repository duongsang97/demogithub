import 'package:erpcore/utility/permission.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'elements/permissionRequest.element.dart';
import 'permission.controller.dart';
class PermissionScreen extends GetWidget<PermissionController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{
          controller.permission.value = await PermisstionUtils.checkDevicePermissionAllow(controller.permission);
        },
        child: Obx(() => PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: (int page){
            controller.pageIndex = page;
          },
          children: controller.permission.map((element) => PermissionRequestElement(item: element,onAccept: controller.requestPermission,isLoading: controller.isLoading.value,)).toList(),
        ),)
      )
    );
  }
  
}