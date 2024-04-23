import 'dart:async';

import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

import 'models/alertState.model.dart';

class AlertControlComponent extends StatefulWidget {
  const AlertControlComponent({super.key});
  @override
  State<AlertControlComponent> createState() => _AlertControlComponentState();
}

class _AlertControlComponentState extends State<AlertControlComponent> with TickerProviderStateMixin{
  final alertStates = AlertControl.instance;
  late Size size;
  late EdgeInsets padding;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<AlertStatesModel>? alertList;
  late AnimationController animationController;
  
  Color backgroundColorByType(AlertType type){
    if(type ==  AlertType.SUCCESS){
      return Colors.green[800]!;
    }
    else if(type ==  AlertType.ERROR){
      return Colors.red[900]!;
    }
    else if(type ==  AlertType.WARNING){
      return Colors.orange[800]!;
    }
    else{
      return Colors.blueAccent;
    }
  }
  Widget iconByType(AlertType type){
    Color color = backgroundColorByType(type);
    if(type ==  AlertType.SUCCESS){
      return Icon(Icons.check_outlined,size: 20,color: color,);
    }
    else if(type ==  AlertType.ERROR){
      return Icon(Icons.error_outlined,size: 20,color: color,);
    }
    else if(type ==  AlertType.WARNING){
      return Icon(Icons.report_problem_outlined,size: 20,color: color);
    }
    else{
      return Icon(Icons.info_outlined,size: 20,color: color,);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController= AnimationController(
      vsync: this,
      duration:  const Duration(milliseconds: 400),
    );
    animationController.forward();
    AlertControl._streamAlertControlController.stream.listen((event) {
      setState(() {
        alertList = event;
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    padding = MediaQuery.paddingOf(context);
    double listSize = size.width * 0.9;
    return Visibility(
      visible: alertList != null && alertList!.isNotEmpty,
      child: Positioned(
        top: padding.top,
        right: 0,
        child: SizedBox(
          width: listSize,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(right: 5),
            itemCount: (alertList??[]).length,
            itemBuilder:(context, index){
              final animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
              if(alertList != null && alertList!.isNotEmpty){
                var item = alertList![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: buildItem(item,animation,listSize),
                );
              }
              return const SizedBox();
            },
          ),
        )
      )
    );
  }
  Widget buildItem(AlertStatesModel item, Animation<double> animation,double size) { 
    return SizeTransition( 
      sizeFactor: animation, 
      axis: Axis.horizontal,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
        constraints: BoxConstraints(
          maxWidth: size,
          minHeight: 60
        ),
        decoration: BoxDecoration(
          color: backgroundColorByType(item.type),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))
        ),
        duration: const Duration(milliseconds: 400),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.all(7.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child: iconByType(item.type)
            ),
            const SizedBox(width: 10,),
            Expanded(child: Text(item.title,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(color: Colors.white,fontSize: 12),
            )),
          ],
        ),
      )
    ); 
  } 
}

class AlertControl {
  static final AlertControl _singleton = AlertControl._();
  static AlertControl get instance => _singleton;
  static Stream<List<AlertStatesModel>> get alertStream => _streamAlertControlController.stream;
  AlertControl._();
  static final StreamController<List<AlertStatesModel>> _streamAlertControlController = StreamController<List<AlertStatesModel>>.broadcast();
  static Timer? _timer;
  static final List<AlertStatesModel> _listAlert = List<AlertStatesModel>.empty(growable: true);
  static final List<AlertStatesModel> _listAlertDisplay = List<AlertStatesModel>.empty(growable: true);
  static Widget init(){
    return const AlertControlComponent();
  }

  static int _sortByPriority(AlertStatesModel a, AlertStatesModel b){
    int result = -1;
    if(a.priority ==  b.priority){
      return 0;
    }
    else if(a.priority == AlertPriority.HIGH){
      return 1;
    }
    else if(b.priority == AlertPriority.HIGH){
      return -1;
    }
    else if(a.priority == AlertPriority.MEDIUM){
      return 1;
    }
    else if(b.priority == AlertPriority.MEDIUM){
      return -1;
    }
    else if(a.priority == AlertPriority.LOW){
      return 1;
    }
    else if(b.priority == AlertPriority.LOW){
      return -1;
    }
    return result;
  }

  static void _setupTimer(){
    if(_timer == null){
      const oneSec = Duration(milliseconds: 500);
      _timer = Timer.periodic(oneSec,(Timer timer) {
          if (_listAlertDisplay.isEmpty && _listAlert.isEmpty) {
            timer.cancel();
            _timer =null;
          }
          else{
            _removeDisplayOver();
            _pushAlertDisplay();
          }
        },
      );
    }
  }

  static void _pushAlertDisplay(){
    if((_listAlertDisplay.isEmpty || _listAlertDisplay.length <3) && _listAlert.isNotEmpty){
      var first = _listAlert.first;
      var temp = AlertStatesModel.toCopy(first);
      var duration = temp.duration??const Duration(seconds: 3);
      temp.exp = DateTime.now().add(duration);
      _listAlertDisplay.insert(0, temp);
      _streamAlertControlController.sink.add(_listAlertDisplay);
      _listAlert.remove(first);
    }
  }

  static void _removeDisplayOver({AlertStatesModel? item}){
    if(item != null){
      var index = _listAlertDisplay.indexWhere((element) => element.code == item.code);
      if(index>-1){
        if(_listAlertDisplay[index].callback != null){
          _listAlertDisplay[index].callback!();
        }
        _listAlertDisplay.removeAt(index);
      }
    }
    else{
      var listOutExp = _listAlertDisplay.where((element){
        var now = DateTime.now();
        if(element.exp != null && (element.exp?.compareTo(now)??0) <1){
          return true;
        }
        return false;
      }).toList();
      if(listOutExp.isNotEmpty){
        for(var alert in listOutExp){
          if(alert.callback != null){
            alert.callback!();
          }
          _listAlertDisplay.remove(alert);
        }
      }
    }
    _streamAlertControlController.sink.add(_listAlertDisplay);
  }

  static void _addItem(AlertStatesModel item) {
    int index = _listAlert.indexWhere((element) => element.title ==  item.title);
    int indexDisplay = _listAlertDisplay.indexWhere((element) => element.title ==  item.title);

    if(index <0 && indexDisplay <0){
      _listAlert.add(item);
      _listAlert.sort((a,b)=>_sortByPriority(a,b));
      _setupTimer();
    }
  }
  

  static void push(String title,{AlertType? type,String? description = "",Duration? duration,VoidCallback? callback}){
    type ??= AlertType.DEFAULT;
    var state = AlertStatesModel(type: type,title: title,description: description??"",code: generateKeyCode(),duration: duration,callback: callback);
    _addItem(state);
  }

}