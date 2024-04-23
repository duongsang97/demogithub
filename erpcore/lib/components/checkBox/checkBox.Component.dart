import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/utility/image.Utility.dart';
import '../../configs/appStyle.Config.dart';

class CheckBoxComponent extends StatefulWidget {
  const CheckBoxComponent({Key? key,required this.item,this.callback}) : super(key: key);
  final ItemSelectDataActModel item;
  final VoidCallback? callback;
  @override
  State<CheckBoxComponent> createState() => _CheckBoxComponentState();
}

class _CheckBoxComponentState extends State<CheckBoxComponent> {
  final String iconCheckbox = "assets/images/icons/checkbox.png";
  final String iconUnChecked = "assets/images/icons/unchecked.png";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: (widget.item.linkFile != null && widget.item.linkFile!.isNotEmpty)?_buildBoxTypeImage():_buildBoxTypeNoneImage(),
    );
  }

  void onTap() {
    if(mounted){
      setState(() {
        widget.item.isChoose = !(widget.item.isChoose!);
      });
    }
    if (widget.callback != null) {
      widget.callback!();
    }
  }

  Widget _buildBoxTypeNoneImage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children:[
        _buildCheckBoxItem(),
        const SizedBox(width: 5,),
        Text(widget.item.name??"",style: const TextStyle(fontSize: 13),)
      ]
    );
  }
  Widget _buildBoxTypeImage(){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      //padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: (widget.item.isChoose == true)?AppColor.azureColor:AppColor.whiteColor,
        border: (widget.item.isChoose == true)?Border.all():null,
        borderRadius: const BorderRadius.all(Radius.circular(10.0))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckBoxItem(),
              const SizedBox(width: 5,),
              Text(widget.item.name??"")
            ],
          ),
          const SizedBox(height: 5,),
          CachedNetworkImage(
            imageUrl: ImageUtils.getURLImage(widget.item.linkFile??""),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder : (BuildContext context,img){
              return Image(image: img);
            }
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBoxItem(){
    return Image.asset(widget.item.isChoose==true?iconCheckbox:iconUnChecked,width: 30,height: 30,color: widget.item.isChoose==true?AppColor.laSalleGreen:null,);
  }
}