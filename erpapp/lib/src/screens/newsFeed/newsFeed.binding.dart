import 'package:erp/src/screens/newsFeed/newsFeed.Controller.dart';
import 'package:get/instance_manager.dart';

class NewsFeedBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NewsFeedController());
  }
  
}