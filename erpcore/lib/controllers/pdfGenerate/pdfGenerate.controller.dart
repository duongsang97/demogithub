import 'dart:io';
import 'dart:typed_data';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/controllers/pdfGenerate/models/pdfItemPage.Model.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfGenerateController extends GetxController{
  RxBool isLoading = false.obs;
  RxList<PDFItemPageModel> PDFItems = RxList<PDFItemPageModel>.empty(growable: true);
  RxList<Widget> PDFPageRender = RxList<Widget>.empty(growable: true);
  late BuildContext context;
  RxBool isMovePage = false.obs;
  RxBool inProcessing = false.obs;
  TextEditingController txtFileSizeController = TextEditingController();
  TextEditingController txtFileNameController = TextEditingController();
  Uint8List currentPDFFile = Uint8List(0);
  RxBool isCallBackResult = false.obs;
  bool isMultiImage = false;
  
  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments["CALLBACKRESULT"] != null) {
      isCallBackResult.value = Get.arguments["CALLBACKRESULT"];
    }
    if (Get.arguments != null && Get.arguments["ISMULTIIMAGE"] != null) {
      isMultiImage = Get.arguments["ISMULTIIMAGE"];
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  updatePage(){
    for(var i = 0; i< PDFItems.length;i++){
      PDFItems[i].page = i+1; 
    }
  }

  void handleAddFile(List<PrFileUpload> files){
    try{
      int lastPage = (PDFItems.isNotEmpty?(PDFItems.last.page??0):0)+1;
      for(var item in files){
        PDFItemPageModel pageItem = PDFItemPageModel(
          asset: item.fileAsset,
          code: generateKeyCode(),
          page: lastPage,
          status: 0
        );
        PDFItems.add(pageItem);
        lastPage++;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleAddFile");
    }
  }
  
  void handleDragStarted() {
    ScaffoldMessenger.of(context).clearSnackBars();
    const snackBar = SnackBar(
      content: Text('Di chuyển thứ tự trang!'),
      duration: Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleDragEnd() {
    ScaffoldMessenger.of(context).clearSnackBars();
    const snackBar = SnackBar(
      content: Text('Hoàn thành!'),
      duration: Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> onPressItemPage(PDFItemPageModel item) async{

  }

  void updateAllStatus({int status =0}){
    for(int i =0; i< PDFItems.length;i++){
      PDFItems[i].status =status;
    }
  }
  Future<void> createPDF() async{
   try{
     final pdf = pw.Document();
      if(PDFItems.isNotEmpty && !isLoading.value){
        updateAllStatus(status: 0);
        inProcessing.value = true;
        isLoading.value = true;
        PDFItems.sort((a,b)=>a.page!.compareTo(b.page!));
        for(int i =0; i< PDFItems.length;i++){
          if(inProcessing.value == true){
            PDFItems[i].status =1;
            PDFItems.refresh();
            await Future.delayed(const Duration(milliseconds: 500));
            final image = pw.MemoryImage(
              File(Uri.parse(PDFItems[i].asset??"").path).readAsBytesSync(),
            );
            pdf.addPage(pw.Page(build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image),
              ); // Center
            })); 
            PDFItems[i].status = 2;
            PDFItems.refresh();
          }
          else{
            // set lại toàn bộ trạng thái;
            updateAllStatus(status: 0);
            break;
          }
        }
        LoadingComponent.show(msg: "Đang tạo file");
        currentPDFFile = await pdf.save();
        txtFileNameController.text = generateKeyCode();
        txtFileSizeController.text = "${(currentPDFFile.lengthInBytes/1000000).toStringAsFixed(2)} MB";
        LoadingComponent.dismiss();
        await ModalSheetComponent.showBarModalBottomSheet(
          boxSetupSaveFile,
          title: "Save as",
          formSize: 0.4
        );
        
        isLoading.value = false;
        inProcessing.value = false;
      }
   }
   catch(ex){
    isLoading.value = false;
    inProcessing.value = false;
    AppLogsUtils.instance.writeLogs(ex,func: "createPDF");
   }
  }

  Widget get boxSetupSaveFile{
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextInputComponent(
              controller: txtFileSizeController,
              enable: false,
              title: "Size",
            ),
            const SizedBox(height: 5,),
            TextInputComponent(
              controller: txtFileNameController,
              title: "Tên file (.pdf)",
            ),
            const SizedBox(height: 10,),
            Align(
              child: SizedBox(
                width: 100,
                child: ButtonDefaultComponent(
                  title: "Lưu",
                  onPress: () async{
                    var filePath = await getTemporaryDirectory();
                    var fileResult = "${filePath.path}/${txtFileNameController.text}.pdf";
                    var pathResult = await FileSaver.instance.saveFile(
                      bytes: currentPDFFile,
                      filePath: filePath.path,

                      name: "${txtFileNameController.text}.pdf",
                      mimeType: MimeType.pdf
                    );
                    moveFile(File(pathResult),fileResult);
                    Get.back(result: fileResult);
                    if (isCallBackResult.value == true) {
                      Get.back(result: fileResult);
                    }
                  },
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}