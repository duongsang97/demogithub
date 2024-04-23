import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/routers/app.Router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:erpcore/utility/image.Utility.dart';

import 'elements/abItemAction.element.dart';

class AppbarMainComponent extends StatefulWidget implements PreferredSizeWidget {
  const AppbarMainComponent({super.key,this.height=kToolbarHeight+5,required this.userProfle,this.onTapAvt,required this.notifys,this.routerHomeNotification,this.child,
  this.backgroundColor});
  final double height;
  final UserInfoModel userProfle;
  final List<NotificationInfoModel> notifys;
  final VoidCallback? onTapAvt;
  final String? routerHomeNotification;
  final Widget? child;
  final Color? backgroundColor;
  @override
  State<AppbarMainComponent> createState() => _AppbarMainComponentState();
  
  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _AppbarMainComponentState extends State<AppbarMainComponent> {
  
  Size get _preferredSize => Size.fromHeight(widget.height);
  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      color: widget.backgroundColor??AppColor.whiteColor,
      height: _preferredSize.height + topPadding,
      padding: EdgeInsets.only(top: topPadding+5,left: 10,right: 10),
      child: widget.child??Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildAvatarBox(),),
          _buildActionBox()
        ],
      )
    );
  }

  Widget _buildAvatarBox(){
    return GestureDetector(
      onTap: widget.onTapAvt,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: ImageUtils.getURLImage((widget.userProfle.avatarImage.isNotEmpty && p.basename(widget.userProfle.avatarImage).compareTo('.')>-1)?widget.userProfle.avatarImage:""), 
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColor.azureColor,
                      backgroundImage: imageProvider 
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColor.azureColor,
                      backgroundImage: AssetImage("assets/images/icons/default_avatar.png") 
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColor.azureColor,
                      backgroundImage: AssetImage("assets/images/icons/default_avatar.png") 
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: widget.userProfle.verified==true?AppColor.greenMonth:AppColor.brightRed,
                    shape: BoxShape.circle
                  ),
                  child: Icon(widget.userProfle.verified==true?Icons.task_alt_outlined:Icons.highlight_off_outlined,size: 12,color: AppColor.whiteColor,),
                )//Image.asset("assets/images/icons/acount-verify.png",width: 15,height: 15,)
              )
            ],
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Xin chào,",style: TextStyle(color: AppColor.grey,fontSize: 12),),
                const SizedBox(height: 5,),
                Text("${widget.userProfle.fullName}",maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
              ],
            )
          )
        ],
      ),
    );
  }
  Widget _buildActionBox(){
    return Row(
      children: [
        AbItemActionElement(
          icon:Image.asset("assets/images/icons/qr-code-scan.png",width: 20,height: 20,),
          callback: (){ 
            Get.toNamed(AppRouter.pdfGenerate);
          },
        ),
        const SizedBox(width: 20,),
        AbItemActionElement(
          icon: Image.asset("assets/images/icons/notification.png",width: 20,height: 20,),
          callback: (){
            if(widget.routerHomeNotification!=null&&widget.routerHomeNotification!.isNotEmpty){
              Get.toNamed(widget.routerHomeNotification!);
            }
          },
          isNoti: true,
          child: widget.notifys.isNotEmpty?Positioned(
            right: 13,
            top: 8,
            child: Container(
              alignment: Alignment.center,
              height: 6,width: 6,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(25.0)),
            ),
          ):const SizedBox()
        )
      ],
    );
  }

  Widget _buildItemNotifyElement({required String icon,required VoidCallback callback,bool isNoti = false,Widget? child}){
    return GestureDetector(
      onTap: () => callback(),
      child: Stack(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
            ),
            child: Center(
              child: Image.asset(
                icon,
                height: 20,
                width: 20,
              ),
            ),
          ),
          isNoti == true ? (child??const SizedBox()): const SizedBox(),
        ],
      ),
    );
  }
}