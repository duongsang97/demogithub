import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/utility/image.Utility.dart';

class BoxAvatarGroupComponent extends StatefulWidget {
  const BoxAvatarGroupComponent({ Key? key,required this.listPerson}) : super(key: key);
  final List<PrCodeName> listPerson;
  @override
  State<BoxAvatarGroupComponent> createState() => _BoxAvatarGroupComponentState();
}

class _BoxAvatarGroupComponentState extends State<BoxAvatarGroupComponent> {
  double itemSize =25;
  @override
  void initState() {
    super.initState();
  }

  List<Widget> handleItemSize(){
    List<Widget> listChild = [
      SizedBox(height: 30,width: double.maxFinite,),
    ];
    try{
      if(widget.listPerson.isNotEmpty){
        if(widget.listPerson.length <5){
          for(int i=0;i<widget.listPerson.length;i++){
            var temp = _buildItemAvatar(widget.listPerson[i],position: (i*15).toDouble());
            listChild.add(temp);
          }
        }
        else{
          double position = 0;
           for(int i=0;i<4;i++){
              var temp = _buildItemAvatar(widget.listPerson[i],position: position);
              listChild.add(temp);
              position += 15;
            }
            listChild.add(
              Positioned(
                left: position,
                top: 0,
                child: Container(
                  height: itemSize,width: itemSize,
                  decoration: BoxDecoration(
                    color: AppColor.brightBlue.withOpacity(0.5),
                    border: Border.all(width: 0.2,color: AppColor.brightBlue),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text("+${widget.listPerson.length-4}",maxLines: 2,style: TextStyle(color: AppColor.whiteColor,fontSize: 15,fontWeight: FontWeight.bold),),),
                )
              )
          );
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleItemSize boxAvatarGroup.Component");
    }
    return listChild;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (widget.listPerson !=null&& widget.listPerson.isEmpty)
      ?SizedBox()
      :Stack(
        alignment: AlignmentDirectional.center,
        children: handleItemSize()
      ),
    );
  }

  Widget _buildItemAvatar(PrCodeName data,{double position=0}){
    return Positioned(
      top: 0,
      left: position,
      child: CachedNetworkImage(
        imageUrl: ImageUtils.getURLImage(data.codeDisplay??""),
        imageBuilder: (context, imageProvider) => Container(
        height: itemSize,width: itemSize,
        decoration: BoxDecoration(
          border: Border.all(width: 0.2,color: AppColor.brightBlue),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(height: 20,width: 20,child: CircularProgressIndicator(),),
      errorWidget: (context, url, error) => Container(
        height: itemSize,width: itemSize,
        decoration: BoxDecoration(
          border: Border.all(width: 0.3,color: AppColor.jadeColor,),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person,color: AppColor.jadeColor,),
      ),
    ),
  );
  }
}