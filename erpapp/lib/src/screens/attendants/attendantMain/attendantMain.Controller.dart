import 'package:erp/src/screens/attendants/attendantHistory/attendantHistory.Container.dart';
import 'package:erp/src/screens/attendants/attendantHome/attendantHome.Container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendantMainController extends GetxController{
  RxInt tabIndex = 0.obs;
  late List<Widget> screenList;
  late PageController pageController;
  Rx<DateTime> currentDate = Rx<DateTime>(DateTime.now());
  @override
  void onInit() {
    pageController = PageController();
    screenList = [
      AttendantHomeScreen(),
      AttendantHistoryScreen(),
    ];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void switchTap(int index) {
    tabIndex.value = index;
    pageController.jumpToPage(index);
  }

  void onChangeDate(DateTime date){
    currentDate.value = date;
  }
}