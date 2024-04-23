import 'dart:io';

import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/selectBox/selectFile.Component.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import 'package:erpcore/utility/image.Utility.dart';

import '../modalSheet/modalSheet.Component.dart';

class BoxEmpFilesComponent extends StatefulWidget {
  const BoxEmpFilesComponent({Key? key,this.boxTitle = "",required this.listFile,required this.kind,required this.onRemoveFile,required this.onChooseFile,this.isAddNewFile = true}): super(key: key);
  final String boxTitle;
  final List<PrFileUpload> listFile;
  final PrCodeName? kind;
  final Function(PrFileUpload) onRemoveFile;
  final Function(List<PrFileUpload>) onChooseFile;
  final bool isAddNewFile; // được thêm file mới nếu trạng thái bằng true || default true
  @override
  State<BoxEmpFilesComponent> createState() => _BoxEmpFilesComponentState();
}

class _BoxEmpFilesComponentState extends State<BoxEmpFilesComponent> {
  final ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
  }

  int getLengthListFile() {
    int result = 0;
    try {
      result = widget.listFile.length;
        } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "getLengthListFile BoxEmpFiles.Component");
    }
    return result;
  }

  Future<void> onSelectFile(String type) async {
    List<PrFileUpload> files = List<PrFileUpload>.empty(growable: true);
    try {
      if (type == "image") {
        var image = await picker.pickImage(
            source: ImageSource.camera, maxWidth: 1280, imageQuality: 90);
        if (image != null) {
          var file = PrFileUpload();
          file.sysCode = generateKeyCode();
          final extension = p.extension(image.path);
          file.fileAsset = image.path;
          file.fileName = image.name;
          file.kind = widget.kind;
          file.fileExt = extension;
          files.insert(0, file);
        }
      } else if (type == "gallery") {
        var gallery =
            await picker.pickMultiImage(maxWidth: 1280, imageQuality: 90);
        if (gallery.isNotEmpty) {
          for (var fileTemp in gallery) {
            var file = PrFileUpload();
            var extension = p.extension(fileTemp.path);
            file.sysCode = generateKeyCode();
            file.fileAsset = fileTemp.path;
            file.fileName = fileTemp.name;
            file.kind = widget.kind;
            file.fileExt = extension;
            files.insert(0, file);
          }
        }
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result != null) {
          List<File> _files = result.paths.map((path) => File(path!)).toList();
          if (_files.isNotEmpty) {
            for (var fileTemp in _files) {
              var file = PrFileUpload();
              file.sysCode = generateKeyCode();
              var extension = p.extension(fileTemp.path);
              file.fileAsset = fileTemp.path;
              file.fileName = p.basename(fileTemp.path);
              file.kind = widget.kind;
              file.fileExt = extension;
              files.insert(0, file);
              //widget.listFile.insert(0, file);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(width: 0.1, color: AppColor.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 10,
              blurRadius: 7,
              offset: const Offset(10, 0), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: RichText(
                text: TextSpan(
                  text: widget.boxTitle,
                  style: const TextStyle(
                    color: AppColor.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: "   "),
                    TextSpan(
                        text: "(${getLengthListFile()} file)",
                        style: TextStyle(
                            color: (getLengthListFile() > 0)
                                ? AppColor.brightRed
                                : Colors.transparent,
                            fontSize: 12)),
                  ],
                ),
              )),
            ],
          ),
          const Divider(color: AppColor.grey),
          GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: widget.listFile.length + 1,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildIconAddFile();
                } else {
                  var item = widget.listFile[index - 1];
                  return _buildIconOverviewFile(item);
                }
              }),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

//widget.isAddNewFile
  Widget _buildIconAddFile() {
    return GestureDetector(
      onTap: () {
        if (widget.isAddNewFile) {
          ModalSheetComponent.showBarModalBottomSheet(
            SelectFileBoxComponent(onSelectedType: onSelectFile,),
            formSize:0.4,
            expand: true,
            enableDrag: true
          );
        } else {
          AlertControl.push("Số lượng file đã đạt đến giới hạn", type: AlertType.ERROR);
        }
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppColor.azureColor,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 0.1, color: AppColor.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(5, 0), // changes position of shadow
              ),
            ]),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 30,
            color: AppColor.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildIconOverviewFile(PrFileUpload? file) {
    Widget child = const Icon(
      Icons.error,
      size: 30,
      color: AppColor.brightRed,
    );
    if (file != null) {
      if (checkFileOrImage(file.fileExt ?? "") == "image") {
        if (file.fileAsset != null && file.fileAsset!.isNotEmpty) {
          var _file = File(Uri.parse(file.fileAsset!).path);
          child = Image.file(
            _file,
            fit: BoxFit.contain,
          );
        } else if (file.fileName != null && file.fileName!.isNotEmpty) {
          var tempFolderPath = handURLFilePrFileUpload(file);
          child = Image.network(ImageUtils.getURLImage(tempFolderPath));
        }
      } else {
        if (file.fileAsset != null && file.fileAsset!.isNotEmpty) {
        } else {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.attach_file,
                size: 18,
                color: AppColor.brightBlue,
              ),
              Text(
                file.fileName ?? "",
                style: const TextStyle(color: AppColor.grey, fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                file.fileExt ?? "",
                style: const TextStyle(color: AppColor.brightRed, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        }
      }
    }
    return GestureDetector(
      onTap: () async {
        if (checkFileOrImage(file.fileExt ?? "") == "image") {
          if (file.fileAsset != null && file.fileAsset!.isNotEmpty) {
            Alert.dialogPhotoView(context, assetImage: file.fileAsset);
          } else if (file.fileName != null && file.fileName!.isNotEmpty) {
            var tempFolderPath = handURLFilePrFileUpload(file);
            Alert.dialogPhotoView(context, networkImage: tempFolderPath);
          }
        } else {
          if (file.fileName != null && file.fileName!.isNotEmpty) {
            var resultQuesion = await Alert.showDialogConfirm(
                "Thông báo",
                "File không hỗ trợ mở trực tiếp trên ứng dụng, bạn muốn download tập tin này xuống?");
            if (resultQuesion) {
              var tempFolderPath = handURLFilePrFileUpload(file);
              launchUrl(Uri.parse(tempFolderPath));
            }
          }
        }
            },
      child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColor.azureColor,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                  width: 0.5,
                  color: ((file!.fileAsset) != null && file.fileAsset!.isNotEmpty)
                      ? AppColor.brightRed
                      : AppColor.jadeColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(5, 0), // changes position of shadow
                ),
              ]),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              child,
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Visibility(
                    visible: (AppData.listCodeCMND.contains(file.kind?.code))
                        ? false
                        : true,
                    child: _buildButtonRemoveFile(file),
                  ))
            ],
          )),
    );
  }

  Widget _buildButtonRemoveFile(PrFileUpload file) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onRemoveFile(file);
        });
            },
      child: const Center(
        child: Icon(
          Icons.cancel,
          size: 20,
          color: AppColor.brightRed,
        ),
      ),
    );
  }
}
