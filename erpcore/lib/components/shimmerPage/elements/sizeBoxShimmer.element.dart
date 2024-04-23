import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../configs/appStyle.Config.dart';

class SizeBoxShimmerElement extends StatefulWidget {
  const SizeBoxShimmerElement({super.key,this.height =30,this.width=30});
  final double? height;
  final double? width;
  @override
  State<SizeBoxShimmerElement> createState() => _SizeBoxShimmerElementState();
}

class _SizeBoxShimmerElementState extends State<SizeBoxShimmerElement> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.grey,
      highlightColor: AppColor.grey.withOpacity(0.4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        constraints: BoxConstraints(
          maxWidth: widget.width??50,
          maxHeight: widget.height??50
        ),
      ), 
    );
  }
}