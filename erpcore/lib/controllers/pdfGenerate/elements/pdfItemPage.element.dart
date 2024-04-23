import 'dart:io';
import 'dart:ui';

import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/controllers/pdfGenerate/models/pdfItemPage.Model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PDFItemPageElement extends StatefulWidget {
  const PDFItemPageElement({super.key,required this.item,this.onPress});
  final PDFItemPageModel item;
  final Function(PDFItemPageModel)? onPress;
  @override
  State<PDFItemPageElement> createState() => _PDFItemPageElementState();
}

class _PDFItemPageElementState extends State<PDFItemPageElement> with SingleTickerProviderStateMixin{
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: widget.onPress!=null?(){
            widget.onPress!(widget.item);
          }:null,
          onLongPress: widget.onPress!=null?(){
            widget.onPress!(widget.item);
          }:null,
          child: AnimatedContainer(
            decoration: BoxDecoration(
            boxShadow: kElevationToShadow[1],
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
              image: DecorationImage(
                image: FileImage(File(Uri.parse(widget.item.asset??"").path)),
                fit: BoxFit.cover
              )
            ),
            duration: Duration(milliseconds: 400),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: AppColor.brightBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0)
              )
            ),
            child: Text("${widget.item.page??""}",style: TextStyle(
              color: AppColor.whiteColor,fontSize: 12
            ),),
          )
        ),
        Visibility(
          visible: widget.onPress==null,
          child: Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: AppColor.spiralColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0)
                )
              ),
              child: Icon(Icons.menu_outlined,color: AppColor.whiteColor,size: 18,)
            ),
          )
        ),
        Visibility(
          visible: [1,2].contains(widget.item.status),
          child: Positioned(
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: AppColor.grey.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0)
                )
              ),
              child: widget.item.status==1?Visibility(
                visible: widget.item.status == 1,
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.white,
                  size: 30,
                ),
              ):
              Icon(Icons.done_outline_outlined,color: AppColor.whiteColor,size: 25,)
            ),
          )
        )
      ],
    );
  }
}