import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListComponent extends StatefulWidget {
  const ShimmerListComponent({ Key? key, this.itemList = 7 }) : super(key: key);
  final int itemList;
  @override
  State<ShimmerListComponent> createState() => _ShimmerListComponentState();
}

class _ShimmerListComponentState extends State<ShimmerListComponent> {
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
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child:  _buildShimmerItem(),
          );
        }
      ),
    );
  }

  Widget _buildShimmerItem(){
    return SizedBox(
      width: double.maxFinite,
      height: 100.0,
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
            SizedBox(width: 5,),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(child: Container(
                    color: AppColor.grey.withOpacity(0.2),
                  ),),
                  SizedBox(height: 5,),
                    Expanded(child: Container(
                    color: AppColor.grey.withOpacity(0.2),
                  ),),
                  SizedBox(height: 5,),
                   Expanded(child: Container(
                    color: AppColor.grey.withOpacity(0.2),
                  ),),
                ],
              )
            )
          ],
        )
      ),
    );
  }
}