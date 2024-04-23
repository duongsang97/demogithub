import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:erpcore/utility/localStorage/systemConfig.utils.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/value/st_en_us.dart';
import 'package:erpcore/utility/value/st_vi_vn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {

// locale sẽ được get mỗi khi mới mở app (phụ thuộc vào locale hệ thống hoặc bạn có thể cache lại locale mà người dùng đã setting và set nó ở đây)
  static final locale = _getLocaleFromLanguage();

// fallbackLocale là locale default nếu locale được set không nằm trong những Locale support
  static const fallbackLocale =  Locale('vi', 'VN');
  static Map<String, String> enSrc = {};
  static Map<String, String> viSrc = {};
// language code của những locale được support
  static final langCodes = [
    'en',
    'vi',
  ];

// các Locale được support
  static const locales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];


// cái này là Map các language được support đi kèm với mã code của lang đó: cái này dùng để đổ data vào Dropdownbutton và set language mà không cần quan tâm tới language của hệ thống
  static final langs = LinkedHashMap.from({
    'en': 'English',
    'vi': 'Tiếng Việt',
  });

// function change language nếu bạn không muốn phụ thuộc vào ngôn ngữ hệ thống
  static void changeLocale(String langCode) {
    final locale = _getLocaleFromLanguage(langCode: langCode);
    Get.forceAppUpdate();
    Get.updateLocale(locale);
  }

  void setTranslations(Map<String, String> newTranslations,{String? langCode}) {
    try {
      if (newTranslations.isNotEmpty) {
        final locale = _getLocaleFromLanguage(langCode: langCode);
        String key = "";
        Map<String,String> src = {};
        if (locale.languageCode == "vi") {
          key = keys.keys.last;
          src = vi;
          for (var newValue in newTranslations.entries) {
            if (vi.containsKey(newValue.key)) {
              vi.update(newValue.key, (value) => newValue.value);
            } else {
              vi[newValue.key] = newValue.value;
            }
          }
        } else {
          key = keys.keys.first;
          src = en;
          for (var newValue in newTranslations.entries) {
            if (en.containsKey(newValue.key)) {
              en.update(newValue.key, (value) => newValue.value);
            } else {
              en[newValue.key] = newValue.value;
            }
          }
        }
        
        Map<String, Map<String,String>> trans = {
          key: src,
        };
        Get.appendTranslations(trans);
        Get.appUpdate();
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "setTranslations");
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en,
    'vi_VN': vi,
  };

  static Locale _getLocaleFromLanguage({String? langCode}) {
    var lang = langCode ?? Get.deviceLocale?.languageCode??'';
    for (int i = 0; i < langCodes.length; i++) {
      if (lang == langCodes[i]) return locales[i];
    }
    return Get.locale!;
  }
  static void init() async{
    var localizationVn = await SystemConfigUtils.getConfigByKey("localization_vn");
    var localizationEn = await SystemConfigUtils.getConfigByKey("localization_en");
    if(localizationVn.isNotEmpty && File(Uri.parse(localizationVn).path).existsSync()){
      String txt = await SystemConfigUtils.readTXTFile(localizationVn);
      Map<String, dynamic> jsonMap = jsonDecode(txt);
      viSrc = Map<String, String>.from(jsonMap.map((key, value) => MapEntry<String, String>(key, value.toString())));
    }
    if(localizationEn.isNotEmpty && File(Uri.parse(localizationEn).path).existsSync()){
      String txt = await SystemConfigUtils.readTXTFile(localizationEn);
      Map<String, dynamic> jsonMap = jsonDecode(txt);
      enSrc = Map<String, String>.from(jsonMap.map((key, value) => MapEntry<String, String>(key, value.toString())));
    }
    LocalizationService().setTranslations(viSrc, langCode: "vi");
    LocalizationService().setTranslations(enSrc, langCode: "en");
    changeLocale("vi");
  }
}