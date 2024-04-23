import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PermissionRequestElement extends StatelessWidget {
  const PermissionRequestElement({super.key,required this.item,this.onAccept,this.isLoading = false});
  final PrCodeName item;
  final Function(PrCodeName)? onAccept;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: size.width*.6,
                width: size.width*6,
                decoration: BoxDecoration(
                  color: AppColor.jtiGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.nearlyBlack.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(4, 2), // Shadow position
                    ),
                  ],
                ),
                child: Center(child: Image.asset(item.code??"assets/images/icons/request.png",width: size.width*.4,),)
              ),
              Positioned(
                right: size.width*.2,
                top:  (size.width*.6)*.1,
                child: Image.asset("assets/images/icons/star_1.png",width: size.width*.15,)
              ),
              Positioned(
                left: size.width*.3,
                top:  (size.width*.6)*.5,
                child: Image.asset("assets/images/icons/star_2.png",width: size.width*.2,)
              ),
              Positioned(
                left: size.width*.2,
                top:  0,
                child: Image.asset("assets/images/icons/fireworks.png",width: size.width*.2,)
              )
            ],
          ),
          SizedBox(height: size.height*.1,),
          Text("${item.name}",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),
          Text("${item.codeDisplay}",textAlign: TextAlign.center,style: const TextStyle(fontSize: 13),),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              if(onAccept != null && isLoading==false){
                onAccept!(item);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
              decoration: BoxDecoration(
                color: AppColor.acacyColor,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.nearlyBlack.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(4, 2), // Shadow position
                  ),
                ],
              ),
              child: isLoading == true?LoadingAnimationWidget.twistingDots(
                leftDotColor: AppColor.acacyColor,
                rightDotColor: const Color(0xFFEA3799),
                size: 20,
              ):const Text("Chấp nhận",style: TextStyle(color: AppColor.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }
}