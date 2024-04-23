import 'package:flutter/material.dart';

class ItemProfileFuncElement extends StatefulWidget {
  const ItemProfileFuncElement({ Key? key,this.callback,this.label="",this.labelStyle}) : super(key: key);
  final VoidCallback? callback;
  final String label;
  final TextStyle? labelStyle;
  @override
  State<ItemProfileFuncElement> createState() => _ItemProfileFuncElementState();
}

class _ItemProfileFuncElementState extends State<ItemProfileFuncElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.callback != null){
          widget.callback!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          //color: AppColor.whiteColor
        ),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(widget.label,style: widget.labelStyle,),),
                Icon(Icons.arrow_right_sharp),
              ],
            ),
            Divider(
              thickness: 1,
            )
          ],
        )
      ),
    );
  }
}