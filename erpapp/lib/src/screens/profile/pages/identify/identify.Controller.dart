import 'package:erp/src/routers/app.Router.dart';
import 'package:erp/src/screens/profile/pages/identify/pages/Authencity/authencity.Container.dart';
import 'package:erp/src/screens/profile/pages/identify/pages/authencity/authencity.Bindings.dart';
import 'package:erp/src/screens/profile/pages/identify/pages/verifiability/statusVerify.binding.dart';
import 'package:erp/src/screens/profile/pages/identify/pages/verifiability/statusVerify.container.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class IdentifyController extends GetxController{
  List<PrCodeName> tabs = [
    PrCodeName(code: "0",name: "Xác thực"),
    PrCodeName(code: "1",name: "Xác minh")
  ];
  Rx<PrCodeName> tabSelected = PrCodeName(code: "",name: "").obs;
  PageController pageController = PageController(initialPage: 0,keepPage: false);
  List<String> routerList =[AppRouter.authenticity,AppRouter.verifyDashboard];

  @override
  void onInit() {
    tabSelected.value = tabs.first;
    super.onInit();
  }

  void tabOnChange(PrCodeName tab){
    tabSelected.value = tab;
    int index = tabs.indexWhere((element) => element.code == tab.code);
    Get.keys[AppKey.keyIdentificationTab]!.currentState!.pushNamed(routerList[index]);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouter.authenticity:
        return GetPageRoute(
          transition: Transition.leftToRight,
          settings: settings,
          page: () => AuthenticityScreen(),
          binding: AuthenticityBinding(),
        );
      case AppRouter.verifyDashboard:
        return GetPageRoute(
          transition: Transition.rightToLeft,
          settings: settings,
          page: () => StatusVerifyScreen(),
          binding: StatusVerifyBinding(),
        );
      default: return GetPageRoute(
        transition: Transition.leftToRight,
        settings: settings,
        page: () => AuthenticityScreen(),
        binding: AuthenticityBinding(),
      );
    }
  }
}