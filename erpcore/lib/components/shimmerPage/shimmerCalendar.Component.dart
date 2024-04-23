import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCalenderComponent extends StatefulWidget {
  const ShimmerCalenderComponent({ Key? key }) : super(key: key);

  @override
  State<ShimmerCalenderComponent> createState() => _ShimmerCalenderComponentState();
}

class _ShimmerCalenderComponentState extends State<ShimmerCalenderComponent> {
  late SizedBox sizedBox;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            //load thứ trong tuần
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(  crossAxisCount: 7,),
              itemCount:  7,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  child: Shimmer.fromColors(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                    ),
                    baseColor: AppColor.grey,
                    highlightColor: AppColor.grey.withOpacity(0.4),
                  )
                );
              }
            ),
          ),
          Container(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount:  30,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  child: Shimmer.fromColors(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                    ),
                    baseColor: AppColor.grey,
                    highlightColor: AppColor.grey.withOpacity(0.4),
                  )
                  );
                },
              ),
            ),
        ],
      )
    );
  }

  
}