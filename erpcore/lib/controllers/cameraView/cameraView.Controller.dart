import 'dart:io';
import 'package:camera/camera.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/controllers/cameraView/models/zoomScale.Model.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/image.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../components/alerts/alert.dart';
import '../../utility/app.Utility.dart';
import 'models/cameraView.Model.dart';

class CameraViewController extends GetxController{
  late CameraController cameraController;
  RxBool isLoading = true.obs;
  bool isBusy = false;
  RxString cameraStaus = "".obs;
  RxBool cameraFlag = true.obs;
  CameraViewConfigModel cameraConfig = CameraViewConfigModel();
  List<CameraDescription> camerasReady = List<CameraDescription>.empty(growable: true);
  Rx<FlashMode> flashMode = Rx<FlashMode>(FlashMode.off);
  RxBool flagHandleResult = false.obs;
  late CameraDescription cameraCurrent;
  late XFile imageResult;
  late FaceDetector faceDetector;
  bool isEnableSaveGallery = false;
  RxDouble scale = 1.0.obs;
  RxDouble previousScale = 1.0.obs;
  double minLevel = 0.0;
  double maxLevel = 0.0;
  RxList<ZoomScaleModel> listZoomScale = RxList.empty(growable: true);
  RxBool isInitFirst = true.obs;
  RxBool isVisibleZoom = true.obs;
  CameraDescription? wideBackCamera;
  RxBool isMultiTakePhoto = false.obs;
  RxList<XFile> listImageMulti = RxList.empty(growable: true);
  FaceDetectorOptions get faceDetectOption{
    FaceDetectorOptions result = FaceDetectorOptions(performanceMode:FaceDetectorMode.fast);
    if(cameraConfig.fullFaceRequired == true){
      result = FaceDetectorOptions(performanceMode:FaceDetectorMode.accurate,enableLandmarks: true,enableClassification: true);
    }
    return result;
  }
  @override
  void onInit() {
    try{
      cameraConfig = (Get.arguments != null && Get.arguments is CameraViewConfigModel)?(Get.arguments as CameraViewConfigModel):CameraViewConfigModel(faceDetect: false,numberPeople: 0);
      if (Get.arguments != null && Get.arguments is! CameraViewConfigModel && Get.arguments["ISMULTIIMAGE"] != null) {
        isMultiTakePhoto.value = Get.arguments["ISMULTIIMAGE"];
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "CameraViewController onInit");
    }
    faceDetector = FaceDetector(
      options: faceDetectOption
    );
    super.onInit();
  }

  @override
  void onReady() async{
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    camerasReady = await getAvailableCamera();
    if(camerasReady.isNotEmpty){
      CameraDescription? normalCamera = await getBackNormalCamera();
      await initCamera(camera: normalCamera); 
    }
    else{
      cameraStaus.value = "Không thể khởi tạo camera trên thiết bị";
    }
    super.onReady();
  }

  @override
  void onClose() {
    try{
      cameraController.dispose();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "cameraController.dispose() onClose");
    }
    
