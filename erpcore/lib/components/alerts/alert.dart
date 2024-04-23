import 'dart:async';

import 'package:erpcore/components/alerts/elements/luckyDrawHistory.Element.dart';
import 'package:erpcore/components/alerts/elements/photoListViewAlert.Element.dart';
import 'package:erpcore/components/chooseCard/chooseCard.Component.dart';
import 'package:erpcore/components/chooseGift/chooseGift.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/models/activations/game/chooseGift.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'data/alertType.Data.dart';
import 'elements/luckyDrawAlert.Element.dart';
import 'elements/photoViewAlert.Element.dart';
import 'elements/questionAlert.Element.dart';
import 'package:cached_network_image/src/cached_image_widget.dart';
import 'package:erpcore/utility/image.Utility.dart';

class Alert {
  static Future<void> dialogBigo(BuildContext context, String title, String object,String image, String content,{Function? callback}) async {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: MediaQuery.of(context).size.height*0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 1,child:Text(object),),
            Expanded(flex: 4,child: SizedBox(
              height: 500,
              child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset(image),
            ),
            ),),
            Expanded(flex: 1,child:Text(content),),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              callback!();
            },
            child: const Text("Xác nhận")),
      ],
    );
    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static void showAnimatedZoomGiftDialog(AnimationController animationController, String giftUrl, Animation animation, {int quantity = 0}) {
    animationController.reset();
    animationController.forward();
    
    Get.dialog(
      AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          double heightDialog = MediaQuery.of(context).size.height * 0.6;
          double widthDialog = MediaQuery.of(context).size.width * 0.7;
          return Center(
            child: Transform.scale(
              scale: animation.value,
              child: Container(
                width: widthDialog,
                height: heightDialog,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: CachedNetworkImage(
                            imageUrl: ImageUtils.getURLImage((giftUrl),),
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageBuilder : (BuildContext context,img){
                              return SizedBox(
                                child: Image(image: img,fit: BoxFit.cover,),
                              );
                            }
                          ),)
                      ],
                    ),
                    Positioned(
                      top: heightDialog / 2,
                      left: (widthDialog / 5) - 20,
                      child: Text("X $quantity ", style: const TextStyle(fontSize: 25, color: AppColor.whiteColor,fontWeight: FontWeight.bold ),)
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap:(){
                          Get.back();
                        },
                        child: const Icon(Icons.close,size: 30,color: Colors.white,)
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<void> progress(BuildContext context, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          style: const TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }

  // Widget itemDiaLogAutoNext(Icon){
    
  // }
  // 
  static Widget handleTypeAutoNext(BuildContext context,bool flag,{Widget? child}){
    Size size = MediaQuery.of(context).size;
    if(flag){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2,child: Image.asset("assets/images/icons/smile.png",height: size.height*0.4,),),
        const SizedBox(height: 10,),
        const Expanded(child: Text("Xin chúc mừng",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),),),
      ],);
    }
    else
    {
      return Column(children: [
        Expanded(flex: 2,child: Image.asset("assets/images/icons/crying.png",height: size.height*0.4,),),
        const Expanded(child: Text("Câu trả lời đúng là:",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold)),),
        const SizedBox(height: 10,),
        Expanded(flex: 3,child:  child ?? const Text("1234"),)
      ],);
    }
  } 
  static Future<void> diaLogAutoNext( BuildContext context,String content,bool flag,{Widget? childItem,Function? callback}) async {
    Size size = MediaQuery.of(context).size;
    Timer _timer;
    int _start = 3;
    const oneSec = Duration(seconds: 1);
   _timer = Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
       timer.cancel();
       Navigator.pop(context, true);
        if(callback!=null){
         callback();
       }
      } else {
       _start--;
      }
    },
  );
    showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox();
    },
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.4),
    barrierLabel: '',
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.rotate(
        angle: math.radians(anim1.value * 360),
        child: AlertDialog(
          shape:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          //title: Text(""),
          content: handleTypeAutoNext(context,flag,child: childItem)
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 500)
    );
  }

  static void toastShow(String msg,Color colorBack, {VoidCallback? callback,SnackPosition gravity = SnackPosition.TOP,int secDelay=3}) async{
    // await Fluttertoast.showToast(
    //   msg: msg,
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: gravity,
    //   timeInSecForIosWeb: secDelay,
    //   backgroundColor: colorBack,
    //   textColor: Colors.white,
    //   fontSize: 16.0
    // );
    Get.snackbar("Thông báo", msg,
      duration: Duration(seconds: secDelay),
      colorText: AppColor.whiteColor,
      backgroundColor: colorBack,
      snackPosition: gravity,
      snackStyle: SnackStyle.FLOATING
    );

    Future.delayed(Duration(seconds: secDelay),(){
      if(callback != null){
        callback();
      }
    });
  }

  static Future<void> dialogBeauty(BuildContext context, String title, String content, {Function? callback} ) async {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              //title: new Text("Cupertino Dialog"),
              content: Container(color: Colors.red,child: const Text("123"),),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
    ));
  }

  static Future<void> dialogQuestions(BuildContext context, bool flag ) async {

    showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Center(child: QuestionAlertElement(flag: flag,),)
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {return const SizedBox();});
  }

  static Future<void> dialogLuckyDraw(BuildContext context, PrCodeName gift ,String groupCode,Function(String, String) funcGetCardbyCodeName) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: LuckyDrawAlertElement(gift: gift,codeGroup: groupCode,funcGetCardbyCodeName: funcGetCardbyCodeName),)
    );
  }

  static Future<void> dialogChooseCard(BuildContext context, String groupCode,Function(String, String) funcGetCardbyCodeName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: ChooseCardComponent(codeGroup: groupCode,funcGetCardbyCodeName: funcGetCardbyCodeName),)
    );
  }
  static Future<void> dialogHistoryLuckyDraw(BuildContext context, String groupCode,Function(String) funcGetHistoryLuckyDraw) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: LuckyDrawHistoryElement(groupCode: groupCode,funcGetHistoryLuckyDraw: funcGetHistoryLuckyDraw),)
    );
  }
  static Future<int> showAlertDialogConfirmLuckyDraw(BuildContext context) async{
    int flag = 0;
    // show the dialog
    Size size = MediaQuery.of(context).size;
    await showDialog(
        context: context,
        builder: (context) =>Center(
         child: Container(
           width: size.width*.9,
            height: size.height*.2,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
           margin: const EdgeInsets.symmetric(horizontal: 10),
           child: Material(
             child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               _buildButton("Chỉnh sửa",Colors.blue,(){
                 flag=1;
                  Navigator.of(context).pop();
               }),
               _buildButton("Lịch sử quay thưởng",Colors.yellow[600]!,(){
                 flag=2;
                  Navigator.of(context).pop();
               }),
             ],
           )
           ),
         ),
        )
      );
    return flag;
  }
  static Widget _buildButton(String label,Color color, VoidCallback function){
    return GestureDetector(
      onTap:function,
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey,width:0.5),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))
        ),
        child: Center(
          child: Text(label,style: const TextStyle(color: Colors.black,fontSize: 14),),
        ),
      ),
    );
  }

  static Future<void> dialogChooseGift(BuildContext context, String groupCode,List<List<ChooseGiftInfoModel>> listData,Function(String, List<ChooseGiftInfoModel>) funcChooseGift) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: ChooseGiftComponent(codeGroup: groupCode,listData: listData,funcChooseGift: funcChooseGift),)
    );
  }

  static Future<void> dialogPhotoView(BuildContext context,{String? assetImage,String? networkImage}) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: PhotoViewAlertElement(assetImage: assetImage??"",networkImage: networkImage??"",),)
    );
  }

  static Future<void> dialogPhotoListView(BuildContext context,{List<DataImageActModel>? listImage,DataImageActModel? image}) async {
    List<DataImageActModel> temp = [];
    for(DataImageActModel e in (listImage??[])){
      if ((e.urlImage != null && e.urlImage!.isNotEmpty) || (e.assetsImage != null && e.assetsImage!.isNotEmpty)) {
        temp.add(e);
      }
    }
    int index = temp.indexWhere((element) => element.urlImage == image?.urlImage && element.assetsImage == image?.assetsImage );
    showDialog(
      context: context,
      builder: (context) => Center(child: PhotoListViewAlertElement(listImage: temp,currentIndex: index),)
    );
  }

  static Future<void> dialogShow(String title,String content,{AlertTypeData type = AlertTypeData.DEFAULT, Function? onConfirm, Function? onCancel}) async{
    await Get.defaultDialog(
      title: title,
      content: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(thickness: 1,),
              const SizedBox(height: 5,),
              Text(content),
              const SizedBox(height: 5,),
              const Divider(thickness: 1,),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   GestureDetector(
                    onTap: (){
                      Get.back();
                      if(onConfirm != null){
                        onConfirm();
                      }
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      decoration: const BoxDecoration(
                        color: AppColor.jadeColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const Center(child: Text("Đồng ý",textAlign: TextAlign.center,style: TextStyle(color:AppColor.whiteColor)),)
                    ),
                  ),
                  const SizedBox(width: 10,)
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  static Future<void> dialogShowFull(String title, Widget content,{double height = 150, AlertTypeData type = AlertTypeData.DEFAULT, Function? onConfirm, Function? onCancel}) async{
    await Get.defaultDialog(
      title: title,
      content: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(thickness: 1,),
            const SizedBox(height: 5,),
            Scrollbar(thickness: 2.0, child: SizedBox(height: height, width: Get.width, child: SingleChildScrollView (child: content))),
            const SizedBox(height: 5,),
            const Divider(thickness: 1,),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 GestureDetector(
                  onTap: (){
                    Get.back();
                    if(onConfirm != null){
                      onConfirm();
                    }
                  },
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: const BoxDecoration(
                      color: AppColor.jadeColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: const Center(child: Text("Đồng ý",textAlign: TextAlign.center,style: TextStyle(color:AppColor.whiteColor)),)
                  ),
                ),
                const SizedBox(width: 10,)
              ],
            )
          ],
        ),
      )
    );
  }

  static Future<bool> showDialogConfirm(String title,String content,{AlertTypeData type = AlertTypeData.DEFAULT, Function? onConfirm,Function? confirmMiddleware, Function? onCancel,Widget? child, TextStyle? contentStyle}) async{
    var result = await Get.defaultDialog<bool>(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(Get.context!).height*.9),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(thickness: 1,),
              const SizedBox(height: 5,),
              child??Text(content, style: contentStyle),
              const SizedBox(height: 5,),
              const Divider(thickness: 1,),
              const SizedBox(height: 5,),
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Get.back<bool>(result: false);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.brightRed,
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          child: const Center(child: Text("Đóng",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor),),)
                        ),
                      )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: GestureDetector(
                        onTap: onConfirm!=null?onConfirm():(){
                          if(confirmMiddleware != null){
                            if(confirmMiddleware()){
                              Get.back<bool>(result: true);
                            }
                          }
                          else{
                            Get.back<bool>(result: true);
                          }
                          
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color:  AppColor.jadeColor,
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          child: const Center(child: Text("Đồng ý",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor)),)
                        ),
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
    return result??false;
  }

  static Future<void> showDialogConfirmCustom(String title,String content,{AlertTypeData type = AlertTypeData.DEFAULT,required List<Widget> child}) async{
    Get.defaultDialog<bool>(
      barrierDismissible: false,
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 1,),
            const SizedBox(height: 5,),
            Text(content),
            const SizedBox(height: 5,),
            const Divider(thickness: 1,),
            const SizedBox(height: 5,),
            SizedBox(
              height: 30,
              child: Wrap(
                alignment :WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: child,
              )
            )
          ],
        ),
      )
    );
  }

  static Future<void> showSnackbar(String title,String message,{Duration? duration,SnackPosition snackPosition = SnackPosition.TOP,AlertTypeData type = AlertTypeData.DEFAULT,Function(SnackbarStatus?)? callback}) async{
    duration ??= const Duration(seconds: 2);
    Icon? icon;
    if(type == AlertTypeData.ERROR){
      icon = const Icon(Icons.gpp_bad_outlined,color: AppColor.brightRed,);
    }
    else if(type == AlertTypeData.SUCCESS){
      icon = const Icon(Icons.done_outline_outlined,color: AppColor.laSalleGreen,);
    }
    else if(type == AlertTypeData.WARNING){
      icon = const Icon(Icons.report_problem_outlined,color: AppColor.orangeColor,);
    }
    Get.snackbar(title, message,
      duration: duration,
      snackPosition: snackPosition,
      icon: icon,
      colorText: AppColor.whiteColor,
      backgroundColor: AppColor.nearlyBlack,
      snackbarStatus: callback
    );
  }

}


