import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';

class TabBarBuilderComponent extends StatefulWidget {
  const TabBarBuilderComponent({ Key? key,required this.tabs,this.onTab,this.tabIndex=0}) : super(key: key);
  final List<PrCodeName>? tabs;
  final Function(int)? onTab;
  final int tabIndex;

  @override
  State<TabBarBuilderComponent> createState() => _TabBarBuilderComponentState();
}

class _TabBarBuilderComponentState extends State<TabBarBuilderComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: AppColor.grey,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: (widget.tabs != null && (widget.tabs??[]).length>1)?MainAxisAlignment.spaceAround:MainAxisAlignment.center,
          children: widget.tabs!.asMap().map((i, element) => MapEntry(i, _buildItemTab(element,i))).values.toList()
        ),
      ),
    );
  }

  Widget _buildItemTab(PrCodeName item,int index){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: GestureDetector(
        onTap: (){
          if(widget.onTab != null){
            widget.onTab!(index);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide( //                   <--- left side
                color: (widget.tabIndex == index)?AppColor.jadeColor:AppColor.whiteColor,
                width: (widget.tabIndex == index)?2.0:0.0,
              ),
            ),
          ),
          child: Text(item.name??"",style: TextStyle(
            color: AppColor.grey,fontSize: (widget.tabIndex == index)?17:16,fontWeight: (widget.tabIndex == index)?FontWeight.bold:FontWeight.normal
          ),),
        ),
      ),
    );
  }
}