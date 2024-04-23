import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:erpcore/configs/appStyle.Config.dart';

class HeaderElement extends StatelessWidget {
  const HeaderElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height*.15,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top+10,
      ),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/background/header_erp_background.png")
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child:  Icon(Icons.arrow_back_ios,size: 25,color: AppColor.whiteColor),
                    ),
                    const SizedBox(width: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Chữ ký số",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.whiteColor),),
                    ),
                  ],
                )
              ),
            ),
            ],
          ),
        ],
      ),
    );
  }
}