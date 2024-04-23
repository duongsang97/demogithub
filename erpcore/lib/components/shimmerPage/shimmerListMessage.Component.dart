import 'dart:math';

import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListMessageComponent extends StatefulWidget {
  const ShimmerListMessageComponent({ Key? key }) : super(key: key);

  @override
  State<ShimmerListMessageComponent> createState() => _ShimmerListMessageComponentState();
}

class _ShimmerListMessageComponentState extends State<ShimmerListMessageComponent> {
  late SizedBox sizedBox;
  late Size size;
  Random rd = new Random();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.symmetric( horizontal: 10,vertical: 5),
            child:  _buildShimmerItem(rd.nextBool(),(50+rd.nextInt(50).toDouble())),
          );
        }
      ),
    );
  }

  Widget _buildShimmerItem(bool type,double height){
    return SizedBox(
      width: double.maxFinite,
      height: height,
      child: Shimmer.fromColors(
        baseColor: AppColor.grey,
        highlightColor: AppColor.grey.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: type?MainAxisAlignment.start:MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            type?Container(
              height: height,
              width: size.width*.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)
                ),
                color: AppColor.grey.withOpacity(0.2),
              ),
            ):Container(
              height: 60,
              width: size.width*.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)
                ),
                color: AppColor.grey.withOpacity(0.2),
              ),
            )
          ],
        )
      ),
    );
  }
}