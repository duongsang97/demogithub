import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../configs/appStyle.Config.dart';

class ShimmerListBoxComponent extends StatefulWidget {
  const ShimmerListBoxComponent({super.key, this.quantity = 8});
  final int quantity;
  @override
  State<ShimmerListBoxComponent> createState() => _ShimmerBoxComponentState();
}

class _ShimmerBoxComponentState extends State<ShimmerListBoxComponent> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /(MediaQuery.of(context).size.height / 2),
        ),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: widget.quantity,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child:  _buildShimmerBox(),
          );
        }
      );
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), 
                  color: AppColor.grey.withOpacity(0.2),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}