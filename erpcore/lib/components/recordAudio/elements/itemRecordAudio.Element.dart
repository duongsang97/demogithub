import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class ItemRecordAudioElement extends StatefulWidget {
  const ItemRecordAudioElement({ Key? key,required this.item,this.onRemove,required this.onChangeAction}) : super(key: key);
  final DataImageActModel item;
  final Function(DataImageActModel)? onRemove;
  final StreamController<int> onChangeAction;
  @override
  _ItemRecordAudioElementState createState() => _ItemRecordAudioElementState();
}

class _ItemRecordAudioElementState extends State<ItemRecordAudioElement> with SingleTickerProviderStateMixin{
  late AnimationController actionPlayController;
  bool isPlaying = false;
  late Timer _timer;
  late AudioPlayer audioPlayer;
  Duration audioTime = Duration(seconds: 0);
  Source? audioSrc;
  int secondsDisplay =0;
  @override
  void initState() {
    actionPlayController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    audioPlayer = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      setStatesDefault();
    });
    super.initState();
  }
  // flag = true --> play
  void actionPlayAudio(bool flag) async{
    if(flag){
      isPlaying = true;
      widget.onChangeAction.add(1);
      actionPlayController.forward();
      if(audioSrc != null){
        audioPlayer.play(audioSrc!).then((value) => startTimer(true));
      }
    }
    else{
      widget.onChangeAction.add(0);
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
        actionPlayController.reverse();
      });
    }
  }

  void setStatesDefault() async{
    try{
       if(checkIsAudioOnline()==1){
        String url = (widget.item.urlImage!).replaceAll("\\", "/");
        audioSrc = UrlSource(url);
        await audioPlayer.setSource(audioSrc!);
      } 
      else if(checkIsAudioOnline() ==0){
        audioSrc = DeviceFileSource(widget.item.assetsImage!);
        await audioPlayer.setSource(audioSrc!);
      }
      var durationInfo = await audioPlayer.getDuration();
      if(durationInfo != null){
        setState(() {
          audioTime = Duration(seconds: durationInfo.inSeconds);
          secondsDisplay = audioTime.inSeconds;
        });
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "setStatesDefault");
    }
  }

  void startTimer(bool flag) {
    if(flag){
       const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) {
          if(secondsDisplay > 0){
            if(mounted){
              setState(() {
                secondsDisplay--;
              });
            }
          }
          else{
            setStatesDefault();
            actionPlayAudio(false);
            _timer.cancel();
          }
          
        },
      );
    }
    else{
      try{
        _timer.cancel();
      }
      catch(ex){
        AppLogsUtils.instance.writeLogs(ex,func: "startTimer itemRecordAudio.Element");
      }
    }
  }

  int checkIsAudioOnline(){
    var result = -1;
    try{
      if(widget.item.urlImage != null && widget.item.urlImage!.isNotEmpty){
        result = 1;
      }
      else if(widget.item.assetsImage != null && widget.item.assetsImage!.isNotEmpty){
        result = 0;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "checkIsAudioOnline itemRecordAudio.Element");
    }
    return result;
  }
  @override
  void dispose() {
    try{
      actionPlayController.dispose();
      audioPlayer.stop();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "dispose ItemRecordAudioElement");
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon((checkIsAudioOnline()==1)?Icons.cloud:Icons.add,size: 20,color: (checkIsAudioOnline()==1)?Colors.green:Colors.red,),
              Text(formatTime(secondsDisplay),style: TextStyle(color: isPlaying?Colors.red:Colors.black),),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      if(isPlaying){
                       actionPlayAudio(false);
                       startTimer(false);
                      }
                      else{
                        actionPlayAudio(true);
                        //startTimer(true);
                      }
                    },
                    child: AnimatedIcon(
                      progress: actionPlayController,
                      icon: AnimatedIcons.play_pause,
                    )
                  ),
                  SizedBox(width: 3,),
                  Visibility(
                    visible: (checkIsAudioOnline()==0),
                    child: GestureDetector(
                    onTap: () async{
                      try{
                        if(isPlaying){
                          //startTimer(false);
                          actionPlayAudio(false);
                        }
                      }
                      catch(ex){
                        AppLogsUtils.instance.writeLogs(ex,func: "build itemRecordAudio.Element");
                      }
                      var result = await Alert.showDialogConfirm("Thông báo", "Bạn chắc chắn muốn xóa tệp này?");
                        if(result){
                          if(widget.onRemove != null){
                            widget.onRemove!(widget.item);
                          }
                        }
                      },
                      child: Icon(Icons.delete,size: 20,color: Colors.red,),
                    )
                  )
                ],
              )
            ],
          ),
          Divider(color: Colors.grey[500],)
        ],
      )
    );
  }
}