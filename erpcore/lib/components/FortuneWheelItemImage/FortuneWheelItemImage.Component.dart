import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/models/activations/giftAct.Model.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/utility/image.Utility.dart';

class FortuneWheelItemImageComponent extends StatefulWidget {
  @override
  _FortuneWheelItemImageComponentState createState() => _FortuneWheelItemImageComponentState();

  GiftActModel giftInfo;
  FortuneWheelItemImageComponent({required this.giftInfo});
}

class _FortuneWheelItemImageComponentState extends State<FortuneWheelItemImageComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget renderImage(){
    if(widget.giftInfo != null &&  widget.giftInfo.imageAsset != null && widget.giftInfo.imageAsset != "")
    {
      return Image.asset(widget.giftInfo.imageAsset,height: 80,width: 80);
    }
    else if (widget.giftInfo != null &&  widget.giftInfo.urlImage != null && widget.giftInfo.urlImage != ""){
      return CachedNetworkImage(
        imageUrl: ImageUtils.getURLImage(widget.giftInfo.urlImage),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
          imageBuilder : (BuildContext context,img){
            return Image(image: img,height: 60,width: 60);
          }
        );
    }
    else{
      return Text(widget.giftInfo.decription??"");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SizedBox(),flex: 1,),
          Expanded(child: renderImage(),flex: 2,)
        ],
      )
    );
  }
}