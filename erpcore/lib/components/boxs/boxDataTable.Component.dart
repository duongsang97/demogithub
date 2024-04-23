import 'package:erpcore/components/boxs/boxElementTitle.Component.dart';
import 'package:flutter/material.dart';

class BoxDataTableComponent extends StatefulWidget {
  const BoxDataTableComponent({ Key? key,required this.child,this.label ="", this.rightWidget}) : super(key: key);
  final Widget child;
  final String label;
  final Widget? rightWidget;
  @override
  State<BoxDataTableComponent> createState() => _BoxDataTableComponentState();
}

class _BoxDataTableComponentState extends State<BoxDataTableComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BoxElementTitleComponent(
                  title: widget.label,
                  rightNavbar: widget.rightWidget,
                ),
              )
            ],
          ),
          const SizedBox(height: 10,),
          widget.child
        ],
      ),
    );
  }
}