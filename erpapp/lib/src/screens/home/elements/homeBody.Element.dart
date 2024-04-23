import 'package:flutter/material.dart';

class HomeBodyElement extends StatefulWidget {
  const HomeBodyElement({ Key? key,required this.children,this.padding}) : super(key: key);
  final List<Widget> children;
  final EdgeInsets? padding;
  @override
  State<HomeBodyElement> createState() => _HomeBodyElementState();
}

class _HomeBodyElementState extends State<HomeBodyElement> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      //height: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight:  Radius.circular(30.0)
        ),
        boxShadow: [
          BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          //spreadRadius: 10,
          blurRadius: 7,
          offset: Offset(3.0, 0), // changes position of shadow
          ),
        ]
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: widget.padding,
        shrinkWrap: true,
        children: widget.children,
      )
    );
  }
}