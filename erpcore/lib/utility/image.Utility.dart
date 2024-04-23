import 'dart:io';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/controllers/cameraView/models/cameraView.Model.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:image/image.dart' as ui;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'app.Utility.dart';
import 'package:google_mlkit_face_detection/src/face_detector.dart';
import 'package:path/path.dart' as p;
class ImageUtils{
  Map<String,int> getWidthImage(File image){
    Map<String,int> result = {"h":0,"w":0};
    try{
      ui.Image? originalImage = ui.decodeImage(image.readAsBytesSync());
      if(originalImage != null){
        result = {
          "h": originalImage.height,
          "w": originalImage.width,
        };
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getWidthImage");
    }
    return result;
  }
  Future<bool> imageGallerySaver(WatermarkModel? info,File image, {String time = ""}) async{
    var isGallery = false;
    try{
      var isSaveGallery = PreferenceUtility.getBool("isGalleryConfig");
      if(isSaveGallery && info != null && image.existsSync()){
        File imageResult = await copyFile(image);
        AppLogsUtils.instance.writeLogs("Gallery save",func: "imageGallerySaver");
        if(info.isLogo??false){
          imageResult =  await watermarkPicture(imageResult);
        }
        if((info.text??[]).isNotEmpty){
          var tempList = info.text!.map<String>((e) => e).toList();
          if (time != "") {
            tempList.add(time);
          } else {
            tempList.add(DateTimeUtils().dateTimeFormat(null,isTimeZone: true));
          }
          
          var size = getWidthImage(image);
          int sizeText = (32+30)* info.text!.length;
          int yPoint = (size["h"]??sizeText) - sizeText;
          imageResult = await watermarkStringToPicture(imageResult,tempList,start_X: 30,start_Y: yPoint,space: 30);
        }
        var resultSave = await ImageGallerySaver.saveFile(imageResult.path);
        imageResult.deleteSync();
        AppLogsUtils.instance.writeLogs(resultSave,func: "imageGallerySaver ImageUtils");
        if (resultSave != null && resultSave["isSuccess"]) {
          isGallery = resultSave["isSuccess"];
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "imageGallerySaver");
      return isGallery;
    }
    return isGallery;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File?> getWatermark() async{
    File? result;
    try{
      String assetPath = "assets/images/logos/logo_acacy.png";
      if(AppConfig.appPackageName.contains("spiral")){
        assetPath = "assets/images/logos/logo_spiral.png";
      }
      result = await getImageFileFromAssets(assetPath);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getWatermark ImageUtils");
    }
    return result;
  }

  Future<ByteData?> loadAssetFont() async{
    ByteData? result;
    try{
      const pathFont = "assets/fonts/Roboto-Bold.ttf.zip";
      result = await rootBundle.load(pathFont);
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "loadAssetFont ImageUtils");
    }
    return result;
  }

  Future<File> watermarkPicture(File picture) async {
    File result = picture;
    try{
      File? watermark = await getWatermark();
      if(watermark != null && watermark.existsSync()){
        ui.Image? originalImage = ui.decodeImage(picture.readAsBytesSync());
        ui.Image? watermarkImage = ui.decodeImage((watermark.readAsBytesSync()));
        ui.Image watermarkImageBlur = ui.gaussianBlur(watermarkImage!,radius: 10);
        final int positionX = (originalImage!.width / 2 - watermarkImageBlur.width / 2).toInt();
        final int positionY = (originalImage.height - watermarkImageBlur.height * 1.15).toInt();
        var data = ui.compositeImage(originalImage,watermarkImageBlur,dstX: positionX,dstY: positionY,center: true);
        String fileName = basename(picture.path);
        final File watermarkedFile = File('${(await getTemporaryDirectory()).path}/$fileName');
        await watermarkedFile.writeAsBytes(ui.encodeJpg(data));
        result = watermarkedFile;
      }
      else{
        AppLogsUtils.instance.writeLogs("watermark is null or watermark not exists",func: "watermarkPicture ImageUtils");
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "watermarkPicture");
    }
    return result;
  }


  Future<File> watermarkStringToPicture(File picture,List<String> txtDatas,{int start_X = 0, int start_Y = 0,int space =20}) async {
    File result = picture;
    try{
      ui.Image? decodeImg = ui.decodeImage(picture.readAsBytesSync());
      ByteData? fBitMapFontData = await loadAssetFont();
      if(decodeImg != null && fBitMapFontData != null){
        ui.BitmapFont requiredRobotoFont = ui.BitmapFont.fromZip(fBitMapFontData.buffer.asUint8List());
        int x = start_X;
        int y = start_Y;
        for(var item in txtDatas){
          decodeImg = ui.drawString(decodeImg!,item,font: requiredRobotoFont,x: x,y: y);
          y+=space;
        }
        String fileName = basename(picture.path);
        final File watermarkedFile = File('${(await getTemporaryDirectory()).path}/$fileName');
        await watermarkedFile.writeAsBytes(ui.encodeJpg(decodeImg!));
        result = watermarkedFile;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "watermarkPicture");
    }
    return result;
  }

  Future<bool> saveImageFromDataImage(WatermarkModel? info,DataImageActModel item) async{
    bool result = false;
    try{
      if(item.assetsImage != null && item.assetsImage!.isNotEmpty && File(Uri.parse(item.assetsImage!).path).existsSync() && File(Uri.parse(item.assetsImage!).path).lengthSync() > 0  && item.isGallery != true){
        String imageTime = "";
        String tickImage = (item.assetsImage!.split("/").last).split(".").first;
        int? tick = int.tryParse(tickImage);
        if (tick != null) {
          imageTime = DateTimeUtils().dateTimeFormat(convertTicksToDate(tick));
        }
        result = await imageGallerySaver(info,File(Uri.parse(item.assetsImage!).path), time: imageTime); // khi nào thành công (isSuccess = true)
      } else if (item.isGallery == true) {
        result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "saveImageFromDataImage");
    }
    return result; 
  }

 static String getURLImage(String imageURL,{String? defaultImage}){
    String result = imageURL;
    if(defaultImage != null && defaultImage.isNotEmpty){
      result = defaultImage;
    }
    try{
      if(imageURL.isNotEmpty){
        String fileToken = PreferenceUtility.getString(AppKey.keyTokenFile);
        result = "$imageURL?fileToken=$fileToken";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getURLImage");
    }
    return result;
  }
  
  Face? faceValidate(Face? face,{bool fullFaceRequired = false}){
    Face? result;
    try{
      if(face != null){
        if(!fullFaceRequired){
          result = face;
        }
        else { 
          if(face.smilingProbability != null && face.smilingProbability! >= 0.2){
            result = face;
          }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "faceValidate ImageUtils");
    }
    return result;
  }

  bool isImageURL(String url) {
    final extension = p.extension(url);
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return imageExtensions.contains(extension);
  }
  bool isVideoURL(String url) {
    final extension = p.extension(url);
    final imageExtensions = [".mp4", ".mov", ".avi", ".webm"];
    return imageExtensions.contains(extension);
  }
  bool isZipURL(String url) {
    final extension = p.extension(url);
    final imageExtensions = [".zip", ".rar", ".7zip"];
    return imageExtensions.contains(extension);
  }
  bool isDocumentURL(String url) {
    final extension = p.extension(url);
    final imageExtensions = [".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".odt"];
    return imageExtensions.contains(extension);
  }

}