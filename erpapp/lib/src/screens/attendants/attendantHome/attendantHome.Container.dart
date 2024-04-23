
import 'package:erp/src/screens/attendants/attendantHome/elements/viewColumn.Component.dart';
import 'package:erpcore/components/calendar/calendarCutom.Component.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'attendantHome.Controller.dart';

class AttendantHomeScreen extends GetWidget<AttendantHomeControler>{
  final AttendantHomeControler attendantHomeControler = Get.find();
  @override
  Widget build(BuildContext context) {
    attendantHomeControler.context = context;
    return  SingleChildScrollView(
     scrollDirection: Axis.vertical,
      child: Column(
        children: [
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 2.0
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0), 
                child: ViewColumn(soluongngay: "26",text: "Công chuẩn",color: Colors.grey,)
              ),
              Padding(
                padding: const EdgeInsets.all(10.0), 
                child: ViewColumn(soluongngay: "26",text: "Công",color: Colors.green[600],)
              ),
              Padding(
                padding: const EdgeInsets.all(10.0), 
                child: Obx(()=>ViewColumn(soluongngay: attendantHomeControler.totalOffDate.value.toString(),text: "Nghỉ",color: Colors.orange,))
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Obx(()=>CalendarCustomComponent(
              cycelCurrent: PrCodeName(
                code: convertDateToInt(date: attendantHomeControler.cycelToDate.value).toString(),
                name: "Tháng ${attendantHomeControler.cycelToDate.value.month}/${attendantHomeControler.cycelToDate.value.year}",
                value: attendantHomeControler.cycelFromDate.value,
                value2: attendantHomeControler.cycelToDate.value
              ),
              events: attendantHomeControler.listEventOffDate,isLoading: attendantHomeControler.isLoading.value,))
          ),
        ],
      ),
    );
  }

  
}