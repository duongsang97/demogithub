import 'package:flutter/material.dart';

class ButtonAnimationComponent extends StatefulWidget {
  const ButtonAnimationComponent({ Key? key,this.onTab,this.onDoubleTap,this.onLongPress}) : super(key: key);
  final VoidCallback? onTab;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  @override
  State<ButtonAnimationComponent> createState() => _ButtonAnimationComponentState();
}

class _ButtonAnimationComponentState extends State<ButtonAnimationComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTab,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      child: Container(
        child: Text("Chọn"),
      ),
    );
  }
}