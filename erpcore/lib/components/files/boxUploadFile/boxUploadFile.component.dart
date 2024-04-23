import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/boxs/elements/dashedRectPainter.element.dart';
import 'package:erpcore/components/buttons/iconButton.Component.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/components/modalSheet/models/chooseFileConfig.model.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/image.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
class BoxUploadFileComponent extends StatefulWidget {
  const BoxUploadFileComponent({super.key,required this.files,this.onChange,this.fileField="file",this.isLoading= false});
  final List<DataImageActModel> files;
  final Function(List<DataImageActModel>,String)? onChange;
  final String? fileField;
  final bool isLoading;
  @override
  State<BoxUploadFileComponent> createState() => _BoxUploadFileComponentState();
}

class _BoxUploadFileComponentState extends State<BoxUploadFileComponent> {
  final String videoIcon = "assets/images/icons/video.png";
  final String pdfIcon = "assets/images/icons/pdf-file-format.png";
  final String fileIcon = "assets/images/icons/file.png";
  final String imageIcon = "assets/images/icons/image-file.png";
  final String zipIcon = "assets/images/icons/zip-file.png";
  final String errorIcon = "assets/images/icons/file_error.png";
  late Size size;
  final isChooseFile = false;
  String getIconByFileExtention(String url){
    String result = fileIcon;
    if(ImageUtils().isImageURL(url)){
      result = imageIcon;
    }
    else if(ImageUtils().isVideoURL(url)){
      result = videoIcon;
    }
    else if(ImageUtils().isZipURL(url)){
      result = zipIcon;
    }
    else if(ImageUtils().isDocumentURL(url)){
      result = pdfIcon;
    }
    else if(url.isEmpty){
      result = errorIcon;
    }
    return result;
  }

  void onRemoveItemFile(DataImageActModel item){
    if(!widget.isLoading){
      var result = widget.files.remove(item);
      if(result){
        if(widget.onChange != null){
          widget.onChange!([item],"remove");
        }
        Alert.showSnackbar("Tập tin","Đã xoá ${item.fileName}");
        setState(() {});
      }
    }
  }

  String getPath(DataImageActModel item){
    String result = "";
    if(item.isOnline){
      result =  item.urlImage??"";
    }
    else{
      result =  item.assetsImage??"";
    }
    return result;
  }

  Future<void> openFileAtt(DataImageActModel item) async{
    try{
      String path = getPath(item);
      if(ImageUtils().isImageURL(path)){
        Alert.dialogPhotoView(context,assetImage: !item.isOnline?path:null,networkImage: item.isOnline?path:null);
      }
      else{
        launchUrl(Uri.parse(path),mode: LaunchMode.externalApplication);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "openFileAtt");
    }
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildBoxUpload(),
        const SizedBox(height: 10,),
        buildBoxFileUpload()
      ],
    );
  }

  Widget buildBoxUpload(){
    return GestureDetector(
      onTap: () async{
        if(!widget.isLoading){
          ModalSheetComponent.showChooseFileModal(
          config: ChooseFileConfigModel(isMultiple: true,formDisk: true,formCamera: true)
          ).then((value){
            if(value.statusCode == 0 && value.data != null){
              List<DataImageActModel> chooseFile = List<DataImageActModel>.empty(growable: true);
              for(PrFileUpload file in value.data){
                if(widget.files.indexWhere((element) => element.fileName == file.fileName)<0){
                  String fileName = "${generateKeyCode()}_${file.fileName}";
                  var temp = DataImageActModel(assetsImage: file.fileAsset,fileName: fileName,note: widget.fileField);
                  chooseFile.add(temp);
                }
              }
              if(widget.onChange != null){
                widget.onChange!(chooseFile,"add");
              }
              setState(() {
                widget.files.addAll(chooseFile);
              });
            }
          }).onError((error, stackTrace){
            AlertControl.push(error.toString(), type: AlertType.ERROR);
            AppLogsUtils.instance.writeLogs(error,func: "ModalSheetComponent.showChooseFileModal BoxUploadFileComponent");
          });
        }
      },
      child: Container(
        width: size.width*.9,
        height: 100,
        color: AppColor.greenMonth.withOpacity(0.1),
        child: CustomPaint(
          //painter: DashRectPainter(color: AppColor.acacyColor, strokeWidth: 0.7, gap: 5),
          painter: DottedBorderPainter(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: AppColor.aqua.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.1,color: AppColor.grey)
                ),
                child: Image.asset("assets/images/icons/upload_image.png",color: AppColor.laSalleGreen,),
              ),
              const SizedBox(height: 5,),
              const Text("Bấm để tải lên tập tin")
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBoxFileUpload(){
    return Container(
      constraints: BoxConstraints(maxHeight: size.height*.4),
      child: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 5,bottom: 5),
          shrinkWrap: true,
          itemCount: widget.files.length,
          itemBuilder: (context,index){
            var file = widget.files[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: buildItemFile(file),
            );
          }
        ),
      )
    );
  }

  Widget buildItemFile(DataImageActModel file){
    String path = getPath(file);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: AppColor.grey,width: 0.2)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    openFileAtt(file);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(10),
                        decoration:const BoxDecoration(
                          shape: BoxShape.circle
                        ),
                        child: Image.asset(getIconByFileExtention(path),width: 30,height: 30,),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(child: Text(p.basename(path),overflow: TextOverflow.ellipsis,maxLines: 2,style: const TextStyle(fontSize: 13,),)),
                      const SizedBox(width: 5,),
                    ],
                  ),
                )
              ),
              IconButtonComponent(icon:const Icon(Icons.delete_forever_outlined,color: AppColor.brightRed,size: 20,), onPress: (){onRemoveItemFile(file);})
            ],
          ),
        ),
        Visibility(
          visible: file.isOnline,
          child: Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 40,
              height: 15,
              decoration: BoxDecoration(
                color: AppColor.laSalleGreen.withOpacity(0.8),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0))
              ),
              child: const Text("Online",textAlign: TextAlign.center,style: TextStyle(fontSize: 9,color: AppColor.whiteColor,fontWeight: FontWeight.bold),),
            )
          )
        )
      ],
    );
  }
}