import 'package:erp/src/screens/chats/inbox/inbox.Controller.dart';
import 'package:get/get.dart';

class InboxBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InboxController());
  }
  
}