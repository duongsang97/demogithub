import 'package:erpcore/models/apps/chats/messageSending.Model.dart';
import 'package:erpcore/models/apps/chats/userChatInfo.Model.dart';
import 'package:erpcore/providers/erp/chat.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erp/src/screens/main/main.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class InboxController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isPageLoading = false.obs;
  RxList<MessageSendingModel> dataMessage = RxList.empty(growable: true);
  late ChatProvider chatProvider;
  MainController mainController = Get.find();
  Rx<UserChatInfoModel> chatObject = Rx<UserChatInfoModel>(UserChatInfoModel());
  AppController appController = Get.find();
  TextEditingController txtMessageInputController = TextEditingController();
  RxBool moreLines = false.obs;
  double inputBoxHeight = 30; 
  GlobalKey inputKey =GlobalKey();
  @override
  void onInit() {
    chatProvider = ChatProvider();
    mainController.messageData.listen((p0) {listenAndHandleMessage(p0);});
    chatObject.value = Get.arguments["data"];
    super.onInit();
  }

  @override
  void onReady() {
    if(inputKey.currentContext != null){
      final RenderBox renderBox = inputKey.currentContext!.findRenderObject() as RenderBox;
      inputBoxHeight = renderBox.size.height;
    }
    fetchDataMessage();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void checkTextOverflow() {
    final RenderBox renderBox =  inputKey.currentContext!.findRenderObject() as RenderBox;
    if(renderBox.size.height > inputBoxHeight){
      moreLines.value = true;
    }
    else{
      moreLines.value = false;
    }
  }


  bool get isSend => txtMessageInputController.text.isNotEmpty;

  String getNickName(){
    String result ="";
    try{
      if(chatObject.value.nickname != null){
        result =chatObject.value.nickname??"";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getNickName objectInbox.Element");
    }
    return result;
  }

  void listenAndHandleMessage(List<MessageSendingModel> data){
    if(data != null && data.isNotEmpty){
      for(var item in data){
        if(item.sender == chatObject.value.username){
           dataMessage.insert(0,item);
        }
      }
    }
  }

  Future<void> fetchDataMessage() async{
    isPageLoading.value= true;
    var result = await chatProvider.getMessageData(receiver: chatObject.value.username,sender: appController.userProfle.value.userName);
    if(result.statusCode == 0){
      dataMessage.value = result.data.reversed.toList();
    }
    isPageLoading.value = false;
  }

  Future<void> sendMessage() async{
    if(!isLoading.value && txtMessageInputController.text.isNotEmpty){
      isLoading.value= true;
      var result = await chatProvider.sendMessage(receiver: chatObject.value.username,content: txtMessageInputController.text,receiverChanel:getChatChannelByServer());
      isLoading.value= false;
      if(result.statusCode == 0){
        var temp = MessageSendingModel(
          content: txtMessageInputController.text,
          type: 1,
          sender: appController.userProfle.value.userName,
          receiver:chatObject.value.username
        );
        dataMessage.insert(0,temp);
        txtMessageInputController.clear();
      }
    }
  }


}