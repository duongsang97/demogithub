import 'package:erpcore/components/shimmerPage/elements/rowShimmerItem.Element.dart';
import 'package:flutter/material.dart';

class ShimmerProfileComponent extends StatefulWidget {
  const ShimmerProfileComponent({ Key? key,required this.listSrc }) : super(key: key);
  final List<int> listSrc;
  @override 
  State<ShimmerProfileComponent> createState() => _ShimmerProfileComponentState();
}

class _ShimmerProfileComponentState extends State<ShimmerProfileComponent> {
  late SizedBox sizedBox;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        itemCount: widget.listSrc.length,
        itemBuilder: (BuildContext context, int index){
          return RowShimmerItemElement(countItem: widget.listSrc[index],height: 60,);
        },
      ),
    );
  }
}