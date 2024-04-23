import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/carouselItem.Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:erpcore/utility/image.Utility.dart';

class ItemCarouselComponent extends StatelessWidget {
  const ItemCarouselComponent({ Key? key,@required this.carouselItem}) : super(key: key);
  final CarouselItemModel? carouselItem;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: ImageUtils.getURLImage((carouselItem?.link)!),
        imageBuilder: (context, imageProvider) =>Container(
        width: size.width*.95,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      placeholder: (context, url) => SpinKitChasingDots(
        size: 20,
        color: AppColor.whiteColor,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error,color: AppColor.brightRed,),
    );
  }
}