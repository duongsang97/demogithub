import 'package:erpcore/models/apps/signature/signatureAvailable.Model.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/utility/image.Utility.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';

class SignatureElement extends StatelessWidget {
  const SignatureElement({super.key, required this.signature, this.onDeleteCallBack, this.onCallBack});
  final SignatureAvailableModel signature;
  final Function()? onCallBack;
  final Function()? onDeleteCallBack;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        if (onCallBack != null) {
          onCallBack!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1), // changes the position of the shadow
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration( 
                    color: AppColor.whiteColor
                  ),
                  child: CachedNetworkImage(
                    imageUrl: ImageUtils.getURLImage(handURLImageString(signature.urlImage)),
                    width: size.width,
                    height: size.width * 0.25,
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    placeholder: (context, url) => const SizedBox(width: 40, height: 40, child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) =>
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColor.notWhite,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                        ),
                        child: Icon(Icons.image, size: 50, color: AppColor.cottonSeed)
                      ),
                  ),
                ),
                LabelText(title: "Tên: ", content: signature.name ?? ""),
              ],
            ),
            Positioned(
              left: 5,
              top: 5,
              child: ButtonDefaultComponent(
                padding: const EdgeInsets.all(2.0),
                title: "",
                titleStyle: TextStyle(color: AppColor.whiteColor,fontSize: 12),
                onPress: (){
                  if (onDeleteCallBack != null) {
                    onDeleteCallBack!();
                  }
                },
                icon: Row(
                  children: [
                    Icon(Icons.delete , size: 15, color: AppColor.whiteColor),
                  ],
                ),
                backgroundColor:AppColor.brightRed,
              )
            ),
            Positioned(
              right: 5,
              top: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                decoration: BoxDecoration(  
                  color: AppColor.brightBlue,
                  borderRadius: BorderRadius.circular(5.0)
                ),
                child: Text(signature.code ?? "", style: TextStyle(fontSize: 8, color: AppColor.whiteColor),)
              )
            ),
          ],
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  const LabelText({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0, left: 10, top: 5),
      child: RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(fontSize: 13, color: AppColor.nearlyBlack,),
          children: <TextSpan>[
            TextSpan(text: content, style: const TextStyle(fontSize: 13, color: AppColor.nearlyBlack, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}