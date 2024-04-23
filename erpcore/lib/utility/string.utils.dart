import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class StringUtils {
  static bool isNullOrEmpty(String? value){
    bool result = false;
    try{
      if(value == null || value.isEmpty){
        result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "isNullOrEmpty StringUtils");
    }
    return result;
  }
  List<String> getPathList(String path){
    List<String> result = List<String>.empty(growable: true);
    try{
      result = path.split('/');
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getPathList");
    }
    return result;
  }
}