import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class HomeExtendItemComponent extends StatefulWidget {
  const HomeExtendItemComponent({ Key? key,this.callback,this.image,this.label}) : super(key: key);
  final String? label;
  final String? image;
  final VoidCallback? callback;
  @override
  State<HomeExtendItemComponent> createState() => _HomeExtendItemComponentState();
}

class _HomeExtendItemComponentState extends State<HomeExtendItemComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColor.azureColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            child: Center(child: Image.asset(widget.image??"assets/images/icons/resume.png",height: 35,width: 35,),)
          ),
          SizedBox(height: 5,),
          Text(widget.label??"",style: TextStyle(color: AppColor.grey),)
        ],
      ),
    );
  }
}