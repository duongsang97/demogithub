import 'package:erpcore/components/shimmerPage/shimmerList.Component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'elements/itemChat.Element.dart';
import 'listChat.Controller.dart';

class ListChatScreen extends GetWidget<ListChatController>{
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => RefreshIndicator(
      onRefresh: () async{
        await controller.fetchUserChat(keyword: controller.txtSeachController.text);
      },
      child: Scrollbar(controller: controller.scrollController,child:  buildBoxContent,)
    ));
  }
  Widget get buildBoxContent{
    if(controller.isLoading.value){
      return const ShimmerListComponent();
    }
    else if(controller.listUser.isEmpty){
      return Center(child: Text(controller.isSearchShow.value?"Không tìm thấy dữ liệu phù hợp":"Chưa có cuộc trò chuyện nào"),);
    }
    else{
      return ListView.builder(
        padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
        shrinkWrap: true,
        itemCount:controller.listUser.length,
        itemBuilder: (BuildContext context,int index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ItemChatElement(data: controller.listUser[index],),
          );
        }
      );
    }
  }
}