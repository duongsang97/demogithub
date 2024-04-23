import 'package:camera/camera.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class CameraViewController extends StatefulWidget {
  const CameraViewController({super.key});

  @override
  _CameraViewControllerState createState() => _CameraViewControllerState();
}

  late CameraController controller;
  late List cameras;
  late int selectedCameraIdx;
  late CameraDescription selectedCamera;
  late CameraLensDirection lensDirection;
class _CameraViewControllerState extends State<CameraViewController>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String imagePath="";
   @override
  void initState(){
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {
          selectedCamera = cameras[selectedCameraIdx];
          lensDirection = selectedCamera.lensDirection;
        });
      }else{
        print("No camera available");
      }
      controller.setZoomLevel(1.0);
    }).catchError((err) {
      // 3
      AppLogsUtils.instance.writeLogs(err,func: "initState cameraView.Controller");
    });
  }

 @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget cameraView(BuildContext context){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(flex: 4,child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),),
      Expanded(flex: 1,child:  Container(
        color: Colors.white24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: const EdgeInsets.all(0.0),
              color: Colors.black,
              icon: const Icon(Icons.arrow_back, size: 50.0),
              onPressed: (){
                 Navigator.pop(context);
              },
          ),
           
          IconButton(
              padding: const EdgeInsets.all(0.0),
              color: Colors.black,
              icon: const Icon(Icons.camera,size: 50.0),
              onPressed: (){
                _onCapturePressed(context);
              
              },
          ),
             IconButton(
              padding: const EdgeInsets.all(0.0),
              color: Colors.black,
              icon: const Icon(Icons.switch_camera_outlined, size: 50.0),
              onPressed: (){_onSwitchCamera();},
          )
  
          ],
        ),),)
    ],
  );
}

Widget cameraReview(BuildContext context,String path){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(flex: 4,child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Image(image: FileImage(getFileByPath(path))),
      ),),
      Expanded(flex: 1,child:  Container(
        color: Colors.white24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: const EdgeInsets.all(0.0),
              color: Colors.black,
              icon: const Icon(Icons.cancel, size: 50.0),
              onPressed: (){
                 _reMovePath();
              },
          ),
           
          IconButton(
              padding: const EdgeInsets.all(0.0),
              color: Colors.black,
              icon: const Icon(Icons.save,size: 50.0),
              onPressed: (){
                Navigator.pop(context,imagePath);
              
              },
          ),
          ],
        ),),)
    ],
  );
}

void _reMovePath(){
  setState(() {
    imagePath ="";
  });
}

void _onCapturePressed(context) async {
  try {
    var pic = await controller.takePicture();
    setState(() {
      imagePath = pic.path;
    });
  } catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "_onCapturePressed cameraView.Controller");
  }
}

 Future _initCameraController(CameraDescription cameraDescription) async {
  await controller.dispose();

  // 3
  controller = CameraController(cameraDescription, ResolutionPreset.medium);

  // If the controller is updated then update the UI.
  // 4
  controller.addListener(() {
    // 5
    if (mounted) {
      setState(() {});
    }

    if (controller.value.hasError) {
      AppLogsUtils.instance.writeLogs("Camera error ${controller.value.errorDescription}",func: "_initCameraController");
    }
  });

  // 6
  try {
    await controller.initialize();
  } on CameraException catch (ex) {
    AppLogsUtils.instance.writeLogs(ex,func: "_initCameraController cameraView.Controller");
    //_showCameraException(e);
  }

  if (mounted) {
    setState(() {});
  }
}

void _onSwitchCamera() {
  selectedCameraIdx = selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
  CameraDescription selectedCamera = cameras[selectedCameraIdx];
  _initCameraController(selectedCamera);
}

 late CameraController controller;
 @override
  Widget build(BuildContext context) {
   if (!controller.value.isInitialized) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Text("Không thể khởi động camera, kiểm tra quyền ứng dụng!",style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w900,
      ),),
    );
  }

  return Scaffold(
    key: _scaffoldKey,
    body: imagePath==""?cameraView(context):cameraReview(context, imagePath)
  );
  }
}