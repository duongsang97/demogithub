import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListChatComponent extends StatefulWidget {
  const ShimmerListChatComponent({ Key? key }) : super(key: key);

  @override
  State<ShimmerListChatComponent> createState() => _ShimmerListChatComponentState();
}

class _ShimmerListChatComponentState extends State<ShimmerListChatComponent> {
  late SizedBox sizedBox;
  late Size size;
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
            child:  _buildShimmerItem(),
          );
        }
      ),
    );
  }

  Widget _buildShimmerItem(){
    return SizedBox(
      width: double.maxFinite,
      height: 60.0,
      child: Shimmer.fromColors(
        baseColor: AppColor.grey,
        highlightColor: AppColor.grey.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColor.grey.withOpacity(0.2),
                shape: BoxShape.circle
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    color: AppColor.grey.withOpacity(0.2),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: 20,
                    color: AppColor.grey.withOpacity(0.2),
                  ),
                ],
              )
            )
          ],
        )
      ),
    );
  }
}