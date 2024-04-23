import 'package:flutter/material.dart';

class ViewColumn extends StatefulWidget{
  final String soluongngay;
  final String text;
  final Color? color;
  ViewColumn({this.soluongngay="0", required this.text,this.color});
  @override
  State<StatefulWidget> createState() {
    return ViewRowState();
  }
  
}
class ViewRowState extends State<ViewColumn>{
  @override
  Widget build(BuildContext context) {
   return 
   Container(
       decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.2)
       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
         Text(widget.soluongngay,
          style:TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:widget.color,),textAlign:TextAlign.center,),
         Text(widget.text,textAlign:TextAlign.center,style: TextStyle(fontSize: 12),)
       ],),
    
   );
     
  }

}
