import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/iconApp.Data.dart';
import 'package:erp/src/screens/notification/homeNotification/homeNotification.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItemNotificationElement extends StatefulWidget {
  ItemNotificationElement({ Key? key, this.seen = 0}) : super(key: key);
  // NotificationModel dataNotification;
  int seen;
  @override
  State<ItemNotificationElement> createState() => _ItemNotificationElementState();
}

class _ItemNotificationElementState extends State<ItemNotificationElement> {
  late Size size;
  final HomeNotificationController homeNotificationController = Get.find();
  bool getSeenStatus(){
    bool result = false;
    try{
      if( widget.seen ==1){
        return true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getSeenStatus ItemMyTask.Element");
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                _buildIcon(),
                SizedBox(width: 5,),
                Flexible(
                  child: _buildDescription(),
                ),
              ],
            ),
            _buildTime(),
            SizedBox(height: 4,),
            Divider(height: 0.5,color: AppColor.grey,thickness: 0.5,)
          ],
        ),
      ),
    );
  }
  Widget _buildIcon(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child:  Image.asset(AppIcons.icon_itemnotification,height: 30,width:30),
    ); 
  }
  Widget _buildDescription(){
    return Padding(
      padding: const EdgeInsets.only(right:30.0),
      child: RichText(
        text: TextSpan(
          text: 'Title Notification',
          style: !getSeenStatus()?TextStyle(color: AppColor.grey,fontSize: 14,fontWeight: FontWeight.bold):TextStyle(color: AppColor.grey,fontSize: 14),
          children: <TextSpan>[
            TextSpan(text: ' '),
            TextSpan(text: "nội dung ngắn được hiển thị ở đâyNội dung ngắn được hiển thị ở đây",style: !getSeenStatus()?TextStyle(height: 1.3,color: AppColor.grey,fontSize: 13,fontWeight: FontWeight.w500):TextStyle(fontSize: 13,color: AppColor.grey))
          ]
        ),
      ),
    );
  }
  Widget _buildTime(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: Text(DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),style: !getSeenStatus()?TextStyle(color: AppColor.grey,fontSize: 10,fontWeight: FontWeight.bold):TextStyle(fontSize: 10)),
        )
      ],
    );
  }
}