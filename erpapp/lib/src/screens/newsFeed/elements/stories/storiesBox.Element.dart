import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/newsFeed/elements/stories/storiesItem.Element.dart';
import 'package:flutter/material.dart';

class StoriesBoxElement extends StatefulWidget {
  const StoriesBoxElement({ Key? key }) : super(key: key);

  @override
  State<StoriesBoxElement> createState() => _StoriesBoxElementState();
}

class _StoriesBoxElementState extends State<StoriesBoxElement> {
  final ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Text("Stories",style: TextStyle(
              color: AppColor.grey,fontSize: 18,fontWeight: FontWeight.bold
            ),),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: StoriesItemElement(
                  )
                );
              }
            ),
          )
        ],
      )
    );
  }
}