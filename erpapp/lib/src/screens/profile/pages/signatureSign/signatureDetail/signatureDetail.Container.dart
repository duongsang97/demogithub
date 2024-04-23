import 'package:erpcore/components/shimmerPage/shimmerBox.Component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:erpcore/components/shimmerPage/shimmerListDoc.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/components/selectBox/selectBoxVersatile.Component.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureDetail/signatureDetail.Controller.dart';
import 'package:erpcore/components/radioButton/radioButton.Component.dart';

class SignatureDetailScreen extends GetWidget<SignatureDetailController>{
  
  const SignatureDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Obx(() => !controller.isLoading.value ? 
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: controller.type.value == 0,
                      child: TextInputComponent(
                        enable: false,
                        title: "Mã chữ ký", 
                        controller: controller.signature.value.codeTextController,
                      ),
                    ),
                    TextInputComponent(
                      title: controller.isFocusCode.value ? "Nhập mã chữ ký hoặc hệ thống tự sinh" : "Tên*", 
                      controller: controller.isFocusCode.value ? controller.signature.value.codeTextController : controller.signature.value.nameController,
                      focus: controller.signature.value.focusNode,
                      onChanged: (value) {
                        controller.onChangedText(value);  
                      },
                      icon: controller.type.value == 0 ? null : GestureDetector(onTap:(){
                        controller.onChangeStatusFocusCode(context, controller.signature.value.focusNode, isAction: true);
                      },child: Icon(Icons.bolt, size: 23, color: controller.isFocusCode.value ? AppColor.orangeColor : AppColor.nearlyBlack)),
                      forcusListen: (){
                        if (controller.signature.value.focusNode.hasFocus ==true){
                        } else{
                          if(controller.signature.value.codeTextController.text.isEmpty){
                            controller.onChangeStatusFocusCode(context, controller.signature.value.focusNode);
                          }
                        }
                      },
                      onFieldSubmitted: (String v){
                        controller.onChangeStatusFocusCode(context, controller.signature.value.focusNode);
                      },
                    ),
                    TextInputComponent(
                      title: "Email*", 
                      controller: controller.signature.value.emailController,
                    ),
                    TextInputComponent(
                      title: "Chức vụ*", 
                      controller: controller.signature.value.positionController,
                      onChanged: (value) {
                        controller.onChangedText(value);  
                      },
                    ),
                    Visibility(
                      visible: controller.typeSelected.value.code == "0",
                      child: TextInputComponent(
                        title: "Nội dung", 
                        controller: controller.signature.value.contentController,
                        onChanged: (value) {
                          controller.onChangedText(value);  
                        },
                      ),
                    ),
                    Visibility(
                      visible: controller.typeSelected.value.code == "0",
                      child: Row(
                        children: [
                          Expanded(
                            child: TextInputComponent(
                              title: "Chiều cao*", 
                              controller: controller.height,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: TextInputComponent(
                              title: "Độ dài*", 
                              controller: controller.width,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SelectBoxVersatileComponent(
                      label: "Tài khoản*",
                      selectedItem: controller.accountSelected.value,
                      displayType: true,
                      asyncListData: (String keyword,int page,int pageSize){
                        return controller.fetchUserData(keyword: keyword,page: page,pageSize: pageSize);
                      },
                      listData: controller.listUser,
                      onChanged: (PrCodeName? item) async{
                      if (!PrCodeName.isEmpty(item)) {
                        controller.accountSelected.value = item!;
                      } else {
                        controller.accountSelected.value = PrCodeName();
                      }
                    }),
                    const SizedBox(height: 10),
                    Container( 
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            child: RadioButtonComponent(
                              itemSelected: controller.typeSelected.value,
                              widthRadio: 30,
                              item: (controller.listType.first),
                              onChanged: (item) {
                                controller.onChangeType(item);
                              },
                            ),
                          ), 
                          SizedBox(
                            width: 120,
                            child: RadioButtonComponent(
                              widthRadio: 30,
                              itemSelected: controller.typeSelected.value,
                              item: (controller.listType.last),
                              onChanged: (item) {
                                controller.onChangeType(item);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    controller.typeSelected.value.code == "2" ?
                      Stack(
                        children: [
                          GestureDetector(
                            onTap:(){
                              controller.onActionImage(1, context);
                            },
                            child: Container(
                              width: size.width,
                              height: size.width * 0.6,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(width: 0.2)
                              ),
                              child: controller.fileImageChoose.value.existsSync() && controller.fileImageChoose.value.lengthSync() > 0
                                ? ClipRRect(borderRadius: BorderRadius.circular(10.0),child: Image.file(controller.fileImageChoose.value, fit: BoxFit.cover)) 
                                : ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Image.asset('assets/images/icons/upload_image.png', width: size.width * 0.1,height: size.width * 0.1, fit: BoxFit.scaleDown,color: AppColor.brightBlue.withOpacity(0.3),)),
                            ),
                          ),
                          Visibility(
                            visible: controller.fileImageChoose.value.existsSync() && controller.fileImageChoose.value.lengthSync() > 0,
                            child: Positioned(
                              left: 0,
                              top: 0,
                              child: ButtonImage(delete: true, onCallBack: (){
                                  controller.onActionImage(0, context);
                              },),
                            ),
                          ),
                        ],
                      ) : 
                      Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 0.2)
                            ),
                            child: controller.isLoadingImage.value ? ShimmerBoxComponent(quantity: 1,) : (controller.imageDefault.value.existsSync() && controller.imageDefault.value.lengthSync() > 0)
                            ? Image.file(controller.imageDefault.value,fit: BoxFit.contain)
                            : ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Image.asset('assets/images/icons/upload_image.png', width: size.width * 0.1,height: size.width * 0.1, fit: BoxFit.scaleDown,color: AppColor.brightBlue.withOpacity(0.3),)),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    TextInputComponent(
                      title: "Ghi chú", 
                      controller: controller.signature.value.noteController,
                      placeholder: '',
                      heightBox: 150,
                      maxLine: 10,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            )
            : Expanded(child: SizedBox(width: Get.width, child: const ShimmerListDocComponent()))
          ),
          Obx(() => Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            child: ButtonDefaultComponent(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              width: Get.width * 0.6,
              title: controller.type.value == 0 ? "Lưu chữ ký" : "Thêm chữ ký",
              onPress: () {
                controller.onSaveSignature();
              },
              backgroundColor: AppColor.brightBlue,
              titleStyle: TextStyle(fontSize: 18, color: AppColor.whiteColor),
            ),
          )),
        ],
      ),
    );
  }

}

class ButtonImage extends StatelessWidget {
  const ButtonImage({
    super.key,
    this.title = "",
    this.onCallBack,
    this.delete = false,
  });
  final String title;
  final Function()? onCallBack;
  final bool delete;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap:(){},
      child: ButtonDefaultComponent(
        padding: const EdgeInsets.all(2.0),
        title: title,
        width: title.isNotEmpty ? size.width * 0.2  : null,
        titleStyle: TextStyle(color: AppColor.whiteColor,fontSize: 12),
        onPress: (){
          if (onCallBack != null) {
            onCallBack!();
          }
        },
        icon: !title.isNotEmpty ? Row(
          children: [
            Icon( delete ? Icons.delete : Icons.add_photo_alternate, size: 15, color: AppColor.whiteColor),
          ],
        ) : null,
        backgroundColor: delete ? AppColor.brightRed : AppColor.orangeColor,
      ),
    );
  }
}