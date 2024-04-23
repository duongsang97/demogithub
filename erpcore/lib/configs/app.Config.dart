import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/datas/appServiceAPI.Data.dart';
import 'package:flutter/material.dart';

import '../utility/logs/appLogs.Utility.dart';

class AppConfig {
  static const String appName = "ERP Mobile";
  static const String logoAnlene = "assets/images/logos/logo_anlene.png"; // logo anlene
  static const String logoHeineken = "assets/images/logos/heineken-logo-white.png"; // logo anlene
  static const String logoPepsi = "assets/images/logos/pepsi-logo.png"; // logo pepsi
  static const String logoERP = "assets/images/logos/logo_erp.png"; // logo erp
  static const String logoAbbott = "assets/images/logos/logo_abbott.png"; // logo abbott
  static const String logoAcacy = "assets/images/logos/logo_acacy.png"; // logo acacy
  static const String logoSpiral = "assets/images/logos/logo_spiral.png"; // logo spiral
  static const String logoMars = "assets/images/logos/logo_mars.png"; // logo mars
 
  //static final String logoWelcome= "assets/images/logos/acacy-logo.png";
  static const String backgroundWelcome = "assets/images/background/sky_background.jpg";
  static const String msgError = "Có lỗi xảy ra, vui lòng thử lại!";
  static const String appPackageName = PackageName.acacyPackage; // package name
  static const Color appColor = AppColor.acacyColor;
  static const bool appbarSky = true;
  static const bool OTAUpdate = false;
  ////Color(0XFFfaf5e6); mars color //pepsi color  //Color(0XFF007F2D); // heineken color;  ; 0XFF0095DA // Abbott
  ///
  static String get getTraineeWebviewURL {
    String result = AppServiceAPIData.traineeAcacy;
    try{ 
      if(appPackageName.contains('spiral')){
        result = AppServiceAPIData.traineeSpiral;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getTraineeWebviewURL",);
    }
    return result;
  }
}

class AppData {
  static final List<String> listCodeCMND = [
    "DF7"
  ]; // danh sách mã code không được xóa (function profile )
  static const String logoWelcome = "LogoImage"; // logo mars
}