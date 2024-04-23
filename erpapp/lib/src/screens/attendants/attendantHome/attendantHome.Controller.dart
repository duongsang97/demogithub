
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/calendar/models/ItemEventDateCalendar.Model.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/attendant/offDateResult.Model.dart';
import 'package:erpcore/providers/erp/attendant.Provider.dart';
import 'package:erp/src/screens/attendants/attendantMain/attendantMain.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendantHomeControler extends GetxController{
  DateTime dateTimeNow = DateTime.now();
  Rx<DateTime> cycelFromDate = new Rx<DateTime>(DateTime(2022)); // ngày bắt đầu kỳ lương
  Rx<DateTime>  cycelToDate =new Rx<DateTime>(DateTime(2022)); // ngày kết thúc kỳ lương
  late BuildContext context;
  late AttendantMainController attendantMainController;
  late AttendantProvider attendantProvider;
  RxList<ItemEventDateCalendarModel> listEventOffDate = RxList.empty(growable: true);
  RxBool isLoading = false.obs;
  // thông tin công
  Rx<double> totalOffDate =0.0.obs;
  @override
  void onInit() {
    attendantProvider = new AttendantProvider();
    initCalendar(dateTimeNow);
    super.onInit();
  }

  @override
  void onReady() {
    attendantMainController = Get.find();
    attendantMainController.currentDate.listen((date) async{
      var fromDate = PrDate.setDate(DateTime(date.year,date.month-1,25,0,0,0));
      var toDate = PrDate.setDate(DateTime(date.year,date.month,24,23,59,59));
      initCalendar(date);
      await fetchOffDateByUser(fromDate: fromDate,toDate: toDate);
    });

    fetchOffDateByUser(fromDate: (PrDate.setDate(cycelFromDate.value)),toDate: PrDate.setDate(cycelToDate.value));
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initCalendar(DateTime dateInput){
    cycelFromDate.value = DateTime(dateInput.year,dateInput.month-1,25,0,0,0);
    cycelToDate.value = DateTime(dateInput.year,dateInput.month,24,23,59,59);
  }
  Future<void> fetchOffDateByUser({PrDate? fromDate, PrDate? toDate}) async{
    listEventOffDate.clear();
    if(fromDate == null){
      fromDate = PrDate.setDate(DateTime(cycelFromDate.value.year,cycelFromDate.value.month-1,25,0,0,0));
    }
    if(toDate == null){
      toDate = PrDate.setDate(DateTime(cycelToDate.value.year,cycelToDate.value.month,24,23,59,59));
    }
    isLoading.value = true;
    var result = await attendantProvider.searchOffDateByUser(fromDate,toDate);
    if(result.statusCode == 0){
      handleCountOffDate(result.data);
    }
    else{
      Alert.dialogShow("Thông báo", result.msg??"");
    }
    isLoading.value = false;
    print("done");
  }

  void handleCountOffDate(List<OffDateResultModel> dataOff){
    try{  
      //1P1 --> nghỉ nguyên ngày
      totalOffDate.value = 0;
      for(var item in dataOff){
        DateTime _startDate = PrDate.getDate(item.applyFromDate!);
        DateTime _endDate = PrDate.getDate(item.applyToDate!);
        if(item.applyFromDate?.lD! == item.applyToDate!.lD && _startDate.compareTo(cycelFromDate.value) >=0  && _startDate.compareTo(cycelToDate.value) <= 0){
          var temp = ItemEventDateCalendarModel(sysCode: item.sysCode,values: item,ofDate: PrDate.getDate(item.applyFromDate!));
          temp.color = HexColor.fromHex("#ffa31a");
          temp.groupCode = "offRequest";
          listEventOffDate.add(temp);
          if(item.numDayFrom != null && item.numDayFrom?.code == "1P1"){
            totalOffDate.value+=1;
          }
          else{
            totalOffDate.value+=0.5;
          }
        }
        else{
          
          while(_startDate.compareTo(_endDate) <=0){
            if(_startDate.compareTo(cycelFromDate.value) >=0  && _startDate.compareTo(cycelToDate.value) <= 0){
              var temp = ItemEventDateCalendarModel(sysCode: generateKeyCode(),values: item,ofDate: _startDate);
              temp.color = HexColor.fromHex("#ffa31a");
              temp.groupCode = "offRequest";
              listEventOffDate.add(temp);
              if(_startDate.difference(_endDate).inDays == 0 && item.numDayTo?.code != "1P1"){
                totalOffDate.value+=0.5;
              }
              else{
                totalOffDate.value+=1;
              }
            }
            _startDate= _startDate.add(Duration(days: 1));
          }
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleCountOffDate attendantHome.Controller");
    }
  }
}