import 'dart:async';
import 'dart:io';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

import 'elements/itemRecordAudio.Element.dart';

class RecordAudioComponent extends StatefulWidget {
  const RecordAudioComponent({ Key? key,required this.listData,this.callback,this.shopCode,this.isActRecordGlobal = false,this.onChangeAction}) : super(key: key);
  final List<DataImageActModel> listData;
  final VoidCallback? callback;
  final String? shopCode;
  final bool isActRecordGlobal; 
  final Function(int)? onChangeAction;
  @override
  _RecordAudioComponentState createState() => _RecordAudioComponentState();
}

class _RecordAudioComponentState extends State<RecordAudioComponent> with SingleTickerProviderStateMixin{
  bool isRecording = false;
  late Size size;
  late Timer _timer;
  int sec = 0;
  String pathAudio="";
  final oneSec = const Duration(seconds: 1);
  final StreamController<int> statusStream = StreamController<int>();

  @override
  void initState() {
    super.initState();
    statusStream.stream.listen((event) async{onUpdateRecordStatus(event);});
    statusStream.add(0);
  }

  @override
  void dispose() {
    try{
      if(_timer.isActive){
        _timer.cancel();
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "dispose recordAudio.Component");
      statusStream.add(0);
    }
    super.dispose();
  }

  void onUpdateRecordStatus(int status){
    try{
      if(widget.onChangeAction != null){
        widget.onChangeAction!(status);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onUpdateRecordStatus");
    }
  }

  void removeAudioFile(DataImageActModel item) async{
    if(item != null && item.sysCode != null){
      if(item.assetsImage != null && item.assetsImage!.isNotEmpty){
        //var _file = File(item.assetsImage);
        //await _file.deleteSync();
      }
      setState(() {
        widget.listData.removeWhere((element) => element.sysCode == item.sysCode);
      });
    }
  }

  void startTimer(bool flag) {
    if(flag){
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) {
          if(mounted){
            setState(() {
              sec++;
            });
          }
        },
      );
    }
    else{
      _timer.cancel();
    }
  }

  Future<bool> onPressAudioRecord(bool flag) async{
    bool _result = false;
    try{
      if(flag){
        bool result = await Record().hasPermission();
        if(result){
          if(!await Record().isRecording() && !await Record().isPaused())
          { // kiểm tra có đang bật ghi âm tổng hay không
            if(widget.isActRecordGlobal){
              var recordInfo = await getRecordStatus();
              if(recordInfo != null){
                recordInfo.status = false;
                updateRecordStatus(recordInfo);
              }
              var rrsult = await sendCommandRecordService("record",status: 1,shopId: "");
              
            }
            pathAudio = await getFilePath(ext: ".mp3");
            try{
              Record().start(
                path: null, // pathAudio
                encoder: AudioEncoder.aacLc
              );
              statusStream.add(1);
            }
            catch(ex){  
              AppLogsUtils.instance.writeLogs(ex,func: "onPressAudioRecord Record().start recordAudio.Component");
              statusStream.add(0);
            }
            _result= true;
          }
          else{
            var resultQuesion = await Alert.showDialogConfirm("Thông báo","Microphone đang được sử dụng, vẫn tiếp tục?");
            if(resultQuesion){
              await Record().stop();
              statusStream.add(0);
              onPressAudioRecord(true);
            }
          }
        }
        else{
          Alert.dialogShow("Thông báo","Không có quyền ghi âm");
          statusStream.add(0);
        }
      }
      else{
        if(await Record().isRecording() || await Record().isPaused()){
          statusStream.add(0);
          pathAudio = await Record().stop()??"";
          _result = true;
          if(sec >1){
            var _temp = new DataImageActModel(sysCode: generateKeyCode());
            _temp.createdAt = new PrDate();
            _temp.lenghtSec = sec;
            _temp.assetsImage =pathAudio;
            setState(() {
              widget.listData.add(_temp);
            });
            if(widget.callback != null){
              widget.callback!();
            }
          }
          else{
            Alert.dialogShow("Thông báo","Tệp ghi âm đã không được lưu lại vì quá ngắn!");
            try{
              statusStream.add(0);
              var _file = File(Uri.parse(pathAudio).path);
              _file.deleteSync();
            }
            catch(ex){
              AppLogsUtils.instance.writeLogs(ex,func: "onPressAudioRecord Tệp ghi âm đã không được lưu lại vì quá ngắn!");
              statusStream.add(0);
            }
          }

          // kiểm tra trạng thái ghi âm tổng, nếu có --> bật
          if(widget.isActRecordGlobal){
            var recordInfo = await getRecordStatus();
            if(recordInfo != null && recordInfo.status!){
              recordInfo.status = true;
              updateRecordStatus(recordInfo);
            }
             await sendCommandRecordService("record",status: 0,shopId: (widget.shopCode)??"");
            }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onPressAudioRecord recordAudio.Component");
      Alert.dialogShow("Thông báo", ex.toString());
      statusStream.add(0);
    }
    return _result;
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          _buildActionPlay(),
          SizedBox(height: 5,),
          _buildListRecordAudio()
        ],
      ),
    );
  }

  Widget _buildActionPlay(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[500]!)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Ghi âm"),
          Visibility(
            visible: isRecording,
            child: _buildPlayerRecording()
          ),
          GestureDetector(
            onTap: () async{
             var result = await onPressAudioRecord(!isRecording);
             
             if(result){
                setState(() {
                  isRecording = !isRecording;
                  if(isRecording){
                    sec = 0;
                  }
                });
              startTimer(isRecording);
             }
            },
            child: Icon(!isRecording?Icons.mic:Icons.stop,size: 20,color: !isRecording?Colors.green:Colors.red,)
          )
        ],
      ),
    );
  }
  Widget _buildListRecordAudio(){
    return (widget.listData != null)?ListView.builder(
      shrinkWrap: true,
      itemCount: widget.listData.length,
      itemBuilder: (BuildContext context, int index){
        return ItemRecordAudioElement(item: widget.listData[index],onRemove: (V)=>removeAudioFile(V),onChangeAction: statusStream,);
      }
    ):SizedBox();

  }

  Widget _buildPlayerRecording(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // AudioWave(
          //   height: 30,
          //   width: 80,
          //   spacing: 2.5,
          //   bars: [
          //     AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          //     AudioWaveBar(height: 30, color: Colors.blue),
          //     AudioWaveBar(height: 70, color: Colors.black),
          //     AudioWaveBar(height: 40),
          //     AudioWaveBar(height: 20, color: Colors.orange),
          //     AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          //     AudioWaveBar(height: 30, color: Colors.blue),
          //     AudioWaveBar(height: 70, color: Colors.black),
          //     AudioWaveBar(height: 40),
          //     AudioWaveBar(height: 20, color: Colors.orange),
          //     AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          //     AudioWaveBar(height: 30, color: Colors.blue),
          //     AudioWaveBar(height: 70, color: Colors.black),
          //     AudioWaveBar(height: 40),
          //     AudioWaveBar(height: 20, color: Colors.orange),
          //     AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          //     AudioWaveBar(height: 30, color: Colors.blue),
          //     AudioWaveBar(height: 70, color: Colors.black),
          //     AudioWaveBar(height: 40),
          //     AudioWaveBar(height: 20, color: Colors.orange),
          //   ],
          // ),
          // SizedBox(height: 5,),
          Text(formatTime(sec),style: TextStyle(color: Colors.red),)
        ],
      ),
    );
  }

  // Widget _buildBoxRecord(){
  //   return Container(
  //     height: size.height*.4,
  //     width: size.width*.9,
  //     child: Stack(
  //       alignment: AlignmentDirectional.bottomEnd,
  //       children: [
  //         Container(
  //           height: (size.height*.4)-10,
  //           width: size.width*.9,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20.0),
  //               topRight:  Radius.circular(20.0),
  //               bottomLeft: Radius.circular(5.0),
  //               bottomRight:  Radius.circular(5.0)
  //             )
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
                
  //             ],
  //           ),
  //         ),
  //         Positioned(
  //           top: 0,
  //           right: 20,
  //           child: GestureDetector(
  //             onTap: (){
  //               Navigator.pop(context);
  //             },
  //             child: Image.asset("assets/images/icons/cancel.png",height: 30,width: 30,)
  //           )
  //         )
  //       ],
  //     )
  //   );
  // }

}