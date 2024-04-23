library erpcore;

import 'package:erpcore/datas/functionERP.data.dart';
import 'package:erpcore/models/apps/homeFunctionItem.Model.dart';
import 'package:erpcore/routers/pages.Router.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:get/get.dart';

import 'models/apps/prCodeName.Model.dart';
import 'utility/localStorage/dbConnect.Utility.dart';
export 'erpCore.dart';

class ErpCore {
  static void routerInclude(List<PrCodeName> router) {
    AppPages.include(router);
  }
  static void functionInclude(List<PrCodeName> function){
    FucntionERPData.include(function);
  }
  static List<HomeFunctionItemModel> getFunctionByPer(List<String> perData){
    return FucntionERPData.getFunction(perData);
  }
  static void dbInclude(List<PrCodeName> dbs){
    DBConnectUility.instance.initDatabases(dbs);
  }

  static List<GetPage> get routers => AppPages.routers;
  static Future program() async {
    await PreferenceUtility.initStates();
  }
}
