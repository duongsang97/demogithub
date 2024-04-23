import 'package:flutter/material.dart';

import 'newsFeedAvatar.Element.dart';

class BoxWriteStatusElement extends StatefulWidget {
  const BoxWriteStatusElement({ Key? key }) : super(key: key);

  @override
  State<BoxWriteStatusElement> createState() => _BoxWriteStatusElementState();
}

class _BoxWriteStatusElementState extends State<BoxWriteStatusElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          NewsFeedAvatarElement(
            size: 60,
          ),
          SizedBox(width: 2,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(width: 0.5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text("Lan tỏa điều tích cực")
              ],),
            )
          )
        ],
      ),
    );
  }
}