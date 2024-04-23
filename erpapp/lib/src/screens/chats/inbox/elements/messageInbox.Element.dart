import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/chats/messageSending.Model.dart';
import 'package:erpcore/models/apps/chats/userChatInfo.Model.dart';
import 'package:erp/src/screens/chats/listChat/elements/circleAvatar.Element.dart';
import 'package:flutter/material.dart';

class MessageInboxElement extends StatefulWidget {
  const MessageInboxElement({ Key? key,required this.data,this.showAvatar=false,required this.userChatInfo}) : super(key: key);
  final MessageSendingModel data;
  final UserChatInfoModel userChatInfo;
  final showAvatar;
  @override
  State<MessageInboxElement> createState() => _MessageInboxElementState();
}

class _MessageInboxElementState extends State<MessageInboxElement> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Align(
      alignment: ( widget.userChatInfo.username == widget.data.sender)?Alignment.centerLeft:Alignment.centerRight,
      child: (widget.userChatInfo.username == widget.data.sender)?_buildMessage():_buildSendMessage(),
    );
  }

  Widget _buildMessage(){
    return Container(
      constraints: BoxConstraints(minWidth: 50, maxWidth: size.width*.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: widget.showAvatar,
            child: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: CircleAvatarElement(
                size: 30,
                showOnlineStatus: false,
              ),
            )
          ),
          Container(
            constraints: BoxConstraints(maxWidth: size.width*.9),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColor.azureColor.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
                )
              ),
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            child: Text("${widget.data.content}"),
          )
        ],
      ),
    );
  }
  Widget _buildSendMessage(){
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.azureColor.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
        color: AppColor.brightBlue,
        borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(10.0),
      )
      ),
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Text(widget.data.content??"",style: const TextStyle(color: AppColor.whiteColor),),
    );
  }
}