import 'package:erpcore/components/selectBox/selectBoxVersatile.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erp/src/screens/attendants/attendantOff/attendantOff.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dayoffstart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DayoffstartState();
  }
  
}
class DayoffstartState extends State<Dayoffstart>{
  final AttendantOffController attendantOffController = Get.find();
  @override
  Widget build(BuildContext context) {
  attendantOffController.context =context;
  return Column(
    children: [ 
      TextInputComponent(
        title: "Từ ngày", 
        placeholder: "yyyy-MM-dd",
        enable: false, 
        controller: attendantOffController.txtDayOffFromController,
        onTab: ()=>
          onTabChooseDatetion(context,onConfirm: (v){
            attendantOffController.txtDayOffFromController.text =v;
              }
                ) 
      ),
      SizedBox(height: 10,),
      Container(
        height: 45,
        child: Obx(()=> SelectBoxVersatileComponent(
        label: "Khung giờ",
        //hintBox: "C",
        selectedItem: attendantOffController.timeslotstart.value,
        asyncListData: (String keyword,int page,int pageSize){
          return attendantOffController.attendantEmployee.getListTimeSlot(pageSize:pageSize,keyword: keyword,pageNumber: page);
        },
        onChanged: (PrCodeName? item) async{                 
          if(!PrCodeName.isEmpty(item)){
            attendantOffController.fetchDataTimeslotStart();
            attendantOffController.timeslotstart.value = item!;
            attendantOffController.text.value= item.code??"";
            attendantOffController.txtTimeSlotFromController.text = item.name??"";
          } else {
            attendantOffController.timeslotstart.value = PrCodeName();
          }
        })),
      )   
   ],
    );
  }
}