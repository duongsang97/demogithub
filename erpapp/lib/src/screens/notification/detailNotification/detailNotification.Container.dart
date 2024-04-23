import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/htmlRender/htmlRender.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/notification/detailNotification/detailNotification.Controller.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailNotificationScreen extends GetWidget<DetailNotificationController> {
  final DetailNotificationController detailNotificationController = Get.find();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColor.zirconColor,
      appBar: CustomAppBarComponent(
        height: 50,
        borderRadius: BorderRadius.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                GestureDetector(
                  child: Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
                    onTap: (){
                      Get.back();
                    },
                  ),
                Obx(()=>Expanded(child: Text(detailNotificationController.notify.value.title??"Chi tiết thông báo",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: detailNotificationController.getTitleSize()),
                  )
                ),),
                SizedBox(width: 30,),
              ]
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25),
        child: Column(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColor.whiteColor,
                border: Border.all(
                  width: 1, color: AppColor.brightBlue,
                )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      child: Row(
                        children: [
                          Container(
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: AppColor.azureColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(width: 2, color: AppColor.brightBlue),
                              ),
                              child: Image.asset("assets/images/icons/blue_bell.png",height: 40,width: 40, color: AppColor.brightBlue)
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Obx(() => Text(detailNotificationController.notify.value.title ?? "Thông báo", 
                              style: TextStyle(color: AppColor.nearlyBlack, fontSize: 15))),
                          ),
                        ],
                      )
                    ),
                    Obx(() => _buildItemDetail("Loại", detailNotificationController.tagSelected.value.name ?? "")),
                    Obx(() => _buildItemDetail("Thời gian", detailNotificationController.notify.value.createDate?.sD ?? "")),
                    Obx(() => _buildItemDetail("Nội dung", detailNotificationController.notify.value.content ?? "")),
                    // Obx(() => _buildItemDetail("Mô tả", detailNotificationController.notify.value.description ?? "")),
                  ],
                ),
              ),
            ),
            Obx(() => Visibility(
              visible: !PrCodeName.isEmpty(detailNotificationController.notify.value.nextFunction) && detailNotificationController.notify.value.nextFunction?.code == "201",
              child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              width: size.width,
              child: ButtonDefaultComponent(title:"", icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 35.0),
                  Text("Chuyển tiếp", style: TextStyle(
                    color: AppColor.whiteColor,fontSize: 15,
                    ),textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(Icons.keyboard_double_arrow_right, color: AppColor.whiteColor, size: 23),
                  ),
                ],
              ) , padding: const EdgeInsets.symmetric(vertical: 10.0), onPress: (){
                detailNotificationController.onDirection();
              })), 
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildItemDetail (String title, String content, {Color? contentColor}) {
    Widget result;
    result = Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title,style: TextStyle(color: AppColor.deactivatedText, fontSize: 12, fontWeight: FontWeight.w700))),
          const SizedBox(width: 10.0), 
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(content, textAlign: TextAlign.right, style: TextStyle(color: contentColor ?? AppColor.nearlyBlack, fontSize: 12, fontWeight: FontWeight.w700))
            )
          ),
        ],
      ),
    );
    return result;
  }
}
