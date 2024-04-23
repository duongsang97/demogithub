import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/attendant/dateoffinfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/providers/erp/attendant.Provider.dart';
import 'package:erp/src/screens/attendants/attendantHome/attendantHome.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendantOffController extends GetxController{
  RxList<PrCodeName> listtimeslotstart = RxList.empty(growable: true); 
  RxList<PrCodeName> listtypedayoff= RxList.empty(growable: true);
  RxList<PrCodeName> listtimeslotend = RxList.empty(growable: true); 
  Rx<PrCodeName>timeslotstart = Rx<PrCodeName>(PrCodeName());
  Rx<PrCodeName>timeslotend=  Rx<PrCodeName>(PrCodeName());
  Rx<PrCodeName>typedayoff= Rx<PrCodeName>(PrCodeName());
  RxBool isLoading = false.obs; 
  late PrDate date; // ???
  late AttendantProvider attendantEmployee;
  late BuildContext context;
  RxString text="".obs;
  late DateOffInfo data; // 
  // khởi tạo TextEditing 
  TextEditingController txtTypeDayOffController = TextEditingController();
  TextEditingController txtInsFromDayController = TextEditingController();
  TextEditingController txtInsToDayController = TextEditingController();
  TextEditingController txtDayOffFromController= TextEditingController() ;
  TextEditingController txtDayOffToController = TextEditingController();
  TextEditingController txtTimeSlotFromController = TextEditingController();
  TextEditingController txtTimeSlotToController= TextEditingController();
  TextEditingController txtNoteController = TextEditingController();
  late AttendantHomeControler attendantHomeControler;
  @override
  void onInit() {
    attendantEmployee = AttendantProvider();
    data = DateOffInfo();
    super.onInit();
  }

  @override
  void onReady() {
  //  fetchDataTimeslotStart();
  //  fetchDataTypeDayOff();
   fetchDataTimeSlotEnd();
    super.onReady();
  }
    @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchDataTimeslotStart({String? keyWord}) async{
    timeslotstart.value = PrCodeName(); 
    var result = await attendantEmployee.getListTimeSlot(keyword: keyWord??"",pageSize:1000);
    LoadingComponent.dismiss();
    if(result.statusCode == 0){
      listtimeslotstart.value = result.data;
    }
    else{
      Alert.dialogShow("Thông báo",result.msg??"");
    }
  }
   Future<void> fetchDataTypeDayOff({String? keyWord}) async{
    typedayoff.value = PrCodeName(); 
    var result = await attendantEmployee.getListTypeDayOff(keyword: keyWord??"",pageSize: 1000);
    LoadingComponent.dismiss();
    if(result.statusCode == 0){
      listtypedayoff.value = result.data;
    }
    else{
      Alert.dialogShow("Thông báo",result.msg??"");
    }
  }
 
  Future<void> fetchDataTimeSlotEnd({String? keyWord}) async{
    timeslotend.value = PrCodeName(); 
    var result = await attendantEmployee.getListTimeSlot(keyword: keyWord??"",pageSize:1000);
    LoadingComponent.dismiss();
    if(result.statusCode == 0 ){
     listtimeslotstart.value = result.data;
      var data = listtimeslotstart;
     for (var item in data) 
      {
        if(checkTimeSlotEnd(item.code??"")==false)
        {
          listtimeslotend.add(item);
        } 
      };
    }
    else{
      Alert.dialogShow("Thông báo",result.msg??"");
    }
  }

  String validateInputData(){
    String msg ="";
    try{
      if(txtTypeDayOffController.text.isEmpty){
        msg += "+ Loại ngày nghỉ không được bỏ trống";
      }
      if(txtDayOffFromController.text.isEmpty){
        msg +='\n+ Ngày bắt đầu không được bỏ trống';
      }
      if(txtDayOffToController.text.isEmpty && checkTimeSlotEnd(txtDayOffFromController.text)){
        msg +='\n+ ngày kết thúc không được bỏ trống';
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "validateInputData attendantOff.Controller");
    }
    return msg;
  }
  Future<void> saveRequest() async{
    String msgValidate = validateInputData();
    if(msgValidate.isNotEmpty){
      Alert.dialogShow("Thông báo", msgValidate);
    }
    else{
      isLoading.value = true;
      LoadingComponent.show(msg: 'Đang gửi');
      var result = await attendantEmployee.saveRequestOff(setInputData());
      LoadingComponent.dismiss();
      isLoading.value= false;
      Alert.dialogShow( 'Thông báo', result.msg??"");
      if(result.statusCode == 0){
        // xử lý
      } 
    }
  }

  // set data được truyền vào từ giao diện
  DateOffInfo setInputData() {
    try {
      data.startoff =PrDate.setDate(DateTime.parse(txtDayOffFromController.text),formatDate: "dd-MM-yyyy");
      if(txtDayOffToController.text !='' ){
        data.endoff = PrDate.setDate(DateTime.parse(txtDayOffToController.text),formatDate: "dd-MM-yyyy");
      }
      // data.employee = PrCodeName(code: "E629233282", name: "DƯƠNG TẤN SANG", codeDisplay:"" ); // data test
      data.kinddayoff = typedayoff.value;
      timeslotend.value ??= PrCodeName(code: "", name:"");
      data.timeslotstart =timeslotstart.value;
      data.timeslotend = timeslotend.value;
      data.note = txtNoteController.text;
      } catch (ex) {
        AppLogsUtils.instance.writeLogs(ex,func: "setInputData attendantOff.Controller");
      }
    return data;
  }

 // check thời gian bắt đầu nghỉ phép
 bool checkTimeSlotStart(String codeTypeOff){
   var _result = false;
    var temp= codeTypeOff;
    //1P2S,... : CodeTypeDay của loại ngày nghỉ phép
   if(temp == '1P2S' || temp == '1P3S' || temp =='1P3T'|| temp == '2P3S'){
     _result= true;
   }
   return _result;
 }
  // check thời gian kết thúc nghỉ phép
  bool checkTimeSlotEnd(String codeTypeOff){
    var _result = false;
    var temp= codeTypeOff;
    //1P2C,... : CodeTypeDay của loại ngày nghỉ phép
    if(temp == "1P2C" || temp == '1P3C' || temp =='2P3C'){
      _result= true;
    }
    return _result;
  }
}