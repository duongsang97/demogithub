import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/newsFeed/elements/newsFeedAvatar.Element.dart';
import 'package:flutter/material.dart';

class StoriesItemElement extends StatefulWidget {
  const StoriesItemElement({ Key? key }) : super(key: key);

  @override
  State<StoriesItemElement> createState() => _StoriesItemElementState();
}

class _StoriesItemElementState extends State<StoriesItemElement> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: 180,
          width: size.width/3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: NetworkImage("https://kenh14cdn.com/thumb_w/660/2020/5/28/0-1590653959375414280410.jpg"),
              fit: BoxFit.cover
            )
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: NewsFeedAvatarElement(
            size: 50,
            highlight: true,
          )
        ),
        Positioned(
          bottom: 10,
          left: 5,
          right: 5,
          child: Text("Dương Sang",textAlign: TextAlign.center,maxLines: 2,style: TextStyle(
            color: AppColor.whiteColor, fontWeight: FontWeight.bold
          ),)
        )
      ],
    );
  }
}