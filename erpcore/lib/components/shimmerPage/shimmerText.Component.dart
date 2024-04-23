import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../configs/appStyle.Config.dart';

class ShimmerTextComponent extends StatefulWidget {
  const ShimmerTextComponent({super.key});

  @override
  State<ShimmerTextComponent> createState() => _ShimmerTextComponentState();
}

class _ShimmerTextComponentState extends State<ShimmerTextComponent> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: _buildShimmerText(),
    );
  }

  Widget _buildShimmerText(){
    return SizedBox(
      width: double.maxFinite,
      height: 20.0,
      child: Shimmer.fromColors(
        baseColor: AppColor.grey,
        highlightColor: AppColor.grey.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: AppColor.grey.withOpacity(0.2),
              ),
            ),
          ],
        )
      ),
    );
  }
}