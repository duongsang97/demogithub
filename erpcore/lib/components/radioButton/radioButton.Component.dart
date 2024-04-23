import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/utility/image.Utility.dart';
import '../../configs/appStyle.Config.dart';

class RadioButtonComponent extends StatefulWidget {
  const RadioButtonComponent({Key? key,required this.item,this.itemSelected,required this.onChanged, this.widthRadio}) : super(key: key);
  final ItemSelectDataActModel item;
  final ItemSelectDataActModel? itemSelected;
  final Function(ItemSelectDataActModel) onChanged;
  final double? widthRadio;
  @override
  State<RadioButtonComponent> createState() => _RadioButtonComponentState();
}

class _RadioButtonComponentState extends State<RadioButtonComponent> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return (widget.item.linkFile != null && widget.item.linkFile!.isNotEmpty)?_buildBoxTypeImage():_buildBoxNoneImage();
  }

  Widget _buildBoxNoneImage(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          _buildSelectItem(),
          Expanded(child:  GestureDetector(
              onTap: (){
                widget.onChanged(widget.item);
              },
              child: Text(widget.item.name??"",style: TextStyle(fontSize: 13),)
            )
          )
        ]
      ),
    );
  }

  Widget _buildBoxTypeImage(){
    return GestureDetector(
      onTap: (){
        widget.onChanged(widget.item);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        //padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: widget.itemSelected?.code == widget.item.code ?AppColor.azureColor:AppColor.whiteColor,
          border: widget.itemSelected?.code == widget.item.code?Border.all():null,
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSelectItem(),
                SizedBox(width: 5,),
                Expanded(child: Text(widget.item.name??""))
              ],
            ),
            SizedBox(height: 5,),
            CachedNetworkImage(
              imageUrl: ImageUtils.getURLImage(widget.item.linkFile??""),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Image(image: imageProvider,width: size.width/3,height: size.width/3)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectItem(){
    return Container(
      width: widget.widthRadio,
      child: Radio(value: widget.item,activeColor: Colors.green, onChanged: (e){
        widget.onChanged(widget.item);
        },
        groupValue: widget.itemSelected,
        splashRadius:0.5,
        visualDensity:VisualDensity(horizontal: 0)
      ),
    );
  }
}