import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/components/dateTime/switchDateTime/switchDateTime.Component.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/attendants/attendantHome/attendantHome.Controller.dart';
import 'package:erp/src/screens/attendants/attendantOff/attendantOff.Container.dart';
import 'package:erp/src/screens/attendants/attendantOff/attendantOff.Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'attendantMain.Controller.dart';

class AttendantMainScreen extends GetWidget<AttendantMainController>{
  final AttendantMainController attendantMainController = Get.find();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarComponent(
        height: 80,
        borderRadius: BorderRadius.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                child: const Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
                onTap: (){
                  Get.back();
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Bảng công",style: TextStyle(color: AppColor.whiteColor,fontSize: 19),),
                  Obx(()=>SwitchDateTimeComponent(currentDate: attendantMainController.currentDate.value,onChange: attendantMainController.onChangeDate,),)
                ],
              )
            ),
            const SizedBox(width: 10,),
          ]
        )
      ),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.offline_bolt),
              backgroundColor: AppColor.brightBlue,
              foregroundColor: Colors.white,
              label: 'Nghỉ phép',
              onTap: () async{
                await ModalSheetComponent.showBarModalBottomSheet(
                  AttendantdayOffScreen(),
                  formSize: 0.6,
                  title: "Khai báo nghỉ",
                  isDismissible: false,
                  expand: true,
                  enableDrag: true
                ).whenComplete((){
                  Get.delete<AttendantOffController>();
                  AttendantHomeControler attendantHomeControler = Get.find();
                  attendantHomeControler.fetchOffDateByUser();
                });
              }
            ),
            SpeedDialChild(
              child: const Icon(Icons.timelapse),
              backgroundColor: AppColor.brightBlue,
              foregroundColor: Colors.white,
              label: 'Tăng ca',
              onTap: (){
                
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.check),
              backgroundColor: AppColor.brightBlue,
              foregroundColor: Colors.white,
              label: 'Chấm công',
              onTap: (){
                
              },
            ),
          ],
        ),
        onPressed: (){
        },
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: attendantMainController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        attendantMainController.switchTap(index);
      },
      children: attendantMainController.screenList,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin: 5,
        child: Container(
          margin: const EdgeInsets.only(top: 10,left: 5,right: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItemTab(0,"assets/images/icons/calendar.png","Bảng công"),
              const SizedBox(width: 10,),
              _buildItemTab(1,"assets/images/icons/history.png","Lịch sử"),
            ],
          ),
        )
      );
  }

  Widget _buildItemTab(int index,String icon,String label){
    return GestureDetector(
      onTap: (){
        attendantMainController.switchTap(index);
      },
      child: Obx(()=>SizedBox(
        height: 50,
        child: Column(
          children: [
            Image.asset(icon,height: 22,width: 22,color: (attendantMainController.tabIndex.value == index)?AppColor.brightBlue:AppColor.grey,),
            Text(label,style: TextStyle(color: (attendantMainController.tabIndex.value == index)?AppColor.brightBlue:AppColor.grey,))
          ],
        ),
      ),)
    );
  }

}