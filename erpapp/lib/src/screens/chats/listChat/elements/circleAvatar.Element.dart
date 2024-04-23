import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/utility/image.Utility.dart';

class CircleAvatarElement extends StatefulWidget {
  const CircleAvatarElement({ Key? key,this.imageNetwork,this.isOnline=false,this.size=60,this.showOnlineStatus=true}) : super(key: key);
  final String? imageNetwork;
  final bool isOnline;
  final double size;
  final showOnlineStatus;
  @override
  State<CircleAvatarElement> createState() => _CircleAvatarElementState();
}

class _CircleAvatarElementState extends State<CircleAvatarElement> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          decoration: const BoxDecoration(
           
          ),
        ),
        CachedNetworkImage(
          imageUrl: ImageUtils.getURLImage(widget.imageNetwork ?? "",defaultImage: "https://erp.acacy.com.vn/assets/images/avatar/default.png"),
          imageBuilder: (context, imageProvider) => Container(
            height: widget.size,
            width: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Container(
            height: widget.size,
            width: widget.size,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/icons/default_avatar.png"),
                fit: BoxFit.cover,
              )
            ),
          ),
        ),
        Visibility(
          visible: widget.showOnlineStatus,
          child: Positioned(
            bottom: 0,
            right: (widget.size*.20),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: (widget.isOnline)?AppColor.jadeColor:AppColor.brightRed,
                shape: BoxShape.circle
              ),
            ),
          ),
        )
      ],
    );
  }
}