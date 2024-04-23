import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/appbars/appBarCustom.Component.dart';
import 'package:erpcore/components/buttons/iconButton.Component.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/controllers/pdfGenerate/elements/pdfItemPage.element.dart';
import 'package:erpcore/controllers/pdfGenerate/models/pdfItemPage.Model.dart';
import 'package:erpcore/controllers/pdfGenerate/pdfGenerate.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:get/get.dart';

class PdfGenerateScreen extends GetWidget<PdfGenerateController>{
  final scrollController = ScrollController();
  final gridViewKey = GlobalKey();
  final gridViewKey2 = GlobalKey();
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      appBar: CustomAppBarComponent(
        borderRadius: BorderRadius.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 5,),
            IconButton(icon: const Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
              onPressed: () async{
                Get.back();
              }
            ),
            const Expanded(
              child: Align(
                child: Text("Tạo PDF",style: TextStyle(color: AppColor.whiteColor, fontSize: 18),),
              )
            ),
            Obx(() => IconButton(icon: Icon(controller.isMovePage.value?Icons.done_outline_outlined:Icons.open_with_outlined,color: AppColor.whiteColor,size: 25,),
              onPressed: () async{
                controller.isMovePage.value = !controller.isMovePage.value;
              }
            ),),
            Obx(() => Visibility(
              visible: !controller.isMovePage.value,
              child: IconButtonComponent(
                //isLoading: controller.isLoading.value,
                loadingColor: AppColor.whiteColor,
                icon: Icon(controller.inProcessing.value?Icons.dangerous_outlined:Icons.save,color: controller.inProcessing.value?AppColor.brightRed:AppColor.whiteColor,size: 25,),
                onPress: (){
                  if(controller.inProcessing.value == true){
                    controller.inProcessing.value = false;
                  }
                  else{
                    controller.createPDF();
                  }
                },
              ),
            )),
            const SizedBox(width: 5,),
          ],
        )
      ),
      body: Obx(() => controller.PDFItems.isNotEmpty?ReorderableBuilder(
        key: gridViewKey2,
        lockedIndices: [],
        onDragEnd: controller.handleDragEnd,
        onDragStarted: controller.handleDragStarted,
        scrollController: scrollController,
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            final fruit = controller.PDFItems.removeAt(orderUpdateEntity.oldIndex);
            controller.PDFItems.insert(orderUpdateEntity.newIndex, fruit);
            controller.updatePage();
          }
        },
        builder: (children) {
          return GridView.builder(
            key: gridViewKey,
            controller: scrollController,
            padding: const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: MediaQuery.sizeOf(context).width/2
            ),
            itemCount: children.length,
            itemBuilder: (BuildContext context, int index){
              return children[index];
            },
          );
        },
        children: controller.PDFItems.map<Widget>((element) => 
          PDFItemPageElement(key: Key(element.code??""),item: element,onPress: (!controller.isMovePage.value?(PDFItemPageModel item){
            controller.onPressItemPage(item);
          }:null),
        )).toList(),
      ):buildEmptyBox()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.nearlyBlue,
        child: const Icon(Icons.post_add_outlined,color: AppColor.whiteColor,size: 30,),
        onPressed: () async{
          var response = await ModalSheetComponent.showChooseFileModal(
            isMultiImage: controller.isMultiImage,
            context: context,
            formSize: 0.4,
            title: "Chọn tập tin"
          );
          if(response.statusCode == 0){
            controller.handleAddFile(response.data);
          }
          else{
            AlertControl.push(response.msg??"", type: AlertType.ERROR);
          }
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget buildEmptyBox(){
    return const Center(
      child: Text("Chưa có dữ liệu được chọn"),
    );
  }
}

