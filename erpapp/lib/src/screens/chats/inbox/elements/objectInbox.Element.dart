import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/chats/userChatInfo.Model.dart';
import 'package:erp/src/screens/chats/listChat/elements/circleAvatar.Element.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class ObjectInboxElement extends StatefulWidget {
  const ObjectInboxElement({ Key? key,required this.object}) : super(key: key);
  final UserChatInfoModel object;
  @override
  State<ObjectInboxElement> createState() => _ObjectInboxElementState();
}

class _ObjectInboxElementState extends State<ObjectInboxElement> {

  String getNickName(){
    String result ="";
    try{
      if(widget.object != null && widget.object.nickname != null){
        result =widget.object.nickname??"";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getNickName objectInbox.Element");
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const CircleAvatarElement(size: 45,showOnlineStatus: false,),
          const SizedBox(width: 10,),
          Expanded(
            flex: 2,
            child: Text(getNickName(),maxLines: 1,overflow: TextOverflow.clip,style: const TextStyle(
              color: AppColor.whiteColor,fontSize: 15
            ),),
          ),
          const SizedBox(width: 20,),
          GestureDetector(
            child: Image.asset("assets/images/icons/phone_call.png",height: 25,color: AppColor.azureColor,),
          ),
          const SizedBox(width: 20,),
          GestureDetector(
            child: Image.asset("assets/images/icons/video_call.png",height: 30,color:  AppColor.azureColor,),
          )
        ],
      ),
    );
  }
}