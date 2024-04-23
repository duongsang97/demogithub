import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListDocComponent extends StatefulWidget {
  const ShimmerListDocComponent({ Key? key, this.itemList = 9 }) : super(key: key);
  final int itemList;
  @override
  State<ShimmerListDocComponent> createState() => _ShimmerListDocComponentState();
}

class _ShimmerListDocComponentState extends State<ShimmerListDocComponent> {
  late SizedBox sizedBox;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: widget.itemList,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child:  _buildShimmerItem(),
          );
        }
      ),
    );
  }

  Widget _buildShimmerItem(){
    return SizedBox(
      width: size.width,
      height: 70.0,
      child: Shimmer.fromColors(
        baseColor: AppColor.grey,
        highlightColor: AppColor.grey.withOpacity(0.4),
        child: Row(
          children: [
            Expanded(
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