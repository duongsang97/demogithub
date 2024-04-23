import 'package:erp/src/screens/systemInfo/elements/appInfo.Element.dart';
import 'package:erp/src/screens/systemInfo/elements/appSizeInfo.Element.dart';
import 'package:erp/src/screens/systemInfo/systemInfo.Controller.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erpcore/components/appbars/appBarCustom.Component.dart';

class SystemInfoScreen extends GetWidget<SystemInfoController>{
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.onRefreshData();
      },
      child: Scaffold(
        appBar: CustomAppBarComponent (
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
                  child: Text("Thông tin hệ thống",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor))
                ),
              ),
              const SizedBox(width: 20,),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: const Column(
              children: [
                Card(
                  color: AppColor.whiteColor,
                  elevation: 10,
                  child: AppInfoElement()
                ),
                SizedBox(height: 10.0),
                Card(
                  color: AppColor.whiteColor,
                  elevation: 10,
                  child: AppSizeInfoElement()
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}