import 'package:erpcore/components/buttons/buttonLogin.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/attendants/attendantHome/attendantHome.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriteNote extends StatefulWidget {
  const WriteNote({ Key? key }) : super(key: key);

  @override
  State<WriteNote> createState() => AttendantdayOffState();
}

class AttendantdayOffState extends State<WriteNote> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    final AttendantHomeControler attendantHomeControler = Get.find();
    size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.7,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical:10),
      child: Column(
        children: [
          const Text("Lỗi trong ngày",style: TextStyle(color: AppColor.grey,fontSize: 16,fontWeight: FontWeight.bold),),
          const ListTile(
            leading: Text('Time'),
            title: Text('Lỗi'),
          ),
          const SizedBox(height: 15,),
          ButtonLoginComponent(
            btnLabel: "Thoát",
            onPressed: (){
              Get.back();
            },
          )
        ],
      )
    );
  }
}