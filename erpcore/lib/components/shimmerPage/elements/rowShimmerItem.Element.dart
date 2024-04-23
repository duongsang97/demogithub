import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RowShimmerItemElement extends StatefulWidget {
  const RowShimmerItemElement({ Key? key,this.height=50,this.widthItem,this.countItem =1}) : super(key: key);
  final double height;
  final double? widthItem;
  final int countItem;
  @override
  State<RowShimmerItemElement> createState() => _RowShimmerItemElementState();
}

class _RowShimmerItemElementState extends State<RowShimmerItemElement> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: widget.height,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(widget.countItem, (index) => Shimmer.fromColors(
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.grey.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            //margin: EdgeInsets.symmetric(horizontal: 10),
            
            height: widget.height,
            width: size.width/widget.countItem-10,
          ), 
          baseColor: AppColor.grey,
          highlightColor: AppColor.grey.withOpacity(0.4),
        ),),
      )
    );
  }

  // Widget _buildItemShimmer(){
  //   return Container(
  //     child: 
  //   );
  // }
}