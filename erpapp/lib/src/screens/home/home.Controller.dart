import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/carouselItem.Model.dart';
import 'package:erpcore/models/apps/homeFunctionItem.Model.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/localNotification.utils.dart';
import 'package:erpcore/utility/localStorage/config.dbLocal.dart';
import 'package:erpcore/utility/localStorage/permission.dbLocal.dart';
import 'package:erpcore/utility/localizationService.utils.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:get/get.dart';
import 'package:erpcore/erpCore.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<CarouselItemModel> listCarrousel = RxList.empty(growable: true);
  RxList<HomeFunctionItemModel> listHomeFnData = List<HomeFunctionItemModel>.empty(growable: true).obs;
  late AppController appController;
  late PermissionDBLocal permissionDBLocal;
  Rx<bool> isShowTopFunc = false.obs;
  AppProvider appProvider = AppProvider();
  RxList<NotificationInfoModel> listData = RxList<NotificationInfoModel>.empty(growable: true);
  late ConfigDBLocal configDBLocal;
  bool isDone = false;
  late LocalNotificationUtils localNotification;

  @override
  void onInit() {
    appController = Get.find();
    super.onInit();
  }

  @override
  void onReady() async {
    permissionDBLocal = PermissionDBLocal();
    configDBLocal = ConfigDBLocal();
    handleFnHome();
    super.onReady();
    fetchDataNews();
    fetchAdsData();
    onDirectWhenTerminated();
    await appController.fetchDBActConfig().then((value) {
      LocalizationService.init();
    });
  }

  void onDirectWhenTerminated() {
    localNotification = LocalNotificationUtils.instance;
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message !=null) {
        try {
          var notification = PrCodeName.fromJson(message.data);
          localNotification.onDirectionRoutes(notification);
        } catch (e) {
          Get.toNamed(AppRouter.homeNotification);
          AppLogsUtils.instance.writeLogs(e, func: "${message.data} getInitialMessage");
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onRefresh() async{
    handleFnHome();
    fetchDataNews();
    fetchAdsData();
    appController.fetchDBActConfig().then((value) {
      LocalizationService.init();
    });
  }


  Future<void> fetchDataNews() async {
    var result = await appProvider.getNewsData();
    if (result.statusCode == 0) {
      listData.value = result.data;
    }
  }

//assetImage: "",label: "Scanner",
  void handleFnHome() async {
    var listPer = await permissionDBLocal.findAllPermission();
    if (listPer.isNotEmpty) {
      listHomeFnData.value = ErpCore.getFunctionByPer(listPer);
    }
  }

  Future<void> onPressERPFunction(HomeFunctionItemModel item) async{
    Map<String, String> param ={};
    if(item.encode == "WEBVIEW_TRAINING"){
      String base64 = await getEncodeTraining(userProfle: appController.userProfle.value);
      String url = "${AppConfig.getTraineeWebviewURL}/login/?appShare=$base64";
      param = {
        "pageName":"Đào tạo",
        "url": url
      };
    }
    PreferenceUtility.saveString(AppKey.routesKey, item.code);
    Get.toNamed(item.routerName,arguments: param);
  }

  Future<void> fetchAdsData() async {
    isLoading.value = true;
    var result = await appProvider.getListAds(screenID: "HOME_SCREEN", position: "HOME_TOP");
    isLoading.value = false;
    if (result.statusCode == 0) {
      listCarrousel.value = result.data;
    } else {
      AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
    }
  }

  // Future<void> registerOneOffTask() async {
  //   try {
  //     if (PermisstionUtils().checkPermisstion("PrFormActivation_AppActivation")) {
  //       BackgroundServiceAsyncTask.initialize(isInDebugMode: true);
  //       BackgroundServiceAsyncTask.registerOneOffTask();
  //     }
  //   } catch (ex) {}
  // }

}
