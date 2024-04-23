import 'dart:io';

import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewAlertElement extends StatefulWidget {
  const PhotoViewAlertElement({ Key? key,this.assetImage="",this.networkImage=""}) : super(key: key);
  final String assetImage;
  final String networkImage;
  @override
  _PhotoViewAlertElementState createState() => _PhotoViewAlertElementState();
}

class _PhotoViewAlertElementState extends State<PhotoViewAlertElement> {
  ImageProvider<Object> getFileImage(){
    late ImageProvider<Object> image ;
    try{
      if(widget.assetImage.isNotEmpty){
        image = FileImage(File(Uri.parse(widget.assetImage).path));
      }
      else if(widget.networkImage.isNotEmpty){
        image = NetworkImage(widget.networkImage);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getFileImage photoViewAlert.Element");
    }
    return image;
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    return Stack(
      children: [
        PhotoView(
          imageProvider: getFileImage(),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: PopupMenuButton(
            icon: const Icon(Icons.menu,color: Colors.red,size: 40,),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 2,
                child: _buildIconPopupMenu(Icons.exit_to_app,"Thoát"),
              )
            ],
            onSelected:(v) async{
              if(v==2){
                Navigator.pop(context);
              }
            }
          )
        )
      ],
    );
  }

  Widget _buildIconPopupMenu(IconData icon,String label){
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 5,),
        Icon(icon)
      ],
    );
  }
}