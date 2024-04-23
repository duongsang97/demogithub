import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/components/appbars/appBarMain.Component.dart';
import 'package:erpcore/components/tabs/tabBottomNavigation.Component.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erp/src/screens/main/main.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MainScreen extends GetWidget<MainController> {
  MainController mainController = Get.find();
  AppController appController = Get.find();
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    mainController.context = context;
    return Obx(() => Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppbarMainComponent(
        notifys: appController.notifys,
        userProfle: appController.userProfle.value,
        onTapAvt: (){
          final MainController mainController = Get.find();
          mainController.switchTap(mainController.tabSelected.value);
        },
        routerHomeNotification: AppRouter.homeNotification,
        backgroundColor: controller.appbarColor.value,
        child: controller.appbarByScreen.value,
      ),
      extendBody:false,
      body: _buildPageView(),
      bottomNavigationBar: Obx(()=>TabBottomComponent(
        switchTap: mainController.switchTap,
        tabIndex: mainController.tabSelected.value,
        tabItems: mainController.tabs.value
      ))
    ));
  }

  Widget _buildPageView() {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Navigator(
        key: Get.nestedKey(AppKey.keyTabMain),
        initialRoute: AppRouter.home,
        onGenerateRoute: mainController.onGenerateRoute,
      ),
    );
  }
}

