import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:erp/src/screens/systemInfo/systemInfo.Controller.dart';
import 'package:get/get.dart';
import 'dart:io';

class AppInfoElement extends StatelessWidget {
  const AppInfoElement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SystemInfoController>();
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container( alignment: Alignment.centerLeft, child: Text("Thông tin ứng dụng", style: TextStyle(color: AppColor.laSalleGreen, fontSize: 18, fontWeight: FontWeight.w700),)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Container( 
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppConfig.appColor,  
              ),
               child: Obx(() => (controller.logo.value.code == "0") ? 
                Image.asset(controller.logo.value.name!,
                  height: Get.width / 4
                ) : Image.file(File(Uri.parse(controller.logo.value.name!).path))))
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(controller.packageInfo.value.appName, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600))), 
                      SizedBox(height: 5.0),
                      Obx(() => Text("Version: ${controller.packageInfo.value.version}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)))
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}