import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class ButtonLoginComponent extends StatefulWidget {
  @override
  _ButtonLoginComponentState createState() => _ButtonLoginComponentState();
  String btnLabel;
  VoidCallback onPressed;
  bool enable;
  ButtonLoginComponent(
      {Key? key,
      this.btnLabel = "Đăng nhập",
      required this.onPressed,
      this.enable = true})
      : super(key: key);
}

class _ButtonLoginComponentState extends State<ButtonLoginComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.enable) {
          widget.onPressed();
        }
      },
      child: Container(
        //height: 50,
        width: MediaQuery.of(context).size.width / 1.2,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColor.brightBlue, AppColor.jadeColor])),
        child: Text(
          widget.btnLabel,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            //fontFamily: "PlayfairDisplay"
          ),
        ),
      ),
    );
  }
}
