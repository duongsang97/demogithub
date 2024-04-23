import 'package:erp/src/screens/chats/listChat/listChat.Controller.dart';
import 'package:get/instance_manager.dart';
class ListChatBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ListChatController());
  }

}