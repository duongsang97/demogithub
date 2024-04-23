import 'dart:async';

import 'package:cron/cron.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class ScheduleUtils{
  final String key = "APP_SCHEDULE";
  static Timer? timer;
  static const Duration interval = Duration(seconds: 30);
  static final cron = Cron();
  static List<PrCodeName> cronRegister =  List<PrCodeName>.empty(growable: true);
  // PrCodeName value : Cron data
  // PrCodeName value2 : trạng thái kích hoạt Cron : 0 ko kích hoạt, 1 đang kích hoạt , -1 huỷ
  static void registerCron(PrCodeName cron){
    int index = cronRegister.indexWhere((element) => element.code == cron.code);
    if(index < 0){
      try{
        if(cron.codeDisplay != null){
          cron.value ??= Cron();
          String cronSetup = cron.codeDisplay!.isNotEmpty?cron.codeDisplay!:"*/2 * * * *";
          cron.value.schedule(Schedule.parse(cronSetup),(){
            if(cron.value3 != null){
              print("${cron.code} running!");
              cron.value3();
            }
          });
          cron.value2 = 1;
          print("${cron.code} added!");
          cronRegister.add(cron);
        }
      }
      catch(ex){
        AppLogsUtils.instance.writeLogs(ex,func: "registerCron ScheduleUtils");
      }
    }
  }

  static void updateStatusCron(PrCodeName cron){
    int index = cronRegister.indexWhere((element) => element.code == cron.code);
    if(index >= 0){
      try{
        cronRegister[index].value2 = cron.value2;
        print("${cronRegister[index].code} status to ${cron.value2} finish");
      }
      catch(ex){
        AppLogsUtils.instance.writeLogs(ex,func: "updateStatsCron ScheduleUtils");
      }
    }
  }

  static void closeCron(PrCodeName cron) async{
    try{
      if(!PrCodeName.isEmpty(cron)){
        var result = await cron.value.close();
        print("${cron.code} remove ==>! $result");
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "closeCron ScheduleUtils");
    }
  }

  // xoá cron hết hạn
  static void closeExpCron(){
    var crons = cronRegister.where((element) => element.value2 == -1);
    for(var item in crons){
      closeCron(item);
    }
  }

  static void init(){
   cron.schedule(Schedule.parse('*/2 * * * *'), () async {
      print("system cron running everthinh two minutes, [${cronRegister.length}] is active");
      closeExpCron();
    });
  }

}