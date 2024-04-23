import 'package:erpcore/components/calendar/datas/calenType.data.dart';
import 'package:erpcore/components/calendar/models/ItemEventDateCalendar.Model.dart';
import 'package:erpcore/components/calendar/models/itemDateCalendar.Model.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class ItemDateCalendarElement extends StatefulWidget {
  const ItemDateCalendarElement({ Key? key,this.dateSelected,this.item,this.onSelectDate,
    this.type = CALENTYPE.DEFAULT,this.dateFromSelected,this.dateToSelected
  }) : super(key: key);
  final String? dateSelected;
  final DateTime? dateFromSelected;
  final DateTime? dateToSelected;
  final ItemDateCalendarModel? item;
  final Function(ItemDateCalendarModel)? onSelectDate;
  final CALENTYPE type;
  @override
  State<ItemDateCalendarElement> createState() => _ItemDateCalendarElementState();
}

class _ItemDateCalendarElementState extends State<ItemDateCalendarElement> {
  List<ItemEventDateCalendarModel> listColorEvent = List<ItemEventDateCalendarModel>.empty(growable: true);
  DateTime withCompare = DateTime(1900,01,01);
  void handleEventColor(){
    listColorEvent.clear();
    if(widget.item != null && widget.item?.events != null){
      for(var item in (widget.item?.events)??[]){
        var checker = listColorEvent.firstWhere((element) => element.groupCode == item.groupCode,orElse: ()=>ItemEventDateCalendarModel());
        if((checker.sysCode ==null || (checker.sysCode != null && checker.sysCode!.isEmpty))){
          listColorEvent.add(item);
        }
      }
    }
  }

  // (1 , chọn 1 cho loại default) , (2 chọn 1 cho loại != default) , 3 chọn 2 != default
  int get selectTypeDay{
    int result =0;
    try{
      if(widget.type == CALENTYPE.DEFAULT){
        if(widget.dateSelected == widget.item?.sysCode){
          result = 0;
        }
      }
      else{
        if(widget.dateToSelected != null && DateTimeUtils.compareTo(withCompare, widget.dateToSelected ) != 0 && (DateTimeUtils.compareTo(widget.item!.date!, widget.dateToSelected ) == 0 || DateTimeUtils.compareTo(widget.item!.date!, widget.dateFromSelected ) == 0)){
          result = 3;
        }
        else if(widget.dateFromSelected != null && (widget.item?.sysCode != null && widget.item!.sysCode!.isNotEmpty && widget.dateFromSelected == DateTime.parse(widget.item?.sysCode??"1900-01-01"))){
          result = 2;
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "selectTypeDay");
    }
    return result;
  }

  BoxDecoration get dayStyle{
    BoxDecoration result = const BoxDecoration( color: Colors.transparent);
    try{
      if(widget.type != CALENTYPE.DEFAULT){
        if(selectTypeDay == 2){
          result = const BoxDecoration(
            color: AppColor.brightBlue,
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          );
        }
        else if(selectTypeDay == 3){
          result = BoxDecoration(
            color: AppColor.bluePen,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(
              width:3,color: AppColor.brightBlue.withOpacity(0.3),
              strokeAlign:BorderSide.strokeAlignOutside
            )
          );
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "dayStyle");
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    handleEventColor();
    return GestureDetector(
      onLongPress: (){
     
      },
      onTap: () {       
        if(widget.onSelectDate != null){
          widget.onSelectDate!(widget.item!);
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AnimatedContainer(
            width: double.maxFinite,
            height: 35,
            duration:const Duration(milliseconds: 300),
            curve: Curves.slowMiddle,
            alignment: Alignment.center,
            decoration: dayStyle,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${((widget.item!.date!.year)!= 1900)?widget.item!.date!.day:''}',
                  style: TextStyle( color: (widget.item?.date?.weekday == 7)? Colors.redAccent:(selectTypeDay!=0)?AppColor.whiteColor:Colors.black,fontSize: 14,fontWeight: (widget.item!.date!.weekday == 7 || selectTypeDay != 0)?FontWeight.bold:FontWeight.normal),
                ),
                if((widget.dateSelected == widget.item?.sysCode))
                  const SizedBox(
                    width: 30,
                    child: Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Divider(thickness: 1.5,height: 1,color: AppColor.brightRed,),
                    ),
                  )
              ],
            ),
          ),
          Visibility(
            visible: (widget.item?.events != null && widget.item!.events!.isNotEmpty),
            child: Positioned(
              bottom: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: listColorEvent.map<Widget>((e) => _buildItemEvent(e)).toList()
              )
            )
          ),
          Visibility(
            visible: (widget.dateFromSelected != null && DateTimeUtils.compareTo(widget.item!.date!,widget.dateFromSelected!) >0) && (widget.dateToSelected != null && DateTimeUtils.compareTo(widget.item!.date!,widget.dateToSelected!) <0),
            child: Align(
              child: Container(
                height: 20,
                color: AppColor.brightBlue.withOpacity(0.3),
              ),
            )
          ),
        ],
      )
    );
  }
  Widget _buildItemEvent(ItemEventDateCalendarModel item){
    if((item.name != null && item.name!.isNotEmpty)){
      return Text(item.name!,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color: [2,3].contains(selectTypeDay)?AppColor.whiteColor:item.color,fontWeight: FontWeight.bold,fontSize: 10,),);
    }
    else if(item.color != null){
      return _buildNodeEvent(item.color!);
    }
    return const SizedBox();
  }

  Widget _buildNodeEvent(Color color){
    return Container(
      height: 8,
      width: 8,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: (widget.dateSelected == widget.item!.sysCode)?AppColor.azureColor:color,
        shape: BoxShape.circle
      ),
    );
  }
}