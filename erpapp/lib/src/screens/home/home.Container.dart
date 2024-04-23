// ignore_for_file: must_be_immutable
import 'package:erpcore/components/boxs/boxERPTitleContent.Component.dart';
import 'package:erpcore/components/carousel/carousel.Component.dart';
import 'package:erpcore/components/items/homeFunctionItem.Component.dart';
import 'package:erpcore/components/items/homeInfoItem.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/home/home.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetWidget<HomeController>{
  late Size size;
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        homeController.onRefresh();
      },
      child: Container(
        color: AppColor.whiteColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Obx(()=>(homeController.listCarrousel.isNotEmpty)?
                CarouselComponent(
                  listCarousel: homeController.listCarrousel,
                ): const SizedBox()
              ),
              const SizedBox(height: 20,),
              Obx(()=>(homeController.listHomeFnData.isNotEmpty)?BoxERPTitleContentComponent(
                title: "Chức năng",
                isExtend: true,
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: homeController.listHomeFnData.length,
                  itemBuilder: (context, index) {
                  var item = homeController.listHomeFnData[index];
                  return HomeFunctionItemComponent(
                    fnItem: item,
                    onPress: homeController.onPressERPFunction,
                  );
                },
              ),)
            :const SizedBox(),),
            Obx(() => Visibility(
              visible: (homeController.listData.isNotEmpty),
              child: BoxERPTitleContentComponent(
              title: "Tin tức",
              isExtend: false,
              callback: (){
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() => ListView.builder(
                  padding:EdgeInsets.zero, 
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeController.listData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = homeController.listData[index];
                      return HomeInfoItemComponent(
                        label: item.title,
                        link: item.fileUrl,
                        image: "assets/images/icons/envelope.png",
                      );
                    })),
                  ),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}