import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:get/get.dart';

class AppPages {
  static var list = <PrCodeName>[];
  static List<GetPage> get routers{
    List<GetPage> result = [];
    try{
      result = list.map<GetPage>((e) => e.value).toList();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "AppPages get_routers");
    }
    return result;
  }
  static void include(List<PrCodeName> routers){
    try{
      for(var item in routers){
        if(!PrCodeName.isEmpty(item) && item.code!.isNotEmpty && item.value != null){
          int indexTemp = list.indexWhere((element) => element.code == item.code);
          if(indexTemp <0){
            list.add(item);
          }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "AppPages include");
    }
  }
}
