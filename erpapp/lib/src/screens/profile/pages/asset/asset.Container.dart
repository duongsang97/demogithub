import 'package:erp/src/screens/profile/pages/asset/asset.Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/components/shimmerPage/shimmerListBox.Component.dart';
import 'elements/asset.element.dart';

class AssetScreen extends GetWidget<AssetController>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarComponent(
        borderRadius: BorderRadius.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
              onPressed: () async{
                Get.back();
              }
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("Tài sản của tôi",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor))
              ),
            ),
            const SizedBox(width: 40,),
          ],
        ),
      ),
      body: Obx(()=>_buildBoxContent(context))
    );
  }

  Widget _buildBoxContent(BuildContext context){
    if(controller.isLoading.value){
      return const ShimmerListBoxComponent();
    }
    else if(controller.listAsset.isEmpty){
      return const Center(child: Text("Không có tài sản được cấp phát"),);
    }
    else{
      return RefreshIndicator(
        onRefresh: () async{
          await controller.fetchData();
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: MediaQuery.of(context).size.width /(MediaQuery.of(context).size.height / 2.2),
          ),
          padding: EdgeInsets.zero,
          itemCount: controller.listAsset.length,
          itemBuilder: (BuildContext context, int index){
            return AssetElement(asset: controller.listAsset[index], onCallBack: (){
              controller.onRouteDetailSignature(context, sysCode: controller.listAsset[index].code ?? "");
            });
          }  
        ),
      );
    }
  }
}