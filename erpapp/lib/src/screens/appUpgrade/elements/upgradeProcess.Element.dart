import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class UpgradeProcessElement extends StatefulWidget {
  const UpgradeProcessElement({ Key? key,}) : super(key: key);
  @override
  State<UpgradeProcessElement> createState() => _UpgradeProcessElementState();
}

class _UpgradeProcessElementState extends State<UpgradeProcessElement> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width*.8,
      height: size.height*.5,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(color: Colors.blue,),
          ),
          SizedBox(height: 20,),
          // Text((widget.processStatus != null)?widget.processStatus!.status.name:"",style: TextStyle(
          //   color: AppColor.jadeColor,fontSize: 16
          // ),)
        ],
      ),
    );
  }
}