class CameraViewConfigModel{
  bool? faceDetect;
  bool? fullFaceRequired;
  int? numberPeople;
  WatermarkModel? watermark;
  bool? isEnableSaveGallery;
  bool? requireAutoTime;
  int? requiredGPS;
  CameraViewConfigModel({this.faceDetect=false,this.numberPeople=0,this.watermark, this.isEnableSaveGallery,this.requireAutoTime = true,this.fullFaceRequired = false, this.requiredGPS = 0});
}

class WatermarkModel{
  bool? isLogo;
  List<String>? text;

  WatermarkModel({this.isLogo,this.text});
}