import 'dart:convert';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:encrypt/encrypt.dart';
import 'localStorage/permission.dbLocal.dart';

class PermisstionUtils{
  static List<String> listPermission = List<String>.empty(growable: true);
  PermissionDBLocal permissionDBLocal = PermissionDBLocal();
  PermisstionUtils();
  static const keySRC = '8RTEplWw6LKyEBXhwMHJ9JCOBFLYCdwD';
  void init()async{
    listPermission = await permissionDBLocal.findAllPermission();
  }

  static Future<Key> get getKey async {
    String key = PreferenceUtility.getString("PERMISSION_KEY");
    if(key.isEmpty){
      key = Key.fromUtf8(keySRC).base64;
      await PreferenceUtility.saveString("PERMISSION_KEY",key);
    }
    return Key.fromBase64(key);
  }
  static Future<IV> get getIV async {
    String iv = PreferenceUtility.getString("PERMISSION_IV");
    if(iv.isEmpty){
      iv = IV.fromLength(16).base64;
      await PreferenceUtility.saveString("PERMISSION_IV",iv);
    }
    return IV.fromBase64(iv);
  }
  List<String> getListPermission(String code) {
    List<String> result = List.empty(growable: true);
    try {
      if (code.contains("||")) {
        result = code.split("||");
      } else if (code.contains("|")) {
        result = code.split("|");
      } else {
        result.add(code);
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "FucntionERPData getListPermission");
    }
    return result;
  }

  bool permissionCompare(List<String> listA,List<String> src, {bool type = true}){
    bool result = false;
    try{
      if(listA.isNotEmpty && src.isNotEmpty){
        var length = listA.where((element) => src.contains(element)).length;
        if(listA.length == length && type){
          result = true;
        } else if ( length > 0 && !type) {
          result = true;
        }
      }

    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "permissionCompare FucntionERPData");
    }
    return result;
  }

  bool getTypePermissionLogic(String perm) {
    bool result = true;
    try {
      if ((perm).contains("||")) {
        result = false;
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "FucntionERPData getTypePermissionLogic");
    }
    return result;
  }

  bool checkPermisstion(String permission){
    bool result = false;
    try{
      var perCheck = getListPermission(permission);
      if(permissionCompare(perCheck,listPermission,type: getTypePermissionLogic(permission))){
        result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "checkPermisstion");
    }
    return result;
  }

  static Future<List<PrCodeName>> checkDevicePermissionAllow(List<PrCodeName> data) async{
    List<PrCodeName> result = List<PrCodeName>.empty(growable: true);
    for(var item in data){
      for(Permission per in item.value){
        PermissionStatus status = await per.status;
        if(status.isDenied){
          int index = result.indexWhere((element) => element.name == item.name);
          if(index <0){
            result.add(item);
          }
        }
      }
    }
    return result;
  }

  static Future<bool> requireDevicePermission(Permission permission) async {
    try {
      var status = await permission.status;
      if (status.isDenied) {
        var result = await permission.request();
        if (result.isDenied) {
          return false;
        }
        return true;
      }
      return true;
    } catch (ex) {
      //AppLogsUtils.instance.writeLogs(ex,func: "requirePermission app.Utility");
      return false;
    }
  }

  static bool get loginInfoExits{
    return PreferenceUtility.getString(AppKey.loginCryptInfoKey).isNotEmpty?true:false;
  }
  static Future<void> emptyLoginInfo() async{
    await PreferenceUtility.removeByKey(AppKey.loginCryptInfoKey);
    await PreferenceUtility.removeByKey("PERMISSION_KEY");
    await PreferenceUtility.removeByKey("PERMISSION_IV");
  }
  static Future<bool> encryptLoginInfo(String username,String password) async{
    bool result = false;
    try{
      final encrypter = Encrypter(AES(await getKey));
      IV  iv= await getIV;
      var srcData = {"username":username,"password":password};
      final jsonEncoded = jsonEncode(srcData);
      final encrypted = encrypter.encrypt(jsonEncoded, iv: iv);
      result = await PreferenceUtility.saveString(AppKey.loginCryptInfoKey, encrypted.base64);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "setLoginInfo PermisstionUtils");
    }
    return result;
  }

  static Future<Map<String,dynamic>?> decryptLoginInfo() async{
    Map<String,dynamic>? result;
    try{
      final encrypter = Encrypter(AES(await getKey));
      IV  iv= await getIV;
      String encryptData = PreferenceUtility.getString(AppKey.loginCryptInfoKey);
      final decrypted = encrypter.decrypt64(encryptData,iv: iv);
      result = jsonDecode(decrypted);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "decryptLoginInfo PermisstionUtils");
    }
    return result;
  }
}