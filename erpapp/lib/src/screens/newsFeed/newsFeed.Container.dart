import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'elements/boxWriteStatus.Element.dart';
import 'elements/news/newsBox.Element.dart';
import 'elements/newsFeedHeader.Element.dart';
import 'elements/stories/storiesBox.Element.dart';
import 'newsFeed.Controller.dart';

class NewsFeedScreen extends GetWidget<NewsFeedController>{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          NewsFeedHeaderElement(),
          SizedBox(height: 10,),
          BoxWriteStatusElement(),
          Divider(thickness: 5,),
          StoriesBoxElement(),
          Divider(thickness: 5,),
          ListView(
            padding: EdgeInsets.only(bottom: 40),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              NewsBoxElement(),
              Divider(thickness: 5,),
              NewsBoxElement(),
              Divider(thickness: 5,),
              NewsBoxElement()
            ],
          )
        ],
      ),
    );
  }
  
}