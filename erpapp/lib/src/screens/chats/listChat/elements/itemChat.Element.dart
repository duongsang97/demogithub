import 'package:erp/src/screens/chats/listChat/listChat.Controller.dart';
import 'package:erpcore/models/apps/chats/userChatInfo.Model.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erp/src/screens/chats/listChat/elements/circleAvatar.Element.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class ItemChatElement extends StatefulWidget {
  const ItemChatElement({ Key? key,required this.data}) : super(key: key);
  final UserChatInfoModel data;
  @override
  State<ItemChatElement> createState() => _ItemChatElementState();
}

class _ItemChatElementState extends State<ItemChatElement> {
  final ListChatController listChatController = Get.find();
  String getNickName(){
    String result ="";
    try{
      if(widget.data.nickname != null){
        result =widget.data.nickname??"";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getNickName itemChat.Element");
    }
    return result;
  }
  bool getOnlineStatus(){
    bool result =false;
    try{
      if(widget.data.online != null){
        result = widget.data.online??false;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getOnlineStatus itemChat.Element");
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await Get.toNamed(AppRouter.inbox,arguments: {"data":widget.data});
        listChatController.fetchUserChat(loading: false);

      },
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: const ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatarElement(
              isOnline: getOnlineStatus(),
              size: 50,
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getNickName(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontWeight: widget.data.seen==0?FontWeight.bold:FontWeight.normal),),
                  Text("${widget.data.content}",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                    fontSize: 12,fontWeight: widget.data.seen==0?FontWeight.bold:FontWeight.normal
                  ),)
                ],
              ),
            ),
            Text(widget.data.lastSendTime != null?DateTimeUtils.formatTimestamp(widget.data.lastSendTime!):"",style: TextStyle(fontSize: 11,fontWeight: widget.data.seen==0?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}