import 'package:flutter/material.dart';

import 'circleAvatar.Element.dart';

class AvatarChatInfoElement extends StatefulWidget {
  const AvatarChatInfoElement({ Key? key }) : super(key: key);

  @override
  State<AvatarChatInfoElement> createState() => _AvatarChatInfoElementState();
}

class _AvatarChatInfoElementState extends State<AvatarChatInfoElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatarElement(isOnline: true,),
          SizedBox(height: 5,),
          Text("Dương Tấn Sang",textAlign: TextAlign.center,maxLines: 2,),
        ],
      ),
    );
  }
}