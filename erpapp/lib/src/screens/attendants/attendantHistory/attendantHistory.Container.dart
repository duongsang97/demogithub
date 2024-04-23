import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'attendantHistory.Controller.dart';

class AttendantHistoryScreen extends GetWidget<AttendantHistoryController>{
  final AttendantHistoryController attendantHistoryController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
         Visibility(
           child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: attendantHistoryController.listoff.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: [
                        // ListTile(
                        //   title: Text(attendantHistoryController.listoff[index].typeoff.name),
                        //   subtitle: Row(
                        //     children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(attendantHistoryController.listoff[index].startoff.sD),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(attendantHistoryController.listoff[index].endoff.sD),
                        //     )
                        //   ],),
                        // )
                      ],
                    );
                  }  
         ))
    );
  }
}