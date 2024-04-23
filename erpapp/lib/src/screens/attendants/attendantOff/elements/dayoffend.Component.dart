import 'package:erpcore/components/selectBox/selectBoxVersatile.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erp/src/screens/attendants/attendantOff/attendantOff.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dayoffend extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DatoffendState();
  }
  
}
class DatoffendState extends State<Dayoffend>{
  final AttendantOffController attendantOffController = Get.find();
  @override
  Widget build(BuildContext context) {
  attendantOffController.context = context;
  return Obx(()=> Visibility(
    visible:attendantOffController.checkTimeSlotStart(attendantOffController.text.value)==true?false:true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputComponent(
          title: "Đến ngày", 
          placeholder: "yyyy-MM-dd",
          enable: false,
          controller: attendantOffController.txtDayOffToController,
          onTab: (){
            if(attendantOffController.txtDayOffFromController.text.isNotEmpty){
              onTabChooseDatetion(context,onConfirm: (v){
                attendantOffController.txtDayOffToController.text =v;
              });
            }
          }
        ),
        SizedBox(height: 10,),
          Container(
            height: 45,
            child: SelectBoxVersatileComponent(
              label: "Khung giờ",
              selectedItem: attendantOffController.timeslotend.value,
              listData: attendantOffController.listtimeslotend,
              onChanged: (PrCodeName? item) async{ 
                if(!PrCodeName.isEmpty(item)){
                  attendantOffController.fetchDataTimeSlotEnd();                  
                  attendantOffController.timeslotend.value = item!;                                                                             
                  attendantOffController.txtTimeSlotToController.text= item.name??"";
                }
                else{
                  attendantOffController.timeslotend.value = PrCodeName();
                }
              }
            ),
          )
        ],
      )
    ));
  }
}