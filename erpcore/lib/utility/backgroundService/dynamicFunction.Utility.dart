import 'package:flutter_js/flutter_js.dart';

class DynamicFunctionUtils {
  late JavascriptRuntime javascriptRuntime;
  DynamicFunctionUtils(){
    javascriptRuntime = instance;
  }
  JavascriptRuntime get instance {
    javascriptRuntime = getJavascriptRuntime();
    return javascriptRuntime;
  }
  
  
}