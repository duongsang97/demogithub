import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarCustomManagement extends StatelessWidget implements PreferredSizeWidget {
  VoidCallback onTap;
  Widget title;
  final double height;
  Widget label;
  
  AppBarCustomManagement({super.key,required this.onTap,this.height = kToolbarHeight,required this.label,required this.title});
  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double topPadding = MediaQuery.of(context).padding.top;
    return SizedBox(
        height: preferredSize.height,
        child: Stack(
          children: [
            Column(
            children: [
              Container(
                height: preferredSize.height*0.8,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: AppColor.brightBlue,
                  image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background/header_erp_background.png")
                ),
                  borderRadius:  BorderRadius.vertical(
                    bottom:  Radius.elliptical(30,3)
                  )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  SizedBox(height: topPadding+10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColor.whiteColor,
                          size: 25,
                          ),
                        ),
                        label,
                        GestureDetector(
                          onTap: onTap
                          ,
                          child: const Icon(
                            Icons.filter_alt,
                            color: AppColor.whiteColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 20)
                      ],
                    ),
                  ],
                ),
              ),
            ]
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: preferredSize.height*0.6),
              child: Container(
                height: preferredSize.height*0.5,
                width: size.width*0.85,
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                   Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: title
              ),
            ),
          ),
          ],
        ),
      );
  }
}