    faceDetector.close();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onClose();
  }

  Future<CameraDescription?> getBackWideCamera () async {
    CameraDescription? wideBackCamera;
    try {
      for (var camera in camerasReady) {
        if (camera.lensDirection == CameraLensDirection.back && await getLensInfoByCameraId(camera.name)) {
          wideBackCamera = camera;
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getBackNormalCamera cameraView_Controller");
    }
    return wideBackCamera;
  }

  Future<CameraDescription> getBackNormalCamera () async {
    CameraDescription? wideBackCamera = camerasReady.first;
    try {
      if (Platform.isAndroid) {
        for (var camera in camerasReady) {
          if (await isNormalBackCameraLens(camera)) {
            wideBackCamera = camera;
            break;
          }
        }
        wideBackCamera ??= camerasReady.firstWhere((element) => element.lensDirection == CameraLensDirection.back);
      } else if (Platform.isIOS) { //
         wideBackCamera = camerasReady.firstWhere((element) => element.lensDirection == CameraLensDirection.back);
      } else {
         wideBackCamera = camerasReady.firstWhere((element) => element.lensDirection == CameraLensDirection.back);
      }
    } catch (e) {
      wideBackCamera = camerasReady.firstWhere((element) => element.lensDirection == CameraLensDirection.back);
      AppLogsUtils.instance.writeLogs(e, func: "getBackNormalCamera cameraView_Controller");
    }
    return wideBackCamera;
  }

  // choose by press
  void setZoomScale(ZoomScaleModel levelZoom) async {
    try {
      for (var scale in listZoomScale) {
        if (scale.id == levelZoom.id) {
          isInitFirst.value = false;
          //trường hợp > 1x
          if (scale.value != null && scale.value! >= 1) {
            isLoading.value= true;
            scale.isChoose = true;
            // trường hợp kéo từ cam 0.6 lên 1x
            var temp = await getBackNormalCamera();
            if (cameraCurrent !=temp) {
              cameraCurrent = temp;
              await cameraController.dispose();
              cameraController = CameraController(cameraCurrent, ResolutionPreset.max,imageFormatGroup: ImageFormatGroup.yuv420);
              await cameraController.initialize().then((_) async{
                cameraController.setZoomLevel(levelZoom.value ?? 0);
                scale.value = levelZoom.value ?? 0;
                isLoading.value= false;
              });
            } else {
              cameraController.setZoomLevel(levelZoom.value ?? 0);
              scale.value = levelZoom.value ?? 0;
            }
            isLoading.value= false;
          } else {
            // trường hợp < 1x
            if (camerasReady.length >= 3) {
              isLoading.value= true;
              scale.isChoose = true;
              // trường hợp không có wide cam -- xử lý tạm
              wideBackCamera ??= camerasReady.firstWhere((element) => element.lensDirection == CameraLensDirection.back);
              cameraCurrent = wideBackCamera!;
              await cameraController.dispose();
              cameraController = CameraController(cameraCurrent, ResolutionPreset.max,imageFormatGroup: ImageFormatGroup.yuv420);
              cameraController.initialize().then((_) async{
                isLoading.value= false;
              });
            }
          }
          previousScale.value = levelZoom.value ?? 0;
        } else {
          scale.isChoose = false;
        }
      }
      listZoomScale.refresh();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "setZoomScale cameraView_Controller");
    }
  }

  // cập nhật trạng thái nút zoom
  void onUpdateButtonZoomValue(double scaleValue) {
    try {    
      if (scaleValue < 2 && scaleValue >= 1) {
        for (var scale in listZoomScale) {
          if (scale.id == 1) {
            scale.title = "${scaleValue.toStringAsFixed(1)}x";
            scale.value = scaleValue;
            scale.isChoose = true;
          } else {
            scale.isChoose = false;
          }
        }
        listZoomScale.refresh();
      } else if (scaleValue >= 2) {
        for (var scale in listZoomScale) {
          if (scale.id == 2) {
            scale.title = "${scaleValue.toStringAsFixed(1)}x";
            scale.value = scaleValue;
            scale.isChoose = true;
          } else {
            scale.isChoose = false;
          }
        }
        listZoomScale.refresh();
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onUpdateButtonZoomValue cameraView_Controller");
    }
  }

  // choose by scale zoom
  void onScaleUpdate(ScaleUpdateDetails details, double screenWidth, double screenHeight) async {
    try {
      if (isLoading.value == false) {
        // trường hợp cao hơn max Zoom
        if ((previousScale * details.scale) >= maxLevel) {
          scale.value = maxLevel;
          cameraController.setZoomLevel(scale.value);
          onUpdateButtonZoomValue(scale.value);
          // trường hợp zoom = min zoom
        } else if ((previousScale * details.scale) == minLevel) {
          scale.value = previousScale * details.scale;
          cameraController.setZoomLevel(scale.value);
          // trường hợp zoom < min zoom
        } else if ((previousScale * details.scale) < minLevel) {
          if (camerasReady.length >= 3) {
            // trường hợp cam hiện tại không phải wide cam
              // trường hợp không có wide cam -- xử lý tạm
            if (wideBackCamera != null && cameraCurrent != wideBackCamera) {
              isLoading.value= true;
              for (var scale in listZoomScale) {
                if (scale.value != null && scale.value! < 1) {
                  scale.isChoose = true;
                } else {
                  scale.isChoose = false;
                }
              }
              cameraCurrent = wideBackCamera!;
              await cameraController.dispose();
              cameraController = CameraController(cameraCurrent, ResolutionPreset.max,imageFormatGroup: ImageFormatGroup.yuv420);
              cameraController.initialize().then((_) async{
                cameraController.setZoomLevel(scale.value);
                Future.delayed(const Duration(milliseconds: 150),(){
                  isLoading.value= false;
                });
              });
            }
          }
          // trường hợp zoom từ wide cam => cam x1
        } else if ((previousScale * details.scale) >= minLevel && details.scale > 1 && camerasReady.length >= 3 && cameraCurrent == wideBackCamera) {
          // Trường hợp có wide cam
          isLoading.value= true;
          await cameraController.dispose();
            cameraCurrent = await getBackNormalCamera();
            cameraController = CameraController(cameraCurrent, ResolutionPreset.max,imageFormatGroup: ImageFormatGroup.yuv420);
            cameraController.initialize().then((_) async{
              cameraController.setZoomLevel(scale.value);
              onUpdateButtonZoomValue(1);
              Future.delayed(const Duration(milliseconds: 150),(){
                isLoading.value= false;
              isInitFirst.refresh();
              });
          });
        } else {
          scale.value = previousScale * details.scale;
          if (((scale.value <= 1.9 && scale.value >= 1) || scale.value > 1.9) && camerasReady.length >= 3 && cameraCurrent != wideBackCamera) {
            cameraController.setZoomLevel(scale.value);
            onUpdateButtonZoomValue(scale.value);
          }
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onScaleUpdate cameraView_Controller");
      isLoading.value = false;
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (isLoading.value == false) {
      previousScale.value = scale.value;
    }
  }

  Future<bool> checkTheFaceInPicture(XFile file) async{
    bool result = false;
    try{
      int numberPeople = cameraConfig.numberPeople??0;
      bool fullFaceRequired = cameraConfig.fullFaceRequired??false;
      InputImage inputImage = InputImage.fromFilePath(file.path);
      var _file = await compressImage(File(Uri.parse(file.path).path));
      if(_file != null){
        inputImage = InputImage.fromFilePath(_file.path);
      }
      List<Face> faces = await faceDetector.processImage(inputImage);
      List<Face> faceResult = List<Face>.empty(growable: true);
      for(var fc in faces){
        if(ImageUtils().faceValidate(fc,fullFaceRequired: fullFaceRequired) != null){
          faceResult.add(fc);
        }
      }
      if(faceResult.isNotEmpty){
        if(numberPeople > 0 && faceResult.length >= numberPeople){
          result = true;
        }
        else{
          result = true;
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "checkTheFaceInPicture");
    }
    return result;
  }

  Future<List<CameraDescription>> getAvailableCamera() async{
    var result = List<CameraDescription>.empty(growable: true);
    var cameraPer = await requirePermission(Permission.camera);
    var microphonePer = await requirePermission(Permission.microphone);
    if(cameraPer && microphonePer){
      result = await availableCameras();
    }
    else{
      AlertControl.push("Kiểm tra quyền Camera & Microphone của thiệt bi và thử lại", type: AlertType.ERROR);
    }
    return result;
  }

  void initZoomScaleList() async {
    listZoomScale.clear();
    if (camerasReady.length >= 3 && await getBackWideCamera() != null) {
      listZoomScale.add(ZoomScaleModel(id: 0, title: "0.6x", isChoose: false, value: 0.6));
      wideBackCamera = await getBackWideCamera();
    }
    listZoomScale.add(ZoomScaleModel(id: 1, title: "1x", isChoose: true, value: 1));
    listZoomScale.add(ZoomScaleModel(id: 2, title: "2x", isChoose: false, value: 2));
    listZoomScale.refresh();
  }


  Future<void> initCamera({CameraDescription? camera}) async{
    if(camera != null){
      isLoading.value= true;
      cameraCurrent = camera;
      isBusy= true;
      cameraController = CameraController(cameraCurrent, ResolutionPreset.max,imageFormatGroup: ImageFormatGroup.yuv420);
      initZoomScaleList();
      cameraController.initialize().then((_) async{
        isLoading.value = false;
        cameraController.setFlashMode(FlashMode.off);
        Future.delayed(const Duration(seconds: 1),(){
          isBusy = false;
        });
        await cameraController.lockCaptureOrientation();
        minLevel = await cameraController.getMinZoomLevel();
        maxLevel = await cameraController.getMaxZoomLevel();
        isInitFirst.value = false;
      }).catchError((Object e) {
        if (e is CameraException) {
          AppLogsUtils.instance.writeLogs(e,func: "CameraHandleController initCamera");
          switch (e.code) {
            case 'CameraAccessDenied':
              AlertControl.push("Không thể lấy quyền camera từ thiết bị, vui lòng thử lại \n[$e]", type: AlertType.ERROR);
              break;
            default:
              break;
          }
          cameraStaus.value = "Không thể khởi tạo camera trên thiết bị [$e]";
        }
      });
    }
    else{
      var questionResult = await Alert.showDialogConfirm("Thông báo","Không thể mở máy ảnh, thử lại?");
      if(questionResult){
        camerasReady = await getAvailableCamera();
        if(camerasReady.isNotEmpty){
          CameraDescription? normalCamera = await getBackNormalCamera();
          await initCamera(camera: normalCamera);
        }
      }
      else{
        Get.back();
      }
    }
  }

  IconData getIconFlashStatus(FlashMode flag){
    IconData result = Icons.flash_off;
    try{
      if(flag == FlashMode.torch){
        result = Icons.flash_on;
      }
      else if(flag == FlashMode.auto){
        result = Icons.flash_auto;
      }
      else if(flag == FlashMode.always){
        result = Icons.flash_on;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getIconFlashStatus");
    }
    return result;
  }

  Future onPressChangeFlashMode() async{
    try{
      if(cameraController.value.flashMode == FlashMode.off){
        await cameraController.setFlashMode(FlashMode.auto);
        flashMode.value = FlashMode.auto;
      }
      else if(cameraController.value.flashMode == FlashMode.auto){
       await cameraController.setFlashMode(FlashMode.off);
       flashMode.value = FlashMode.off;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onPressChangeFlashMode");
    }
  }
  Future<void> swichCamera() async{
    try {
      if(camerasReady.isNotEmpty && !isLoading.value){
        CameraDescription? camera;
        if (cameraCurrent.lensDirection == CameraLensDirection.back) {
          camera = camerasReady.firstWhere((element) => element.lensDirection == CameraLensDirection.front);
        } else {
          camera = await getBackNormalCamera();
        }
        
        if (camera.lensDirection == CameraLensDirection.back) {
          isVisibleZoom.value = true;
        } else {
          isVisibleZoom.value = false;
        }
        initCamera(camera: camera);
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e,func: "swichCamera");
    }
  }

  Future<void> onPressSaveResult() async{
    try{
      bool requireGPS = false;
      var checkStatus = await checkGPSStatus();
      if (cameraConfig.requiredGPS == 1) {
        requireGPS = true;
      }
      if (!requireGPS || (requireGPS && checkStatus)) {
        var autoTime = await DateTimeUtils().checkAutoDateTimeConfig();
        if ((autoTime.statusCode == 1 && cameraConfig.requireAutoTime == true)) {
          imageCancel();
          Get.back();
          AlertControl.push(autoTime.msg ?? "", type: AlertType.ERROR,callback: (){
          });
        } else if (isMultiTakePhoto.value && listImageMulti.isNotEmpty) {
          flagHandleResult.value = true;
          List<File?> listFile = List.empty(growable: true);
          for (var image in listImageMulti) {
            File? file = await compressImage(File(Uri.parse(image.path).path));
            if (file != null) {
              listFile.add(file);
            }
          }
          flagHandleResult.value = false;
          Get.back(result: listFile);
        } else if(imageResult.path.isNotEmpty){
          // flagHandleResult = true --> đang xử lý ko cho click nữa
          if(!flagHandleResult.value){
            flagHandleResult.value = true;
            File? file;
            file = await compressImage(File(Uri.parse(imageResult.path).path));
            if(file != null){
              if (cameraConfig.isEnableSaveGallery == true) {
                // lưu hình ảnh ra ngoài
                // await ImageUtils().imageGallerySaver(cameraConfig.watermark,file);
                flagHandleResult.value = false;
                Get.back(result: file);
              } else {
                flagHandleResult.value = false;
                Get.back(result: file);
              }
            }
            else{
              flagHandleResult.value = false;
              Get.back(result: File(Uri.parse(imageResult.path).path));
            }
          }
        }
        else{
          imageCancel();
        }
      } else {
        AlertControl.push("Vui lòng bật định vị GPS", type: AlertType.ERROR);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onPressSaveResult");
    }
  }

  void takePicture() async {
    try{
      var autoTime = await DateTimeUtils().checkAutoDateTimeConfig();
      if (autoTime.statusCode == 1 && cameraConfig.requireAutoTime == true) {
        AlertControl.push(autoTime.msg ?? "", type: AlertType.ERROR);
      } else {
        if(!isBusy){
          isBusy= true;
          cameraController.takePicture().then((value) async{
            if(cameraConfig.faceDetect == true){
              if(await checkTheFaceInPicture(value)){
                imageResult = value;
                cameraFlag.value = false;
                cameraController.pausePreview();
              }
              else{
                String msg ="Không phát hiện khuôn mặt trong hình";
                if((cameraConfig.numberPeople??0)>0){
                  msg ="Số lượng khuôn mặt tối thiểu là ${cameraConfig.numberPeople}";
                }
                AlertControl.push(msg, type: AlertType.ERROR);
              }
            }
            else{
              if (!isMultiTakePhoto.value) {
                imageResult = value;
                cameraFlag.value = false;
                cameraController.pausePreview();
              } else {
                listImageMulti.add(value);
                listImageMulti.refresh();
              }
            }
            isBusy = false;
          });
        }
      }
    }
    catch(ex){
      isBusy = false;
      AppLogsUtils.instance.writeLogs(ex,func: "takePicture");
    }
  }

  void removeImageFromListMulti(XFile file) async {
    try {
      var result = await Alert.showDialogConfirm("Xóa ảnh", "Bạn có chắc muốn xóa ảnh này không");
      if (result) {
        int index = listImageMulti.indexWhere((element) => element.path == file.path);
        if(index != -1) {
          listImageMulti.removeAt(index);
          listImageMulti.refresh();
        }
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "removeImageFromListMulti");
    }
  }

  void imageCancel() async{
    try{
      if(imageResult.path.isNotEmpty){
        File file = File(Uri.parse(imageResult.path).path);
        await file.delete();
      }
      imageResult = XFile("");
      cameraFlag.value=true;
      isLoading.value = false;
      cameraController.resumePreview();
    }
    catch(ex){
      cameraFlag.value=true;
      isLoading.value = false;
      cameraController.resumePreview();
      AppLogsUtils.instance.writeLogs(ex,func: "inageCancel");
    }
  }

  void viewImageFromListMulti (XFile file) {
    try {
      
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "viewImageFromListMulti");
    }
  }


  Future<bool> isNormalBackCameraLens(CameraDescription camera) async {
    var isNormalCamera = false;
    try {
      if (camera.lensDirection == CameraLensDirection.back) {
        const MethodChannel channel = MethodChannel('erp.native/helper');
        final bool lensType = await channel.invokeMethod('getCameraLensType', {'cameraId':camera.name});
        if (lensType != true) { // true = wide cam
          isNormalCamera= true;
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "isNormalBackCameraLens cameraView_Controller");
    }
    return isNormalCamera;
  }
}