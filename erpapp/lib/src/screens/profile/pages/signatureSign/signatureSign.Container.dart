import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/components/shimmerPage/shimmerListBox.Component.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureSign.Controller.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/elements/signature.Element.dart';

class SignatureSignScreen extends GetWidget<SignatureSignController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
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
                child: Text("Chữ ký số",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor))
              ),
            ),
            const SizedBox(width: 40,),
          ],
        ),
      ),
      body: Obx(() => _buildBoxContent(context)),
      floatingActionButton: GestureDetector(
        onTap:(){
          controller.onRouteDetailSignature(context);
        },
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: AppColor.brightBlue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:  Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(6, 5), // Shadow position
              ),
            ],
          ),
          child: const Icon(Icons.drive_file_rename_outline_outlined,size: 25,color: AppColor.whiteColor,),
        ),
      ),
    );
  }

  Widget _buildBoxContent(BuildContext context){
    if(controller.isLoading.value){
      return const ShimmerListBoxComponent();
    }
    else if(controller.listSignature.isEmpty){
      return const Center(
        child: Text("Không có dữ liệu"),
      );
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
            childAspectRatio: MediaQuery.of(context).size.width /(MediaQuery.of(context).size.height / 2.7),
          ),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: controller.listSignature.length,
          itemBuilder: (BuildContext context, int index){
            return SignatureElement(signature: controller.listSignature[index], onCallBack: (){
              controller.onRouteDetailSignature(context, sysCode: controller.listSignature[index].sysCode ?? "");
            }, onDeleteCallBack: (){
              controller.onDeleteSignature(controller.listSignature[index].sysCode ?? "", controller.listSignature[index].name ?? "");
            },);
          }  
        ),
      );
    }
  }
}