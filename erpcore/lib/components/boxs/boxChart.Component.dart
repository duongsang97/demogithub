import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class BoxChartComponent extends StatefulWidget {
  const BoxChartComponent({ Key? key,required this.child,this.label =""}) : super(key: key);
  final Widget child;
  final String label;
  @override
  State<BoxChartComponent> createState() => _BoxChartComponentState();
}

class _BoxChartComponentState extends State<BoxChartComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      shadowColor: AppColor.grey,
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(widget.label,style: TextStyle(fontSize: 16),)),
              ],
            ),
            SizedBox(height: 10,),
            widget.child
          ],
        ),
      )
    );
  }
}