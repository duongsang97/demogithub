import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/loading/datas/loadingType.data.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/components/loading/models/loadingConfig.model.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/localizationService.utils.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/overlay/overlay.utils.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erpcore/erpCore.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App>{
  final String keyAppDate = "appOFFDate";
  @override
  void initState() {
    Get.put(AppController());
    
    LocalizationService.init();
    LoadingComponent.config = LoadingConfigModel(
      image: "assets/images/logos/acacy_blue.png",
      dismissible: true,
      size: const Size(80,80),
      overlayType: OverlayType.CENTER,
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      FirebaseMessaging.instance.getToken().then((value){
        if(value != null){
          PreferenceUtility.saveString(AppKey.keyFcmToken, value);
        }
      });
    });
    OverlayUtils.pushChild([
      AlertControl.init(),
      LoadingComponent.init()
    ]);
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState: $state');
    // Handle different lifecycle states as needed
    switch (state) {
      case AppLifecycleState.resumed:
        var oldDate = PreferenceUtility.getString(keyAppDate);
        if(oldDate.isNotEmpty){
          try{
            var dataNow = DateTime.now();
            var oldDateTime = DateTime.parse(oldDate);
            if(DateTimeUtils.compareTo(dataNow, oldDateTime) != 0){
            }
          }
          catch(ex){
            AppLogsUtils.instance.writeLogs(ex,func: "AppLifecycleState.resumed didChangeAppLifecycleState");
          }
        }
        printInfo(info: 'App is in the foreground');
        break;
      case AppLifecycleState.inactive:
        // App is in an inactive state (possibly transitioning between foreground and background)
        printInfo(info: 'App is in an inactive state');
        break;
      case AppLifecycleState.paused:
        PreferenceUtility.saveString(keyAppDate,DateTime.now().toString());
        printInfo(info: 'App is in the background');
        break;
      case AppLifecycleState.detached:
        // App is detached (not running)
        printInfo(info: 'App is detached');
        break;
      case AppLifecycleState.hidden:
        printInfo(info: 'App is hidden');
        break;
    }
  }
  // AlertControl.init(builder: ((context, child){
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
  //         child: child?? const SizedBox(),
  //       );
  //     }))
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: OverlayUtils.init(builder: (context, child){
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child?? const SizedBox(),
        );
      }),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.beVietnamPro().fontFamily
      ),
      darkTheme: ThemeData.dark(),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
      initialRoute: AppRouter.welcome,
      getPages: ErpCore.routers,
      //initialBinding: AppBinding(),
    );
  }
}


