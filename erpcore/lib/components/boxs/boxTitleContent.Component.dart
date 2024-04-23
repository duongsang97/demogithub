import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class BoxTitleContentComponent extends StatefulWidget {
  @override
  _BoxTitleContentComponentState createState() => _BoxTitleContentComponentState();
  final Widget child;
  final String title;
  final Icon? icon;
  final List<Widget>? actions;
  final VoidCallback? saveCallback;
  final String? note;
  final PrFileUpload? fileNote;
  final bool isLoading;
  BoxTitleContentComponent({Key? key,required this.child,required this.title, this.icon,this.actions,this.saveCallback,this.note,this.fileNote,this.isLoading = false});
}

class _BoxTitleContentComponentState extends State<BoxTitleContentComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget handleTextNote(){
    Widget result = const SizedBox();
    try{
      if(widget.note != null && widget.note!.isNotEmpty){
        if((widget.note??"").length > 50){
          var textTemp = "${widget.note!.substring(0,49)}..... ";
          result = RichText(
            text: TextSpan(
              text: textTemp,
              style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: 'Xem thêm', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Alert.dialogShow("Ghi chú",widget.note??"");
                    },
                  ),
                ],
              ),
          );
        }
        else{
          result = Text(widget.note??"",style: const TextStyle(color: Colors.redAccent));
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleTextNote boxTitleContent.Component");
    }
    return result;
  }


  Widget renderBoxHeader(Size size) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.8,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Icon(Icons.hdr_weak_outlined),
          Expanded(child:  Container(
            padding: const EdgeInsets.only(left: 10),
              child: Text(widget.title,
                style: const TextStyle(fontSize: 14,color: AppColor.brightBlue,fontWeight: FontWeight.bold),
              ),
            ),
          ), ...?widget.actions,
          ],
        ));
  }

  Widget renderBoxContainer(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5,),
        _buildNote(),
        _builFileNote(),
       widget.child
      ],
    );
  }

  Widget _buildNote(){
    if(widget.note == null){
      return const SizedBox();
    }
    else{
      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          children: [
            Row(
            children: [
              const Icon(Icons.push_pin_outlined,color: AppColor.brightBlue,),
              const SizedBox(width: 5,),
              Expanded(
                child: handleTextNote()
              )
            ],
          ),
        ],))
      );
    }
  }

  Widget _builFileNote(){
    if(widget.fileNote == null || (widget.fileNote != null && ( widget.fileNote!.fileUrl == null || widget.fileNote!.fileUrl == "" ||  widget.fileNote!.fileName == null || widget.fileNote!.fileName == ""))){
      return const SizedBox();
    }
    else{
      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          children: [
            Row(
            children: [
              const Icon(Icons.attach_file,color: Colors.redAccent,size: 20,),
              const SizedBox(width: 5,),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    var extFile = (widget.fileNote !=null && widget.fileNote!.fileExt != null)?widget.fileNote!.fileExt:"mp3";
                    if(checkFileOrImage(extFile!) == "image"){
                      var filePath = handURLFilePrFileUpload(widget.fileNote);
                      Alert.dialogPhotoView(context,networkImage: filePath);
                    }
                    else{
                      launchUrl(Uri.parse((widget.fileNote?.fileUrl)!));
                    }
                  },
                  child: Text((widget.fileNote != null && widget.fileNote!.note != null && widget.fileNote!.note!.isNotEmpty)?widget.fileNote!.note.toString():"Tập tin đính kèm",
                  overflow: TextOverflow.ellipsis,maxLines: 2,
                    style: const TextStyle(fontStyle: FontStyle.italic,decoration: TextDecoration.underline,),
                  ),
                )
              )
            ],
          ),
        ],))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          renderBoxHeader(size),
          //const SizedBox(height: 5,),
          renderBoxContainer(size),
        ],
      )
    );
  }
}