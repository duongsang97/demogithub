import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';

class TagItemElement extends StatefulWidget {
  const TagItemElement({ Key? key,required this.item,this.onPress,required this.selectedButton}) : super(key: key);
  final PrCodeName item;
  final PrCodeName selectedButton;
  final Function(PrCodeName)? onPress;
  @override
  State<TagItemElement> createState() => _TagItemElementState();
}

class _TagItemElementState extends State<TagItemElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.onPress != null){
          widget.onPress!(widget.item);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        key: widget.key,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(20.0)
          ),
          color: widget.selectedButton == widget.item?AppColor.brightBlue:AppColor.aqua
        ),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Theme(
          data: ThemeData.dark(),
          child: Row(
            children: [
              Icon(Icons.tag,size: 18,color: widget.selectedButton == widget.item?AppColor.azureColor:AppColor.nearlyBlack,),
              SizedBox(width: 5,),
              Text((widget.item.name)??"",
                style: TextStyle(color:  widget.selectedButton == widget.item?AppColor.azureColor:AppColor.nearlyBlack,fontWeight: widget.selectedButton == widget.item?FontWeight.bold:FontWeight.normal), 
                softWrap: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}