import 'package:erpcore/components/calendar/datas/calenType.data.dart';
import 'package:erpcore/components/calendar/elements/itemDateCalendar.Element.dart';
import 'package:erpcore/components/calendar/models/ItemEventDateCalendar.Model.dart';
import 'package:erpcore/components/calendar/models/itemDateCalendar.Model.dart';
import 'package:erpcore/components/shimmerPage/shimmerCalendar.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/dateTime.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarCustomComponent extends StatefulWidget {
  const CalendarCustomComponent({ Key? key,required this.cycelCurrent,this.cycelNow,this.cycelOnChange,this.onSelectDate,this.events,this.isLoading= false,this.dateSelected,
    this.onSelectMultiple,this.type = CALENTYPE.DEFAULT,this.dateToSelected,this.dateFromSelected,this.onChangeType,this.showHeader = false,this.isLoadingAction = false
  }) : super(key: key);
  final PrCodeName cycelCurrent;
  final PrCodeName? cycelNow;
  final Function(DateTime,List<ItemEventDateCalendarModel>?,bool goToday)? onSelectDate;
  final List<ItemEventDateCalendarModel>? events;
  final bool isLoading;
  final DateTime? dateSelected;
  final Function(bool,int)? cycelOnChange;
  final Function(DateTime,int)? onSelectMultiple;
  final Function(int)? onChangeType;
  final DateTime? dateToSelected;
  final DateTime? dateFromSelected;
  final CALENTYPE type;
  final bool showHeader;
  final bool isLoadingAction;
  @override
  State<CalendarCustomComponent> createState() => _CalendarCustomComponentState();
}

class _CalendarCustomComponentState extends State<CalendarCustomComponent> {
  final List<String> daysOfWeek = ["T2","T3","T4","T5","T6","T7","CN"];
  List<ItemDateCalendarModel> dayofMonth= List<ItemDateCalendarModel>.empty(growable: true);
  DateTime now = DateTime.now();
  DateTime withCompare = DateTime(1900,01,01);
  int calendarMode = 0;
  @override
  void initState() {
    dayofMonth= getDaysInBetween(widget.cycelCurrent.value,widget.cycelCurrent.value2);
    if(widget.type == CALENTYPE.DEFAULT){
      calendarMode = 0;
    }
    else{
      calendarMode= 3;
    }
    super.initState();
  }

  int getIndexOfFirstDayInMonth(DateTime currentDate) {
    var selectedMonthFirstDay =DateTime(currentDate.year, currentDate.month, currentDate.day);
    var day = DateFormat('EEE').format(selectedMonthFirstDay).toUpperCase();
    return daysOfWeek.indexOf(day) - 1;
  }

  bool get isNow{
    bool result = false;
    if(widget.dateSelected != null && (widget.dateSelected!.year == now.year) && (widget.dateSelected!.month == now.month) && (widget.dateSelected!.day == now.day)
      && (PrCodeName.isEmpty(widget.cycelNow)|| (!PrCodeName.isEmpty(widget.cycelNow) && widget.cycelCurrent.code == widget.cycelNow?.code))
    ){
      result = true;
    }
    return result;
  }

