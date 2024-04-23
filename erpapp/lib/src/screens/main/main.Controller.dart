import 'dart:convert';

import 'package:erp/src/screens/chats/listChat/listChat.Container.dart';
import 'package:erp/src/screens/chats/listChat/listChat.Controller.dart';
import 'package:erp/src/screens/newsFeed/newsFeed.Container.dart';
import 'package:erp/src/screens/newsFeed/newsFeed.Controller.dart';
import 'package:erpcore/components/tabs/tabBottomNavigation.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:erpcore/models/apps/chats/messageSending.Model.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erp/src/screens/home/home.Container.dart';
import 'package:erp/src/screens/profile/profile.Binding.dart';
import 'package:erp/src/screens/profile/profile.Container.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/permission.utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Import theses libraries.
import 'package:signalr_netcore/signalr_client.dart';

import '../chats/listChat/listChat.binding.dart';
import '../home/home.Binding.dart';
import '../newsFeed/newsFeed.binding.dart';
class MainController extends GetxController{
  List<String> routerList =[AppRouter.home,AppRouter.newsFeed,AppRouter.chat,AppRouter.profile];
  late BuildContext context;
  // Configer the logging
  late HubConnection hubConnection;
  RxList<MessageSendingModel> messageData = RxList.empty(growable: true);
  AppController appController = Get.find();
  RxList<ItemBottomModel> tabs = RxList<ItemBottomModel>.empty(growable: true);
  RxInt tabSelected =0.obs;
  Rx<Widget?> appbarByScreen = Rx<Widget?>(null);
  Rx<Color?> appbarColor = Rx<Color?>(null);
  @override
  void onInit() {
    hubConnection = HubConnectionBuilder().withUrl(AppServiceAPIData.chatServerURL).build();
    PermisstionUtils().init(); // nạp dữ liệu quyền lên static
    tabs.addAll([
      ItemBottomModel(sysCode: generateKeyCode(),label: "Trang chủ",activeIcon: SvgPicture.asset("assets/images/icons/bold/Home.svg",width: 23,color: AppColor.acacyColor),inActiveIcon:  SvgPicture.asset("assets/images/icons/light/Home.svg",width: 23,),),
      ItemBottomModel(sysCode: generateKeyCode(),label: "Bảng tin",inActiveIcon: SvgPicture.asset("assets/images/icons/light/screenmirroring_linear.svg",width: 23),activeIcon:  SvgPicture.asset("assets/images/icons/bold/screenmirroring_bold.svg",color: AppColor.acacyColor,width: 23),),
      ItemBottomModel(sysCode: generateKeyCode(),label: "Trò chuyện",inActiveIcon: SvgPicture.asset("assets/images/icons/light/messager_linear.svg",width: 23),activeIcon:  SvgPicture.asset("assets/images/icons/bold/messager_bold.svg",color: AppColor.acacyColor,width: 23),),
      ItemBottomModel(sysCode: generateKeyCode(),label: "Tài khoản",inActiveIcon: SvgPicture.asset("assets/images/icons/light/Profile.svg",width: 23),activeIcon:  SvgPicture.asset("assets/images/icons/bold/Profile.svg",color: AppColor.acacyColor,width: 23),)
    ]);
    super.onInit();
  }

  @override
  void onReady() async{
    handleSignAlr();
    super.onReady();
    //appController.questionBiometrics();
    appController.fetchNotifyData();
  }

  Future<void> handleSignAlr() async{
    try{
      if (!kDebugMode) {
        await hubConnection.start();
        var param = ["${appController.userProfle.value.userName}",getChatChannelByServer()];
        await hubConnection.invoke('ping', args: param);
        hubConnection.on('MessageSending',handleHubMessageSending);
        hubConnection.onclose(({error}) {handleSignAlr();});
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleSignAlr main.Controller");
    }
  }

  Future<void> handleHubMessageSending(dynamic msg) async{
    try{
      messageData.value  = MessageSendingModel.fromJsonList(msg);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleHubMessageSending main.Controller");
    }
  }

  void switchTap(int tab) {
    // && ![1,2].contains(tab)
    if(tabSelected.value != tab && tab != 1){
      tabSelected.value = tab;
      Get.keys[AppKey.keyTabMain]!.currentState!.pushNamed(routerList[tab]);
      if(tab == 1 && Get.isRegistered<NewsFeedController>()){

      }
      else if(tab == 2 && Get.isRegistered<ListChatController>()){
        ListChatController listChatController = Get.find();
        appbarByScreen.value = listChatController.buildAppBar;
        appbarColor.value = listChatController.appbarColor;
      }
      else{
        appbarByScreen.value = null;
        appbarColor.value = null;
      }
    }
  }


  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouter.home:
        return GetPageRoute(
          transition: Transition.leftToRight,
          settings: settings,
          page: () => HomeScreen(),
          binding: HomeBinding(),
        );
      case AppRouter.newsFeed:
        return GetPageRoute(
          transition: Transition.rightToLeft,
          settings: settings,
          page: () => NewsFeedScreen(),
          binding: NewsFeedBinding(),
        );
      case AppRouter.chat:
        return GetPageRoute(
          transition: Transition.rightToLeft,
          settings: settings,
          page: () => ListChatScreen(),
          binding: ListChatBinding(),
        );
      case AppRouter.profile:
        return GetPageRoute(
          transition: Transition.rightToLeft,
          settings: settings,
          page: () => ProfileScreen(),
          binding: ProfileBinding(),
        );
      default: return GetPageRoute(
        transition: Transition.leftToRight,
        settings: settings,
        page: () => HomeScreen(),
        binding: HomeBinding(),
      );
    }
  }

  
}