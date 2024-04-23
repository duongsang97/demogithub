import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ItemStatusVerifyElement extends StatefulWidget {
  const ItemStatusVerifyElement({super.key,required this.item,required this.onPress});
  final PrCodeName item;
  final Function(PrCodeName, bool) onPress;
  @override
  State<ItemStatusVerifyElement> createState() => _ItemStatusVerifyElementState();
}

class _ItemStatusVerifyElementState extends State<ItemStatusVerifyElement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlutterSwitch (
          showOnOff: true,
          value: widget.item.value,
          activeText: "Bật",
          inactiveText: "Tắt",
          inactiveColor: AppColor.brightRed,
          activeColor: AppColor.greenMonth,
          activeTextFontWeight: FontWeight.w700,
          inactiveTextFontWeight: FontWeight.w700,
          valueFontSize: 12,
          height: 25,
          width: 60,
          toggleSize: 20,
          onToggle: (val) {
            widget.onPress(widget.item, val);
          },
        ),
        SizedBox(height: 10.0,),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(widget.item.name??"",style: const TextStyle(color: AppColor.greenMonth,fontSize: 14,fontWeight: FontWeight.bold),)
        ),
        Stack(
          children: [
            GestureDetector(
              // onTap: (){
              //   widget.onPress(widget.item,value);
              // },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(widget.item.codeDisplay??"assets/images/face-recognition.png",width: Get.size.width/4,),
                )
              ),
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child:_buildStatus()
            // ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatus(){
    if(widget.item.value == true){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset("assets/images/check-mark.png",width: 15,height: 15,),
            const SizedBox(width: 5,),
            const Text("Đã xác minh",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
          ],
        ),
      );
    }
    else{
      return const SizedBox();
    }
  }
}