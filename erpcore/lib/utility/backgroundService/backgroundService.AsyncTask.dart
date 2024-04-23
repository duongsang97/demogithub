// import 'package:erpcore/components/alerts/alert.dart';
// import 'package:erpcore/configs/appStyle.Config.dart';
// import 'package:workmanager/workmanager.dart';

class BackgroundServiceAsyncTask{
  static const String backgroundTaskName ="task-sync-data-erp";
  
  // @pragma('vm:entry-point')
  // static void callbackDispatcher() {
  //   Workmanager().executeTask((task, inputData) async {
  //     print("Native called background task: ");
  //     AlertControl.push("đang chạy dữ liệu ngầm", AppColor.brightBlue);
  //     return Future.value(true);
  //   });
  // }
  // static void cancelByUniqueName(){
  //   Workmanager().cancelByUniqueName(backgroundTaskName);
  // }

  // static void initialize({bool isInDebugMode = false}){
  //   cancelByUniqueName();
  //   Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode: isInDebugMode // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //   );
  // }

  // static void registerOneOffTask(){
  //   Workmanager().registerPeriodicTask(backgroundTaskName,"123123",
  //     inputData: {},
  //     frequency: const Duration(minutes: 2),
  //     constraints: Constraints(networkType: NetworkType.connected)
  //   );
  // }
  
}