import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class ItemSocialElement extends StatefulWidget {
  const ItemSocialElement({super.key,this.type = SocialType.ACCOUNT});
  final SocialType type;
  @override
  State<ItemSocialElement> createState() => _ItemSocialElementState();
}

class _ItemSocialElementState extends State<ItemSocialElement> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 0.5,color: getColorByType())
      ),
      child: getIconByType(),
    );
  }

  Widget getIconByType(){
    String assestLink = "assets/images/icons/";
    Widget result = Image.asset(assestLink+"default_avatar.png",width: 30,);
    try{
      if(widget.type == SocialType.GOOGLE){
        result = Image.asset(assestLink+"google.png",width: 30,);
      }
      else if(widget.type == SocialType.FACEBOOK){
        result = Image.asset(assestLink+"facebook.png",width: 30,);
      }
      else if(widget.type == SocialType.APPPLE){
        result = Image.asset(assestLink+"apple-logo.png",width: 30,);
      }
      else if(widget.type == SocialType.ZALO){
        result = Image.asset(assestLink+"zalo.png",width: 30,);
      }
      else if(widget.type == SocialType.LINKEDIN){
        result = Image.asset(assestLink+"linkedin.png",width: 30,);
      }
      else if(widget.type == SocialType.PHONE){
        result = Image.asset(assestLink+"telephone-call.png",width: 30,);
      }
      else if(widget.type == SocialType.ACCOUNT){
        result = Image.asset(assestLink+"default_avatar.png",width: 30,);
      }

    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getIconByType");
    }
    return result;
  }

  Color getColorByType(){
    Color result = AppColor.grey;
    try{
      if(widget.type == SocialType.GOOGLE){
        result = Color(0XFFDB4437);
      }
      else if(widget.type == SocialType.FACEBOOK){
        result = Color(0XFF4285F4);
      }
      else if(widget.type == SocialType.APPPLE){
        result = Color(0XFF666666);
      }
      else if(widget.type == SocialType.ZALO){
        result = AppColor.nearlyBlue;
      }
      else if(widget.type == SocialType.LINKEDIN){
        result = Color(0XFF8d6cab);
      }
      else if(widget.type == SocialType.PHONE){
        result = AppColor.brightBlue;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getColorByType");
    }
    return result;
  }
}

enum SocialType{
  FACEBOOK,
  GOOGLE,
  APPPLE,
  PHONE,
  ZALO,
  LINKEDIN,
  ACCOUNT
}