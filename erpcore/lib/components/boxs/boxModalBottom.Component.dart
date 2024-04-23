import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxModalBottomComponent extends StatefulWidget {
  const BoxModalBottomComponent({super.key,required this.child,required this.title,this.onCancel,this.titleStyle,this.formSize =0.3,this.titleWidget, this.actionWidget});
  final Widget child;
  final Function? onCancel;
  final String title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final double formSize;
  final Widget? actionWidget;
  @override
  State<BoxModalBottomComponent> createState() => _BoxModalBottomComponentState();
}

class _BoxModalBottomComponentState extends State<BoxModalBottomComponent> {
  late Size size;
  double bottomPadding = 0.0;
  EdgeInsets padding =  EdgeInsets.zero;
  bool isKeyboardVisible = false;
  void onCloseModal() async {
    FocusScope.of(context).unfocus();
    if (widget.onCancel != null) {
      var result = await widget.onCancel!();
      if (result == true) {
        Get.back();
      }
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    size = MediaQuery.of(context).size;
    bottomPadding = MediaQuery.of(context).padding.bottom;
    padding = MediaQuery.paddingOf(context);
    return WillPopScope(
      onWillPop: () async {
        if (widget.onCancel != null) {
          return widget.onCancel!();
        } else {
          return true;
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: padding.top,bottom: padding.bottom),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
                )
              ),
              height: (size.height* widget.formSize) + MediaQuery.of(context).viewInsets.bottom ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: _buildHeader(),
                  ),
                  Expanded(
                    child: widget.child
                  ),
                ],
              ),
            ),
            Positioned(
              top: (padding.top+30),
              left: 20,
              child: GestureDetector(
                onTap: (){
                  if(MediaQuery.of(context).viewInsets.bottom >0){
                    // FocusScope.of(context).requestFocus(FocusNode());
                    FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 500),(){
                      onCloseModal();
                    });
                  }
                  else{
                    onCloseModal();
                  }
                },
                child:const Icon(Icons.arrow_back_ios_new,size: 25,color: AppColor.grey,),
              )
            ),
            if (widget.actionWidget != null)
              Positioned(
                top: (padding.top+30),
                right: 20,
                child: widget.actionWidget!
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Container(
      padding: EdgeInsets.only(top: padding.top+20),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.titleWidget??Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Text(widget.title,textAlign: TextAlign.center,
              style: widget.titleStyle??const TextStyle(color: AppColor.grey,fontWeight: FontWeight.bold,fontSize: 16),
            ),
          ),
          // Align(
          //   child: SizedBox(
          //     width: size.width *.5,
          //     child: Divider(color: Colors.black.withOpacity(0.5)),
          //   ),
          // )
        ],
      ),
    );
  }
}