  //tìm số lượng ngày trong khoảng từ startday tới endday 
  List<ItemDateCalendarModel> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<ItemDateCalendarModel> days = List<ItemDateCalendarModel>.empty(growable: true);
    // view trong tuần
    if(calendarMode == 1){
      var dateTemp = widget.dateSelected??now;
      var start = DateTimeUtils().findFirstDateOfTheWeek(dateTemp);
      var end = DateTimeUtils().findLastDateOfTheWeek(dateTemp);
      if(startDate.difference(start).inDays >0){
        start = startDate;
      }
      if(endDate.difference(end).inDays <0){
        end = endDate;
      }
      days = handleCalendar(start,end);
    }
    else if(calendarMode == 2){

    }
    // Show lịch full tháng
    else{
      days = handleCalendar(startDate,endDate);
    }
    // xét ngày đầu tiên trong tuần là thứ mấy  ?
    for(int i=2; i<=startDate.weekday;i++)
    {
      days.insert(0,ItemDateCalendarModel(sysCode: "",date: DateTime(1900,1,1),events: []));
    }
    return days;
  }

  List<ItemDateCalendarModel> handleCalendar(DateTime startDate, DateTime endDate){
    List<ItemDateCalendarModel> result = List<ItemDateCalendarModel>.empty(growable: true);
    try{
      Duration listday= endDate.difference(startDate);
      //chạy vòng lặp lấy ngày từ ngày bắt đầu tới ngày kết thúc
      for (int i = 0; i <= listday.inDays; i++) {
        var temp = ItemDateCalendarModel();
        temp.date = DateTime(startDate.year, startDate.month,startDate.day + i);
        var dateInt = convertDateToInt(date: temp.date!);
        temp.sysCode = dateInt.toString();
        var event = widget.events!.where((element) => convertDateToInt(date: element.ofDate!).compareTo(dateInt)==0).toList();
        temp.events = event;
        result.add(temp);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleCalendar");
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  IconData get iconCalendar{
    IconData result = Icons.calendar_month_outlined;
    if(calendarMode == 1){
      result = Icons.date_range_outlined;
    }
    else if(calendarMode == 2){
      result = Icons.event_outlined;
    }
    else if(calendarMode == 3){
      result = Icons.visibility_outlined;
    }
    else if(calendarMode == 4){
      result = Icons.done_all_outlined;
    }
     else if(calendarMode == 5){
      result = Icons.event_available_outlined;
    }
    return result;
  }

  void modeOnChange(){
    if(!widget.isLoadingAction){
      if(widget.type == CALENTYPE.DEFAULT){
        if(calendarMode == 2){
          calendarMode = 0;
        }
        else{
          calendarMode++;
        }
      }
      else{
        if(calendarMode == 5){
          calendarMode = 3;
        }
        else{
          calendarMode++;
        }
      }
      if(widget.onChangeType != null){
        widget.onChangeType!(calendarMode);
      }
      if(mounted){
        setState(() {});
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    dayofMonth= getDaysInBetween(widget.cycelCurrent.value,widget.cycelCurrent.value2);
    return !widget.isLoading?Column(
      children: [
        Visibility(
          visible: widget.showHeader,
          child: _buildHeaderCalendar(dayofMonth)
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 0.0,
          ),
          itemCount: daysOfWeek.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              child: Text( daysOfWeek[index],style:TextStyle(fontSize: 14,color:index % 7 == 6? Colors.redAccent: Colors.grey,),),
            );
          }
        ),
         //load ngày trong tháng 
        GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
          ),
          itemCount: dayofMonth.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemDateCalendarElement(
              item: dayofMonth[index],
              dateFromSelected: widget.dateFromSelected,
              dateToSelected: widget.dateToSelected,
              type: calendarMode==3?CALENTYPE.VIEWONLY:calendarMode==4?CALENTYPE.CHOICE:CALENTYPE.DEFAULT,
              dateSelected: convertDateToInt(date: widget.dateSelected).toString(),
              onSelectDate: (v){
                DateTime temp = DateTime.parse(convertIntToDate(v.sysCode!));
                if(v.sysCode != null && widget.onSelectDate != null){
                  if( widget.type == CALENTYPE.DEFAULT){
                    widget.onSelectDate!(temp,v.events,false);
                  }
                  else if(widget.onSelectMultiple != null){
                    widget.onSelectMultiple!(temp,calendarMode);
                  }
                }
              },
            );
          }
        ),
      ],
    ):const ShimmerCalenderComponent();
  }

  Widget _buildHeaderCalendar(List<ItemDateCalendarModel> days){
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (){
              if(widget.cycelOnChange != null){
                widget.cycelOnChange!(false,calendarMode);
              }
            }, 
            icon: const Icon(Icons.arrow_back_ios_outlined,size: 18,)
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.cycelCurrent.name??"",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                Visibility(
                  visible: !isNow,
                  child: GestureDetector(
                    onTap: (){
                      if(widget.onSelectDate != null){
                        List<ItemEventDateCalendarModel> event = [];
                        var index = days.indexWhere((element) => element.dateDisplay?.compareTo(convertDateToInt(date: now))==0);
                        if(index >=0){
                          event = days[index].events??[];
                        }
                        widget.onSelectDate!(now,event,true);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.only(left: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColor.bluePen,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const Text("Today",style: TextStyle(color: AppColor.whiteColor,fontSize: 10,fontWeight: FontWeight.bold),),
                    ),
                  )
                )
              ],
            )
          ),
          Row(
            children: [
              IconButton(
                onPressed: (){
                  if(widget.cycelOnChange != null){
                    widget.cycelOnChange!(true,calendarMode);
                  }
                }, 
                icon: const Icon(Icons.arrow_forward_ios_outlined,size: 18,)
              ),
              const SizedBox(width: 5,),
              Visibility(
                visible: widget.type == CALENTYPE.DEFAULT,
                child: IconButton(
                  onPressed: modeOnChange,
                  icon: Icon(iconCalendar,size: 20,)
                ),
              ),
              Visibility(
                visible: widget.type != CALENTYPE.DEFAULT,
                child: IconButton(
                  onPressed: modeOnChange,
                  icon: Icon(iconCalendar,size: 20,)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}