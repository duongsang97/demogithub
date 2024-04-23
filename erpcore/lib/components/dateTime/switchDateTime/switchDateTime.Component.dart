import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class SwitchDateTimeComponent extends StatefulWidget {
  const SwitchDateTimeComponent({ Key? key,this.onChange,this.currentDate}) : super(key: key);
  final Function(DateTime)? onChange;
  final DateTime? currentDate;
  @override
  State<SwitchDateTimeComponent> createState() => _SwitchDateTimeComponentState();
}

class _SwitchDateTimeComponentState extends State<SwitchDateTimeComponent> {
  late DateTime dateTimeDisplay;
  late Size size;
  @override
  void initState() {
    super.initState();
  }

  void onChangeDate(String type){
    var tempDate = widget.currentDate;
    if(type == "next"){
      tempDate = DateTime(widget.currentDate!.year,widget.currentDate!.month+1,1);
    }
    else if(type =="previous"){
       tempDate = DateTime(widget.currentDate!.year,widget.currentDate!.month-1,1);
    }

    if(widget.onChange != null){
      widget.onChange!(tempDate!);
    }

  }

  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              onChangeDate("previous");
            },
            child: Icon(Icons.arrow_left,color: AppColor.whiteColor,size: 30,)
          ),
          Flexible(
            child: Container(
              width: size.width*.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(widget.currentDate!.month.toString(),style: TextStyle(color: AppColor.whiteColor,fontSize: 16),),
                  ),
                  Container(
                    child: Text(" / ",style: TextStyle(color: AppColor.whiteColor,fontSize: 16),),
                  ),
                  Container(
                    child: Text(widget.currentDate!.year.toString(),style: TextStyle(color: AppColor.whiteColor,fontSize: 16)),
                  )
                ],
              ),
            )
          ),
          GestureDetector(
            onTap: (){
              onChangeDate("next");
            },
            child: Icon(Icons.arrow_right,color: AppColor.whiteColor,size: 30,)
          )
        ],
      ),
    );
  }
}