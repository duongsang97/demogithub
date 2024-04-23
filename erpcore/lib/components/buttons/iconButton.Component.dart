import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class IconButtonComponent extends StatefulWidget {
  const IconButtonComponent({ Key? key,required this.icon,required this.onPress,this.isLoading =false,this.loadingColor,
    this.decoration,this.padding
  }) : super(key: key);
  final Widget icon;
  final VoidCallback onPress;
  final bool isLoading;
  final Color? loadingColor;
  final BoxDecoration? decoration; 
  final EdgeInsetsGeometry? padding;
  @override
  State<IconButtonComponent> createState() => _IconButtonComponentState();
}

class _IconButtonComponentState extends State<IconButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: AnimatedContainer(
        padding: widget.padding,
        duration: const Duration(milliseconds: 500),
        decoration: widget.decoration,
        child: (widget.isLoading)?SizedBox(
          height: 22,width: 22,
          child: CircularProgressIndicator(strokeWidth: 2,color: widget.loadingColor??AppColor.jadeColor,),)
        :(widget.icon),
      )
    );
  }
}