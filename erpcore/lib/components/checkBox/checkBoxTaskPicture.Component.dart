import 'dart:io';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/md5s/criterias5s.Model.dart';
import 'package:erpcore/routers/app.Router.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckBoxTaskPictureComponent extends StatefulWidget {
  const CheckBoxTaskPictureComponent({ Key? key,this.item}) : super(key: key);
  final Criterias5sModel? item;
  @override
  CheckBoxTaskPictureComponentState createState() => CheckBoxTaskPictureComponentState();
}

class CheckBoxTaskPictureComponentState extends State<CheckBoxTaskPictureComponent> {
  bool checkImageAvailability(){
    bool result = false;
    if(widget.item!.imageBase64 != null && widget.item!.imageBase64!.isNotEmpty){
      result = true;
    }
    return result;
  }

  Future<String> takePicture() async{
    String result = "";
    late File photo;
    try{
      var temp = await Get.toNamed(AppRouter.cameraView);
      if(temp != null){
        photo = temp;
      }
      result = convertImageToBase64(photo.path);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "takePicture checkBoxTaskPicture.Component");
      try{
        String path = await getFilePath();
        photo.copy(path);
        result = path;
      }
      catch(ex){
        AppLogsUtils.instance.writeLogs(ex,func: "takePicture getFilePath checkBoxTaskPicture.Component");
        AlertControl.push( ex.toString(), type: AlertType.ERROR);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: widget.item?.checked, 
                onChanged: (v){
                  setState(() {
                    widget.item?.checked =v!;
                  });
                }
              ),
              const SizedBox(width: 5,),
              Expanded(child: Text(widget.item!.name??'',style: TextStyle(
                color: widget.item!.checked==true?Colors.grey[600]:Colors.red,fontSize: 14),
              ),)
            ],
          )
        ),
        const SizedBox(width: 5,),
        _buildIconTaskPicture()
      ],
    );
  }

  Widget _buildIconTaskPicture(){
    return GestureDetector(
      onTap: () async{
        if(checkImageAvailability()){
          setState(() {
            widget.item?.imageBase64 = "";
          });
        }
        else{
          String v = await takePicture();
          setState(() {
            widget.item?.imageBase64 = v;
          });
        }
      },
      child: SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            (widget.item?.imageBase64 != null && widget.item!.imageBase64!.isNotEmpty)
            ?Image.memory(imageFromBase64String((widget.item?.imageBase64)!))
            :const Icon(Icons.camera_enhance,size: 40,color: AppColor.jadeColor,),
            Positioned(
              top: 0,
              right: 5,
              child: Visibility(
                visible: false,
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: GestureDetector(
                    child: const Center(child: Icon(Icons.cancel,color: Colors.red,),)
                  ),
                ),
              )
            )
          ],
        )
      )
    );
  }
}