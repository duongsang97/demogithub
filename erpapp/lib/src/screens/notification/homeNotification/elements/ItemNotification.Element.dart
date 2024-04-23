import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erp/src/screens/notification/homeNotification/homeNotification.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemNotificationElement extends StatefulWidget {
  ItemNotificationElement({ Key? key,required this.item,required this.onPress, this.isFinal = false}) : super(key: key);
  final NotificationInfoModel item;
  final bool isFinal;
  final Function(NotificationInfoModel) onPress;
  @override
  State<ItemNotificationElement> createState() => _ItemNotificationElementState();
}

class _ItemNotificationElementState extends State<ItemNotificationElement> {
  late Size size;
  final HomeNotificationController homeNotificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress(widget.item);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              color: AppColor.whiteColor,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 1,
              //     blurRadius: 3,
              //     offset: Offset(0, 1),
              //   ),
              // ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBoxIcon(),
                SizedBox(width: 5.0,),
                Expanded(
                  child: _buildBoxContent()
                ),
              ],
            ),
          ),
          Visibility(
            visible: !widget.isFinal,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                height: 1,
                color: AppColor.cottonSeed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxIcon(){
    return Container(
      alignment: Alignment.topCenter,
      width: 50,
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: AppColor.azureColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 2, color: AppColor.brightBlue),
        ),
        child: Image.asset("assets/images/icons/blue_bell.png",height: 20,width: 20, color: AppColor.brightBlue)
      ),
    );
  }

  Widget _buildBoxContent(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(widget.item.title??"Không có tiêu đề",style: TextStyle(
                  color: AppColor.grey,fontSize: 10, fontWeight: FontWeight.w700
                )),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(right: 5.0),
              child: Text(widget.item.createHour ?? "",style: TextStyle(
                color: AppColor.cottonSeed,fontSize: 10,
              ),),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Text(widget.item.description??"",
                overflow: TextOverflow.ellipsis,maxLines: 3,
                style: TextStyle(
                  color: AppColor.grey,fontSize: 12, fontWeight: FontWeight.w700
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(right: 5.0),
              child: Text(widget.item.createDay ?? "",style: TextStyle(
                color: AppColor.cottonSeed,fontSize: 10, fontWeight: FontWeight.w700
              ),),
            ),
          ],
        ),
      ],
    );
  }
}