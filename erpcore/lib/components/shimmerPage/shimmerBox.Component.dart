import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../configs/appStyle.Config.dart';

class ShimmerBoxComponent extends StatefulWidget {
  const ShimmerBoxComponent({super.key, this.quantity = 3});
  final int quantity;
  @override
  State<ShimmerBoxComponent> createState() => _ShimmerBoxComponentState();
}

class _ShimmerBoxComponentState extends State<ShimmerBoxComponent> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return _buildShimmerBox();
  }

   Widget _buildShimmerBox(){
    return Container(
      height: Get.width * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), 
      ),
      child: Shimmer.fromColors(
        baseColor: AppColor.grey,
        highlightColor: AppColor.grey.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children:  [
            for (var i = 1; i <= widget.quantity; i++) Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), 
                  color: AppColor.grey.withOpacity(0.2),
                ),
                margin: EdgeInsets.symmetric(horizontal: 5.0),
              ),
            ), 
          ],
        )
      ),
    );
  }
}