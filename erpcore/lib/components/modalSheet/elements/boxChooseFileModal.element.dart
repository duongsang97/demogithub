import 'dart:io';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/routers/app.Router.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../utility/app.Utility.dart';
import '../models/chooseFileConfig.model.dart';
class BoxChooseFileModalElement extends StatefulWidget {
  const BoxChooseFileModalElement({super.key,required this.config,required this.onChooseFile, this.isMultiImage = false});
  final ChooseFileConfigModel config;
  final Function(List<PrFileUpload>) onChooseFile;
  final bool isMultiImage;
  @override
  State<BoxChooseFileModalElement> createState() => _BoxChooseFileModalElementState();
}

class _BoxChooseFileModalElementState extends State<BoxChooseFileModalElement> {
  final ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
  }

  Future<void> onSelectFile(String type) async {
    List<PrFileUpload> files = List<PrFileUpload>.empty(growable: true);
    try {
      if (type == "image") {
        if (!widget.isMultiImage) {
          var image = await picker.pickImage(
              source: ImageSource.camera, maxWidth: 1280, imageQuality: 90);
          if (image != null) {
            var file = PrFileUpload();
            file.sysCode = generateKeyCode();
            final extension = p.extension(image.path);
            file.fileAsset = image.path;
            file.fileName = image.name;
            file.fileExt = extension;
            files.insert(0, file);
          }
        } else {
          List<File?> listImage = await Get.toNamed(AppRouter.cameraView, arguments: {"ISMULTIIMAGE": widget.isMultiImage});
          if (listImage.isNotEmpty) {
            for (var image in listImage) {
              if (image != null) {
                var file = PrFileUpload();
                file.sysCode = generateKeyCode();
                final extension = p.extension(image.path);
                file.fileAsset = image.path;
                file.fileName = "${convertDateToTicks(await image.lastModified())}";
                file.fileExt = extension;
                files.insert(0, file);
              }
            }
          }
        }
      } else if (type == "gallery") {
        var gallery = await picker.pickMultiImage(maxWidth: 1280, imageQuality: 90);
        if (gallery.isNotEmpty) {
          if(widget.config.isMultiple == true){
            for (var fileTemp in gallery) {
              var file = PrFileUpload();
              var extension = p.extension(fileTemp.path);
              file.sysCode = generateKeyCode();
              file.fileAsset = fileTemp.path;
              file.fileName = fileTemp.name;
              file.fileExt = extension;
              files.insert(0, file);
            }
          }
          else{
            var file = PrFileUpload();
            var extension = p.extension(gallery.first.path);
            file.sysCode = generateKeyCode();
            file.fileAsset = gallery.first.path;
            file.fileName = gallery.first.name;
            file.fileExt = extension;
            files.insert(0, file);
          }
          
        }
      } 
      else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: widget.config.isMultiple);
        if (result != null) {
          List<File> _files = result.paths.map((path) => File(path!)).toList();
          if (_files.isNotEmpty) {
            for (var fileTemp in _files) {
              var file = PrFileUpload();
              file.sysCode = generateKeyCode();
              var extension = p.extension(fileTemp.path);
              file.fileAsset = fileTemp.path;
              file.fileName = p.basename(fileTemp.path);
              file.fileExt = extension;
              files.insert(0, file);
            }
          }
        } else {
          // User canceled the picker
        }
      }

      if (files.isNotEmpty) {
        widget.onChooseFile(files);
      }
    } catch (ex) {
      AlertControl.push("Có lỗi trong quá trình chọn file, vui lòng thử lại", type: AlertType.ERROR);
      AppLogsUtils.instance.writeLogs(ex,func: "onSelectFile BoxEmpFiles.Component");
    }
    
  }
  
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      height: size.height*.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(![FileType.image,FileType.media,FileType.video].contains(widget.config.type) )
                _buildActionButton("file","assets/images/icons/folder.png","File"),
              if (widget.config.formCamera == true)
                _buildActionButton("image","assets/images/icons/camera.png","Chụp hình"),
              if (widget.config.formDisk == true)
                _buildActionButton("gallery","assets/images/icons/gallery.png","Thư viện")
            ]
          ),
        ],
      )
    );
  }

  Widget _buildActionButton(String type,String image, String label){
    return GestureDetector(
      onTap: (){
        onSelectFile(type);
      },
      child: Column(
        children: [
          Image.asset(image,height: 40,width: 40,color: AppColor.jadeColor.withOpacity(0.8),),
          Text(label,style: const TextStyle(color: AppColor.grey,fontSize: 15),)
        ],
      )
    );
  }
}