import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/employee/employeeView.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class EmployeeItemComponent extends StatefulWidget {
  const EmployeeItemComponent({ Key? key,this.item,this.callback}) : super(key: key);
  final EmployeeViewModel? item;
  final Function(String,int)? callback;
  @override
  State<EmployeeItemComponent> createState() => _EmployeeItemComponentState();
}

class _EmployeeItemComponentState extends State<EmployeeItemComponent> {
  ImageProvider getAvatarImage(){
    ImageProvider result = const AssetImage("assets/images/icons/no-pictures.png");
    try{
      if(widget.item != null && widget.item?.imageName != null && widget.item!.imageName!.isNotEmpty){
        var fullPath = getServerName(false)+convertWindowPathToURL((widget.item?.imageName)!);
        result = NetworkImage(fullPath);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getAvatarImage empItem.Component");
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.callback!((widget.item?.code)!,1);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: const BoxDecoration(
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColor.azureColor,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: getAvatarImage()
                )
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text("${(widget.item?.empNo)??"n/a"} ${(widget.item?.name)??""}",style: const TextStyle(color: AppColor.grey,fontWeight: FontWeight.bold,fontSize: 14)),),
                        // PopupMenuButton(
                        //   child: Image.asset("assets/images/icons/three-dots.png",width: 20,height: 18,),
                        //   onSelected: (int v){
                        //     if(widget.callback != null){
                        //       widget.callback!((widget.item?.code)!,v);
                        //     }
                        //   },
                        //   itemBuilder:(context) => [
                        //     PopupMenuItem(
                        //       child: Text("Sửa"),
                        //       value: 1,
                        //     ),
                        //     PopupMenuItem(
                        //       child: Text("Xóa"),
                        //         value: 2,
                        //       ),
                        //     PopupMenuItem(
                        //       child: Text("Đóng"),
                        //         value: 3,
                        //       )
                        //   ]
                        // ),
                      ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text("NgSinh: ${widget.item?.birthDay??"n/a"}",style: const TextStyle(color: AppColor.grey,fontSize: 13)),),
                      Expanded(child: Text("CMND: ${widget.item?.cmnd??"n/a"}",style: const TextStyle(color: AppColor.grey,fontSize: 13)),)
                    ],
                  ),
                  const SizedBox(height: 2,),
                  Text((widget.item?.cus??"n/a"),style: const TextStyle(color: AppColor.grey,fontSize: 13),)
                ],
              )
            )
          ],
        )
      ),
    );
  }
}