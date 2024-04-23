import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/homeFunctionItem.Model.dart';
import 'package:flutter/material.dart';

class HomeFunctionItemComponent extends StatefulWidget {
  const HomeFunctionItemComponent({ Key? key,required this.onPress,required this.fnItem,this.isLoading= false}) : super(key: key);
  final Function(HomeFunctionItemModel) onPress;
  final HomeFunctionItemModel fnItem;
  final bool isLoading;
  @override
  State<HomeFunctionItemComponent> createState() => _HomeFunctionItemComponentState();
}

class _HomeFunctionItemComponentState extends State<HomeFunctionItemComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!widget.isLoading){
          widget.onPress(widget.fnItem);
        }
        else{
          AlertControl.push("Đang tải dữ liệu, vui lòng chờ", type: AlertType.ERROR);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.isLoading?const SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: AppConfig.appColor,strokeWidth:1),):Image.asset((widget.fnItem.assetImage)??"assets/images/icons/functions/list-employee.png",height: 35,width: 35,),
          const SizedBox(height: 5,),
          Expanded(child: Text(widget.fnItem.name??"",textAlign: TextAlign.center,style: const TextStyle(color: AppColor.grey,fontSize: 11),))
        ],
      ),
    );
  }
}