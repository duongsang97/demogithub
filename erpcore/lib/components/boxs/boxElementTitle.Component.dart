import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class BoxElementTitleComponent extends StatefulWidget {
  const BoxElementTitleComponent({Key? key,this.title="",this.rightNavbar,this.titleWidget}) : super(key: key);
  final String title;
  final Widget? rightNavbar;
  final Widget? titleWidget;

  @override
  State<BoxElementTitleComponent> createState() => _BoxElementTitleComponentState();
}

class _BoxElementTitleComponentState extends State<BoxElementTitleComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide( //                    <--- top side
            color: Colors.black,
            width: 0.2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildLeftElement()),
          const SizedBox(width: 10,),
          widget.rightNavbar?? const SizedBox()
        ],
      )
    );
  }

  Widget _buildLeftElement(){
    return Container(
      padding:const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 20,
            color: AppColor.nearlyBlue,
          ),
          const SizedBox(width: 5,),
          Expanded(child: widget.titleWidget != null ? widget.titleWidget! : Text(widget.title,style: const TextStyle(fontSize: 13),))
        ],
      ),
    );
  }
}