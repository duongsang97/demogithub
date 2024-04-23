import 'package:erpcore/components/buttons/buttonLogin.Component.dart';
import 'package:erpcore/components/selectBox/selectBoxVersatile.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erp/src/screens/attendants/attendantOff/attendantOff.Controller.dart';
import 'package:erp/src/screens/attendants/attendantOff/elements/dayoffstart.Component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'elements/dayoffend.Component.dart';

class AttendantdayOffScreen extends GetWidget<AttendantOffController> {
 final attendantOffController = Get.put(AttendantOffController());
  late Size size; 
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    attendantOffController.context = context;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child:Column(
          children: [
            SelectBoxVersatileComponent(
              label: "Lý do",
              selectedItem: attendantOffController.typedayoff.value,
              asyncListData: (String keyword,int page,int pageSize){
                return attendantOffController.attendantEmployee.getListTypeDayOff(pageSize:pageSize,keyword: keyword,pageNumber: page);
              },
              onChanged: (PrCodeName? item) async{
                if(!PrCodeName.isEmpty(item)){
                  attendantOffController.fetchDataTypeDayOff();
                  attendantOffController.typedayoff.value = item!;
                  attendantOffController.txtTypeDayOffController.text= item.name??"";
                }
                else{
                  attendantOffController.typedayoff.value = item??PrCodeName();
                }
              }
            ),
            const SizedBox(height: 10,),
            Dayoffstart(),      
            const SizedBox(height: 10,),   
            Dayoffend(),
            const SizedBox(height: 10,),
            Container(
              height: 65, 
              child: TextInputComponent(title: 'Ghi chú',maxLine: 5, placeholder: 'Nhập', 
                controller: attendantOffController.txtNoteController,
                heightBox: 65,
              )
            ),
            ButtonLoginComponent(btnLabel: 'Gửi yêu cầu',onPressed:()=>attendantOffController.saveRequest(),)
          ],
        ),
    );
  
  }

}
