import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:erp/src/screens/profile/pages/identify/identify.Controller.dart';
import 'package:erpcore/components/appbars/appBarTab.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';

class IdentifyScreen extends GetWidget<IdentifyController>{

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBarTabComponent(
        height: 100,
        title: const Text("Định danh điện tử",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.whiteColor)),
        tabs: controller.tabs,
        tabSelected: controller.tabSelected.value,
        tabOnChange: controller.tabOnChange,
      ),
      body: _buildPageView(),
    ));
  }

  Widget _buildPageView() {
    return Navigator(
      key: Get.nestedKey(AppKey.keyIdentificationTab),
      initialRoute: AppRouter.authenticity,
      onGenerateRoute: controller.onGenerateRoute,
    );
  }
}