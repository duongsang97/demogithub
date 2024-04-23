import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsFeedHeaderElement extends StatefulWidget {
  const NewsFeedHeaderElement({ Key? key }) : super(key: key);

  @override
  State<NewsFeedHeaderElement> createState() => _NewsFeedHeaderElementState();
}

class _NewsFeedHeaderElementState extends State<NewsFeedHeaderElement> {
  final AppController appController = Get.find();
  late Size size;
  double topPadding = 0.0;
  @override
  Widget build(BuildContext context) {
    topPadding = MediaQuery.of(context).padding.top;
    size = MediaQuery.of(context).size;
    return Container(
      height: topPadding+60,
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/background/header_erp_background.png")
        )
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container( 
        padding: EdgeInsets.only(top: topPadding),
        child: Row(
          children: [
            Expanded(child: Text("Bảng tin",
              textAlign: TextAlign.left,
              style: TextStyle(
              fontSize: 19,fontWeight: FontWeight.bold,color: AppColor.grey
            ),),flex: 3,),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.search,size: 28,color: AppColor.grey,)
                ],
              ),
            flex: 1,),

          ],
        ),
      )
    );
  }
}