import 'package:erpcore/components/modalSheet/elements/boxChooseFileModal.element.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../boxs/boxModalBottom.Component.dart';
import 'models/chooseFileConfig.model.dart';

class ModalSheetComponent{
  static Future showBarModalBottomSheet(Widget child,{double formSize= 0.3,String title = "",Function? onCancel,Function? whenComplete,BuildContext? context,bool isDismissible=false,bool useSafeArea = true,bool enableDrag = true, bool expand = false,Widget? titleWidget, Widget? actionWidget}) async{
    BuildContext _context;
    if(context == null){
      _context = Get.context!;
    }
    else{
      _context = context;
    }
    return await showModalBottomSheet(context: _context,
      isDismissible:isDismissible,
      isScrollControlled: expand,
      useSafeArea: useSafeArea,
      enableDrag:enableDrag,
      builder: (context){
        return BoxModalBottomComponent(
          onCancel: onCancel,
          formSize: formSize,
          title: title,
          titleWidget: titleWidget,
          actionWidget: actionWidget,
          child: child
        );
      },
    ).whenComplete((){
      if(whenComplete != null){
        whenComplete();
      }
    });
  }
  static Future<ResponsesModel> showChooseFileModal({bool isMultiImage = false, double formSize= 0.3,String title = "",Function? onCancel,BuildContext? context,bool isDismissible=false,bool useSafeArea = false,bool enableDrag = true, bool expand = false,Widget? titleWidget,ChooseFileConfigModel? config}) async{
    ResponsesModel result = ResponsesModel(statusCode: 1,msg: "Không có file được chọn",data: []);
    config ??= ChooseFileConfigModel(isMultiple: true,type: FileType.image,formCamera: true,formDisk: true);
    BuildContext _context;
    if(context == null){
      _context = Get.context!;
    }
    else{
      _context = context;
    }
    await showModalBottomSheet(context: _context,
      isDismissible:isDismissible,
      isScrollControlled: expand,
      useSafeArea: useSafeArea,
      enableDrag:enableDrag,
      builder: (context){
        return BoxModalBottomComponent(
          onCancel: onCancel,
          formSize: formSize,
          title: title,
          titleWidget: titleWidget,
          child: BoxChooseFileModalElement(
            config: config!,
            isMultiImage: isMultiImage,
            onChooseFile: (List<PrFileUpload> list){
              result.statusCode = 0;
              result.data = list;
              result.msg = "Thành công";
              Get.back();
            },
          )
        );
      },
    ).whenComplete((){
      return result;
    }).onError((error, stackTrace){
      result.statusCode =1;
      result.msg = error.toString();
      return result;
    });
    return result;
  }
}