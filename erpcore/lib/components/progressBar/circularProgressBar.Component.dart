import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularProgressBarComponent extends StatefulWidget {
  const CircularProgressBarComponent({ Key? key,this.size =30,this.processValue =0,this.displayValue=true,this.labelColor = Colors.black,this.backgroundColor = Colors.grey,this.strokeWidth =6}) : super(key: key);
  final double size;
  final double strokeWidth;
  final double processValue;
  final bool displayValue;
  final Color labelColor;
  final Color backgroundColor;
  @override
  State<CircularProgressBarComponent> createState() => _CircularProgressBarComponentState();
}

class _CircularProgressBarComponentState extends State<CircularProgressBarComponent> with TickerProviderStateMixin{
  late AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
    super.initState();
  }
  Color get handleProcessColor{
    Color tempColor = AppColor.grey; 
    if(widget.processValue > 0 && widget.processValue <=0.3){
      tempColor = AppColor.brightRed;
    }
    else if(widget.processValue > 0.3 && widget.processValue <0.5){
      tempColor = AppColor.orangeColor;
    }
    else if(widget.processValue >= 0.5 && widget.processValue <=0.7){
      tempColor = AppColor.artyClickOceanGreenColor;
    }
    else{
      tempColor = Colors.green;
    }
    return tempColor;
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          height: widget.size,
          width: widget.size,
          child: CircularProgressIndicator(
            strokeWidth: widget.strokeWidth,
            value: widget.processValue,
            color: handleProcessColor,
            backgroundColor: widget.backgroundColor,
          ),
        ),
        Visibility(
          visible: widget.displayValue,
          child: Positioned(
            child: Text(((widget.processValue*100).toInt()).toString(),style: TextStyle(
              fontSize: widget.size/2.5,fontWeight: FontWeight.bold,color: widget.labelColor
            ),)
          ),
        )
      ],
    );
  }
}