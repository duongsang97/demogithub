import 'package:erpcore/components/shimmerPage/shimmerListMessage.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/chats/inbox/inbox.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'elements/messageInbox.Element.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InboxScreen extends GetWidget<InboxController>{
  final InboxController inboxController = Get.find();
  EdgeInsets padding = EdgeInsets.zero;
  Size size = const Size(0,0);
  @override
  Widget build(BuildContext context) {
    padding = MediaQuery.paddingOf(context);
    size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColor.whiteColor.withOpacity(0.95),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new_sharp,color: AppColor.whiteColor,size: 25,),
        ),
        centerTitle: false,
        title: Text(controller.getNickName(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor),),
        actions: [
          GestureDetector(
            child: Image.asset("assets/images/icons/phone_call.png",height: 22,color: AppColor.azureColor,),
          ),
          const SizedBox(width: 20,),
          GestureDetector(
            child: Image.asset("assets/images/icons/video_call.png",height: 28,color:  AppColor.azureColor,),
          ),
          const SizedBox(width: 20,),
        ],
        backgroundColor: AppColor.acacyColor.withOpacity(0.8),
      ),
      body: SizedBox(
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(()=>!inboxController.isPageLoading.value?ListView.builder(
                keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.manual,
                reverse: true,
                itemCount: inboxController.dataMessage.length,
                itemBuilder: (BuildContext context,int index){
                  var item = inboxController.dataMessage[index];
                  bool showAvatar =false;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    child: MessageInboxElement(data: inboxController.dataMessage[index],showAvatar: showAvatar,userChatInfo: inboxController.chatObject.value,)
                  );
                }
              ):const ShimmerListMessageComponent())
            ),
            Obx(()=>buildBoxChatInput())
          ],
        ),
      ), 
    );
  }
  
  Widget buildBoxChatInput(){
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 5,bottom: 2+padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    constraints: BoxConstraints(
                      maxHeight: Get.height*.2
                    ),
                    decoration:  BoxDecoration(
                      color: AppColor.grey.withOpacity(0.2),
                      borderRadius:const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: controller.moreLines.value?CrossAxisAlignment.end:CrossAxisAlignment.center,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              color: AppColor.acacyColor.withOpacity(0.9),
                              shape: BoxShape.circle
                            ),
                            child: SvgPicture.asset("assets/images/icons/bold/Camera.svg",color: AppColor.whiteColor,width: 20,),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            key: controller.inputKey,
                            controller: controller.txtMessageInputController,
                            keyboardType: TextInputType.multiline,
                            onChanged: (v){
                              controller.checkTextOverflow();
                            },
                            textAlign: TextAlign.left,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder:InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10,right: 5),
                              isDense: true
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                GestureDetector(
                  onTap: controller.sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(9.0),
                    decoration: BoxDecoration(
                      color: controller.isSend?AppColor.brightRed:AppColor.grey,
                      shape: BoxShape.circle
                    ),
                    child: !controller.isLoading.value?SvgPicture.asset("assets/images/icons/bold/Send.svg",color: AppColor.whiteColor,width: 20,):LoadingAnimationWidget.threeRotatingDots(color: AppColor.whiteColor,size: 20,),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}