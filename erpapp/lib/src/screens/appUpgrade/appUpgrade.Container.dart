import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'appUpgrade.Controller.dart';
import 'elements/versionInfo.Element.dart';

class AppUpgradeScreen extends GetWidget<AppUpgradeController>{
  final AppController appController = Get.find();
  final AppUpgradeController appUpgradeController = Get.find();
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage("assets/images/app_background.png"),
        //   fit: BoxFit.fill
        // )
        color: AppColor.whiteColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppConfig.appColor,
                  leading: GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  expandedHeight: size.height*.2,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('PHIÊN BẢN MỚI', textScaleFactor: 1,style: TextStyle(fontWeight: FontWeight.bold),),
                    background: Image.asset('assets/images/background/header_erp_background.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Obx(()=>(appUpgradeController.appVersionInfo.value.sysCode != null)
                    ?VersionInfoElement(appVersion: appUpgradeController.appVersionInfo.value)
                    :const Center(child: Text("Không có thông tin cập nhật"),)
                    
                    )
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              child: SizedBox(
                //height: 50,
                width: size.width*.5,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColor.jadeColor)
                  ),
                  onPressed: (){
                    // if(!appUpgradeController.isLoading.value){
                      
                    // }
                    appUpgradeController.updateHandle();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child:const Text("Cập nhật",style: TextStyle(color: AppColor.whiteColor),)
                  )
                ),)
            )
          ],
        )
      ),
    );
  }
  
}