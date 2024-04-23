import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ButtonDefaultComponent extends StatefulWidget {
  const ButtonDefaultComponent({super.key,this.width,this.padding,this.backgroundColor,this.borderRadius, this.icon,
    required this.title,this.titleStyle,this.enable=true,this.isLoading=false,required this.onPress}
  );
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final String title;
  final Widget? icon;
  final TextStyle? titleStyle;
  final bool isLoading;
  final bool enable;
  final VoidCallback onPress;
  @override
  State<ButtonDefaultComponent> createState() => _ButtonDefaultComponentState();
}

class _ButtonDefaultComponentState extends State<ButtonDefaultComponent> {
  late Size size;
  Widget getChildByStatus(){
    Widget result = widget.icon == null ? Text(widget.title,style: widget.titleStyle??const TextStyle(
      color: AppColor.whiteColor,fontSize: 15,
      ),textAlign: TextAlign.center,
    ) : widget.icon!;
    if(widget.isLoading){
      result = SizedBox(
        width: size.width*.3,
        child: const SpinKitWave(
          itemCount: 6,
          size: 25,
          color: AppColor.whiteColor,
        ),
      );
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        if(widget.enable && !widget.isLoading){
           widget.onPress();
        }
        else{
          print("busy");
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: widget.width,
        padding: widget.padding??const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
          color: widget.backgroundColor??AppColor.brightBlue,
          borderRadius: widget.borderRadius??const BorderRadius.all(Radius.circular(5.0))
        ),
        child: getChildByStatus()
      ),
    );
  }
}