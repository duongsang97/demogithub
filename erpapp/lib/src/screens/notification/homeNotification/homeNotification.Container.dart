import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/components/boxs/boxListPagination.Component.dart';
import 'package:erpcore/components/filter/tagFilter.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/notification/homeNotification/elements/ItemNotification.Element.dart';
import 'package:erp/src/screens/notification/homeNotification/homeNotification.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erpcore/components/appbars/appBarTab.component.dart';

class HomeNotificationScreen extends GetWidget<HomeNotificationController> {
  final HomeNotificationController homeNotificationController = Get.find();
  @override
  Widget build(BuildContext context) {
    homeNotificationController.context = context;
    return Obx(() => Scaffold(
      appBar: AppBarTabComponent(
        height: 90,
        title: const Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Text("Thông báo",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 19),),
          //    Obx(()=> Padding(
          //    padding: const EdgeInsets.only(right: 5),
          //    child: Text(homeNotificationController.pageConfig.value.pageDisplay,
          //      style: const TextStyle(color: Colors.white,fontSize: 13,),
          //    ),
          //  ))
         ]
       ),
      tabs: homeNotificationController.tags,
      tabSelected: homeNotificationController.tagSelected.value,
      tabOnChange: homeNotificationController.onTagSelect,
      ),
      body: BoxListPaginationComponent(
        onScroll: (offset) {
          homeNotificationController.onScroll(offset);
        },
        onFetchData: () async {
          await homeNotificationController.fetchNotifyData(true, false);
        },
        onRefresh: () async{
          await homeNotificationController.fetchNotifyData(true, true);
        },
        isLoading: homeNotificationController.isLoading.value,
        pageLoading: homeNotificationController.isPageLoading.value,
        page: homeNotificationController.pageConfig.value,
        child: _handleUI(),
      )
    ));
  }

  Widget _handleUI(){
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: homeNotificationController.listCreateDate.length,
        itemBuilder: (BuildContext context, int index){
          var item =  homeNotificationController.listCreateDate[index];
          var listNotification = homeNotificationController.getListNotificationByDate(item);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.all(10.0),
                child: Text(item, style: const TextStyle(fontSize: 13, color: AppColor.nearlyBlack, fontWeight: FontWeight.w700))
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listNotification.length,
                itemBuilder: (BuildContext context, int index){
                  var item =  listNotification[index];
                  return ItemNotificationElement(
                    item: item,
                    isFinal: index == (listNotification.length - 1),
                    onPress: homeNotificationController.onPressNotify,
                  );
                }
              ),
            ],
          );
        }
      );
  }
}
