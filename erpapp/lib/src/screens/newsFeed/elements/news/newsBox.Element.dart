import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/newsFeed/elements/newsFeedAvatar.Element.dart';
import 'package:flutter/material.dart';

class NewsBoxElement extends StatefulWidget {
  const NewsBoxElement({ Key? key }) : super(key: key);

  @override
  State<NewsBoxElement> createState() => _NewsBoxElementState();
}

class _NewsBoxElementState extends State<NewsBoxElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                NewsFeedAvatarElement(
                  size: 50,
                ),
                Expanded(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dương Sang",style: TextStyle(
                        color: AppColor.grey,fontWeight: FontWeight.bold,fontSize: 16
                      ),),
                      Text("vừa xong",style: TextStyle(color: AppColor.grey.withOpacity(0.9),fontSize: 13),)
                    ],
                  )
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset("assets/images/icons/three-dots.png",width: 18,height: 18,),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Hè đến khuyến mãi ngập tràn",maxLines: 6,textAlign: TextAlign.left,
              style: TextStyle(color: AppColor.grey),
            ),
          ),
          CachedNetworkImage(
            imageUrl: "https://cdn.tgdd.vn/Files/2021/11/10/1396962/ctkmt11samsung_1280x720-800-resize.jpg",
            imageBuilder: (context, imageProvider) => Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          SizedBox(height: 5,),
          _buildFeelingInfo(),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(thickness: 1,),
          ),
          SizedBox(height: 5,),
          _buildFeelingAction(),
          SizedBox(height: 5,),
        ],
      ),
    );
  }

  Widget _buildFeelingInfo(){
    return Container(
      child: Row(
        children: [
          
        ],
      ),
    );
  }

  Widget _buildFeelingAction(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/icons/like.png",height: 20,width: 20,),
                SizedBox(width: 5,),
                Text("Like")
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/icons/speech-bubble.png",height: 20,width: 20,),
                SizedBox(width: 5,),
                Text("Comment")
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/icons/share.png",height: 20,width: 20,),
                SizedBox(width: 5,),
                Text("Share")
              ],
            ),
          ),
        ],
      ),
    );
  }
} 