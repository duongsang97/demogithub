import 'package:erp/src/screens/main/main.Controller.dart';
import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/chats/messageSending.Model.dart';
import 'package:erpcore/models/apps/chats/userChatInfo.Model.dart';
import 'package:erpcore/providers/erp/chat.Provider.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ListChatController extends GetxController{
  RxBool isPageLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isSearchLoading = false.obs;
  late ChatProvider chatProvider;
  RxList<UserChatInfoModel> listUser = RxList.empty(growable: true);
  late MainController mainController;
  Color appbarColor = AppColor.acacyColor.withOpacity(0.8);
  TextEditingController txtSeachController = TextEditingController();
  RxBool isSearchShow = false.obs;
  Rx<PaginationInfoModel> pagingData = Rx<PaginationInfoModel>(PaginationInfoModel(page: 1,pageSize: 20));
  late ScrollController scrollController;
  @override
  void onInit() {
    chatProvider = ChatProvider();
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    mainController = Get.find();
    mainController.appbarByScreen.value = buildAppBar;
    mainController.appbarColor.value = appbarColor;
    fetchUserChat(keyword: "",paging: false);
    scrollController.addListener(eventListenScroll);
    mainController.messageData.listen((p0) {handleReceiverMessage(p0);});
    super.onReady();
  }
  @override
  onClose(){
    txtSeachController.dispose();
    super.onClose();
  }

  void handleReceiverMessage(List<MessageSendingModel> msgs){
    if(listUser.isEmpty){
      fetchUserChat(loading: false);
    }
    else{
      for(var msg in msgs){
        int index = listUser.indexWhere((element) => element.username == msg.sender);
        if(index >=0){
          listUser[index].content = msg.content;
          listUser[index].sendtime = (msg.createDate??PrDate()).sD;
          listUser[index].seen = 0;
          listUser[index].online = true;
          if(index != 0){
            var temp = listUser[index];
            listUser[index] = listUser[0];
            listUser[0] = temp;
          }

          listUser.refresh();
        }
        else{
          fetchUserChat(loading: false);
        }
      }
    }
  }

  void eventListenScroll(){
    if (scrollController.position.atEdge) {
      bool isTop = scrollController.position.pixels == 0;
      if (isTop) {
        //beforeOffset = scrollController.offset;
        //handleNextPage();
      }
      else{
        if((pagingData.value.page??1) < (pagingData.value.totalPage??1)){
          pagingData.value.page = (pagingData.value.page??1)+1;
          if(isSearchShow.value){
            fetchUserUser(keyword: txtSeachController.text,paging: true);
          }
          else{
            fetchUserChat(keyword: txtSeachController.text,paging: true);
          }
        }
      }
    }
  }

  Future<void> fetchUserUser({String? keyword ="",bool paging = false,bool loading = true}) async{
    try{
      if(paging && loading){
        LoadingComponent.show();
      }
      else if(loading){
        pagingData.value = PaginationInfoModel(page: 1,pageSize: 20);
        isLoading.value = true;
      }
      var responses = await chatProvider.getListUser(keyword: keyword,pagingData: pagingData.value);
      if(paging && loading){
        LoadingComponent.dismiss();
      }
      else if(loading){
        isLoading.value = false;
      }
      if(responses.statusCode == 0){
        if(paging){
          listUser.addAll(responses.data);
        }
        else{
          listUser.value =responses.data;
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fetchUserChat listChat.Controller");
    }
  }

  Future<void> fetchUserChat({String? keyword ="",bool paging = false,bool loading = true}) async{
    try{
      if(paging && loading){
        LoadingComponent.show();
        
      }
      else if(loading){
        pagingData.value = PaginationInfoModel(page: 1,pageSize: 20);
        isLoading.value = true;
      }
      var responses = await chatProvider.getListChat(keyword: keyword,pagingData: pagingData.value);
      if(paging && loading){
        LoadingComponent.dismiss();
      }
      else if(loading){
        isLoading.value = false;
      }
      if(responses.statusCode == 0){
        if(paging){
          listUser.addAll(responses.data);
        }
        else{
          listUser.value =responses.data;
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fetchUserChat listChat.Controller");
    }
  }

  void onPressItemSearchChat(UserChatInfoModel selected){
    Get.toNamed(AppRouter.inbox,arguments: {"data":selected});
  }

  Widget get buildBoxSearch{
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: txtSeachController,
            onSubmitted: (String v){
              fetchUserUser(keyword: v,paging: false);
            },
            style: const TextStyle(color: AppColor.whiteColor,fontSize: 14),
            cursorColor: AppColor.whiteColor,
            decoration: const InputDecoration(
              isDense:true,
              border: InputBorder.none,
              errorBorder:  InputBorder.none,
              enabledBorder:  InputBorder.none,
              focusedBorder:  InputBorder.none,
              disabledBorder:  InputBorder.none,
              labelStyle: TextStyle(fontSize: 14,color: AppColor.whiteColor,),
              contentPadding: EdgeInsets.only(left: 10,right: 5),
              hintText: "Nhập từ khóa...",
              hintStyle: TextStyle(color: AppColor.whiteColor,fontSize: 14)
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: (){
              isSearchShow.value = false;
              txtSeachController.clear();
              fetchUserChat(keyword: "",paging: false);
            },
            child: const Icon(Icons.cancel,color: AppColor.whiteColor,),
          ),
        )
      ],
    );
  }

  Widget get buildAppBar{
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: !isSearchShow.value ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Trò chuyện",style: TextStyle(fontSize: 18,color: AppColor.whiteColor,fontWeight: FontWeight.bold),),
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: (){
                      isSearchShow.value = true;
                      listUser.clear();
                      pagingData = Rx<PaginationInfoModel>(PaginationInfoModel(page: 1,pageSize: 20));
                    },
                    child: SvgPicture.asset("assets/images/icons/bold/Search.svg",color: AppColor.whiteColor,),
                  )
                )
            ],
          )
          : buildBoxSearch),
      ],
    ));
  }

}