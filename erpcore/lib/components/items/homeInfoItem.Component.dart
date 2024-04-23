import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class HomeInfoItemComponent extends StatefulWidget {
  const HomeInfoItemComponent({ Key? key,this.callback,this.image,this.label,this.time,this.views,this.link}) : super(key: key);
  final String? label;
  final String? image;
  final String? time;
  final String? views;
  final String? link;
  final VoidCallback? callback;
  @override
  State<HomeInfoItemComponent> createState() => _HomeInfoItemComponentState();
}

class _HomeInfoItemComponentState extends State<HomeInfoItemComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: GestureDetector(
        onTap: (){
         if(widget.link != null && widget.link!.isNotEmpty){
           launchUrl(Uri.parse(widget.link??""),mode:LaunchMode.externalApplication);
         }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppColor.azureColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: Center(child: Image.asset(widget.image??"assets/images/icons/resume.png",height: 40,width: 40,),)
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: SizedBox(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.label??"",style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold),),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     Text.rich(
                    //       TextSpan(
                    //         style: TextStyle(color: AppColor.deactivatedText.withOpacity(.5),fontSize: 11),
                    //         children: [
                    //           WidgetSpan(child: Icon(Icons.schedule,size: 18,color: AppColor.deactivatedText.withOpacity(.5),),),
                    //           TextSpan(text: ' '),
                    //           TextSpan(text: '${widget.time} hours ago'),
                    //         ],
                    //       ),
                    //     ),
                    //     Text.rich(
                    //       TextSpan(
                    //         style: TextStyle(color: AppColor.deactivatedText.withOpacity(.5),fontSize: 11),
                    //         children: [
                    //           WidgetSpan(child: Icon(Icons.visibility,size: 18,color: AppColor.deactivatedText.withOpacity(.5),),),
                    //           TextSpan(text: ' '),
                    //           TextSpan(text: '${widget.views} views'),
                    //         ],
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}