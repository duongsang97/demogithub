import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class NewsFeedAvatarElement extends StatefulWidget {
  const NewsFeedAvatarElement({ Key? key,this.size=60,this.highlight=false}) : super(key: key);
  final double size;
  final bool highlight;
  @override
  State<NewsFeedAvatarElement> createState() => _NewsFeedAvatarElementState();
}

class _NewsFeedAvatarElementState extends State<NewsFeedAvatarElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width:  widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.highlight?AppColor.jadeColor:null
      ),
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.brightRed,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage("https://haycafe.vn/wp-content/uploads/2022/02/Anh-gai-xinh-Viet-Nam.jpg"),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}