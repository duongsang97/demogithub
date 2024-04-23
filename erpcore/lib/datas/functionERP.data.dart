import 'package:erpcore/models/apps/homeFunctionItem.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import '../routers/app.Router.dart';
import '../utility/app.Utility.dart';
import 'iconApp.Data.dart';

class FucntionERPData{
  static var list = <PrCodeName>[
    PrCodeName(
      code: "PrFormDefTnStudent", // || "hoặc" type = false,  | "và" type = true 
      name: "WEBVIEW_TRAINING",
      value: HomeFunctionItemModel(code: generateKeyCode(),name: "Đào tạo",routerName: AppRouter.webviewPage,assetImage: AppIcons.iconpresentation,encode: "WEBVIEW_TRAINING")
    ),
  ];
  static List<HomeFunctionItemModel> getFunction(List<String> perData){
    List<HomeFunctionItemModel> result = List<HomeFunctionItemModel>.empty(growable: true);
    try{
      var temp = list.where((element) => permissionCompare(getListPermission(element.code ?? ""),perData, type: getTypePermissionLogic(element.code ?? ""))).toList();
      result = temp.map<HomeFunctionItemModel>((e) => e.value).toList();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getFunction FucntionERPData");
    }
    return result;
  }

  static bool getTypePermissionLogic(String perm) {
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

  static List<String> getListPermission(String code) {
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

  static bool permissionCompare(List<String> listA,List<String> src, {bool type = true}){
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
  static void include(List<PrCodeName> functions){
    try{
      for(var item in functions){
        if(!PrCodeName.isEmpty(item) && item.code!.isNotEmpty && item.value != null){
          // int indexTemp = list.indexWhere((element) => element.code == item.code);
          // if(indexTemp <0){
          //   list.add(item);
          // }
          list.add(item);
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "FucntionERPData include");
    }
  }
}