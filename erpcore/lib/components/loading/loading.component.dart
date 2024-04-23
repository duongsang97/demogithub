import 'dart:async';

import 'package:erpcore/components/loading/models/loadingConfig.model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import '../progressBar/circularProgressBar.Component.dart';
import 'datas/loadingType.data.dart';
import 'dart:math' as math;

import 'models/loadingState.model.dart';

class LoadingComponent {
  static final LoadingComponent _singleton = LoadingComponent._();
  static LoadingComponent get instance => _singleton;
  Stream<LoadingStatesModel?> get showStatus => _streamTypeLoadingController.stream;
  LoadingComponent._();
  static LoadingConfigModel config = LoadingConfigModel();
  static final StreamController<LoadingStatesModel?> _streamTypeLoadingController = StreamController<LoadingStatesModel?>.broadcast();
  static bool initState = false;
  static Widget init(){
    return const LoadingComponentUI();
  }

  static void show({LoadingType? type,String msg ="",double? process = 0}){
    type ??= LoadingType.DEFAULT;
    var state = LoadingStatesModel(type: type,msg: msg,processing: process,init: initState);
    _streamTypeLoadingController.sink.add(state);
    initState = false;
  }
  static void dismiss(){
    initState = true;
    _streamTypeLoadingController.sink.add(null);
  }
}
class LoadingComponentUI extends StatefulWidget {
  const LoadingComponentUI({super.key});
  @override
  State<LoadingComponentUI> createState() => _LoadingComponentUIState();
}

class _LoadingComponentUIState extends State<LoadingComponentUI> with SingleTickerProviderStateMixin{
  final loadingStates = LoadingComponent.instance;
  late final AnimationController animationController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  bool get isPlaying => downloadConrollerr?.isActive ?? false;
  Artboard? riveArtboard;
  SMIInput<double>? processDowload;
  SMIInput<double>? anchorDowload;
  SMIInput<bool>? start;
  SMIInput<bool>? reset;
  StateMachineController? downloadConrollerr;
  LoadingStatesModel? loadingState;
  late Size? size;
  void onRiveInit() {
    rootBundle.load('assets/rive/download.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        String stateMachineName = artboard.stateMachines.first.name;
        var controller = StateMachineController.fromArtboard(artboard, stateMachineName);
        if (controller != null) {
          artboard.addController(controller);
          start = controller.findInput('Start');
          reset = controller.findInput('Reset');
          anchorDowload = controller.findInput('Anchor');
          processDowload = controller.findInput('Progress');
        }
        setState(() {
          start?.value =true;
          reset?.value = true;
          anchorDowload?.value = 100;
          processDowload?.value = 0;
          riveArtboard = artboard;
        });
      },
    );
  }

  BorderRadiusGeometry? get borderRadiusByType{
    BorderRadiusGeometry? result;
    if(LoadingComponent.config.overlayType ==OverlayType.CENTER){
      result = const BorderRadius.all(Radius.circular(20.0));
    }
    return result;
  }

  EdgeInsetsGeometry? get paddingByType{
    EdgeInsetsGeometry? result;
    if(LoadingComponent.config.overlayType ==OverlayType.CENTER){
      result = const EdgeInsets.all(40.0);
    }
    return result;
  }

  Map<String,dynamic> get sizeByType{
    Map<String,dynamic> result = <String,dynamic>{"height": null,"width": null};
    if(LoadingComponent.config.overlayType ==OverlayType.FULL){
      result = {"height": size?.height,"width": size?.width};
    }
    else if(LoadingComponent.config.overlayType ==OverlayType.CENTER){
      result = {"height":  (size?.width??0)*.5,"width": (size?.width??0)*.7};
    }
    return result;
  }

  void updateProcessDownload({double process = 0}){
    try{
      setState(() {
        start?.value =true;
        processDowload?.value =process;
      });
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "updateProcessDownload");
    }
  }

  @override
  void initState() {
    super.initState();
    onRiveInit();
    LoadingComponent.instance.showStatus.listen((event) { 
      setState(() {
        loadingState = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return Visibility(
      visible: loadingState !=null,
      child: GestureDetector(
        onTap: (){
          if(LoadingComponent.config.dismissible){
            LoadingComponent.dismiss();
          }
        },
        child: AnimatedContainer(
          height: sizeByType["height"],
          width: sizeByType["width"],
          duration: const Duration(milliseconds: 400),
          padding:  paddingByType,
          decoration: BoxDecoration(
            color: (LoadingComponent.config.backgroundColor??Colors.black).withOpacity(LoadingComponent.config.shadow!),
            borderRadius: borderRadiusByType
          ),
          child: Center(
            child: buildLoading(loadingState)
          )
        ),
      )
    );
  }

  Widget buildLoading(LoadingStatesModel? states){
    if(states != null){
      if(states.type ==  LoadingType.DEFAULT){
        return buidlDefaultLoading(msg: states.msg);
      }
      else if(states.type ==  LoadingType.DOWNLOAD){
        return buildDownloading(msg: states.msg,process: states.processing??0);
      }
      else if(states.type ==  LoadingType.UPLOAD){
        return buildUploading(msg: states.msg,process: states.processing??0);
      }
    }
    return const SizedBox();
  }

  Widget buildUploading({String msg ="",double process = 0}){
    Size? size = LoadingComponent.config.size;
    size??= const Size(40,40);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressBarComponent(
          processValue: (process>1)?(process/100):process,
          size: size.width,
          labelColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.4),
          strokeWidth: 10
        ),
        Visibility(
          visible: msg.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(msg,maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,fontSize: 13),),
          )
        )
      ],
    );
  }

  Widget buildDownloading({String msg ="",double process = 0}){
    Size? size = LoadingComponent.config.size;
    size??= const Size(40,40);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressBarComponent(
          processValue: (process>1)?(process/100):process,
          size: size.width,
          labelColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.4),
          strokeWidth: 10
        ),
        Visibility(
          visible: msg.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(msg,maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,fontSize: 13),),
          )
        )
      ],
    );
  }

  Widget buidlDefaultLoading({String msg =""}){
    Size? size = LoadingComponent.config.size;
    size??= const Size(60,60);
    Widget child = const SizedBox();
    if(LoadingComponent.config.image != null && LoadingComponent.config.image!.isNotEmpty){
      child = AnimatedBuilder(
        animation: animationController,
        builder: (_, child) {
          return Transform.rotate(
            angle: animationController.value * 2 * math.pi,
            child: child,
          );
        },
        child: Image.asset(LoadingComponent.config.image!,width: size.width,height: size.height,)
      );
    }
    else{
      child=  LoadingAnimationWidget.inkDrop(color: Colors.white, size: size.width);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        child,
        Visibility(
          visible: msg.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(msg,maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,fontSize: 13),),
          )
        )
      ],
    );
  }
}