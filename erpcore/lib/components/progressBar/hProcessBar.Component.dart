import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class HProcessBarComponent extends StatefulWidget {
  const HProcessBarComponent({ Key? key,this.processValue,this.heigth=30,this.width=50}) : super(key: key);
  final double heigth;
  final double width;
  final double? processValue;
  @override
  State<HProcessBarComponent> createState() => _HProcessBarComponentState();
}

class _HProcessBarComponentState extends State<HProcessBarComponent> with TickerProviderStateMixin{

  late AnimationController animationController;
  late Color colorProcess;
  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
    colorProcess = AppColor.grey;
    super.initState();
  }
  void handleProcessColor(){
    Color tempColor = AppColor.grey; 
    if(widget.processValue! > 0 && widget.processValue! <=0.3){
      tempColor = AppColor.brightRed;
    }
    else if(widget.processValue! > 0.3 && widget.processValue! <0.5){
      tempColor = AppColor.orangeColor;
    }
    else if(widget.processValue! >= 0.5 && widget.processValue! <=0.7){
      tempColor = AppColor.artyClickOceanGreenColor;
    }
    else{
      tempColor = AppColor.jadeColor;
    }
    setState(() {
      colorProcess = tempColor;
    });
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    handleProcessColor();
    return SizedBox(
      height: widget.heigth,
      width:  widget.width,
      child: LinearProgressIndicator(
        value: widget.processValue,
        color: colorProcess,
        backgroundColor: AppColor.grey.withOpacity(0.5),
      ),
    );
  }
}