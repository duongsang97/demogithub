import 'package:erpcore/models/apps/employeedayoff.Model.dart';

import 'package:erpcore/providers/erp/attendant.Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AttendantHistoryController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isPageLoading = false.obs;
  // khai báo TextEditing
  late TextEditingController seachEmp ;
  late AttendantProvider attendantEmployee; 
 // khoi tao 
List<EmployeeModelOff> listoff = [];
  RxInt page = 1.obs;
  RxInt totalPage = 1.obs;
  int pageSize =50;
  late BuildContext context;
  @override
 void onInit() {
    seachEmp = new TextEditingController();
    attendantEmployee = new AttendantProvider();
    super.onInit();
  }
  @override
  void onReady()async{
    // await SearchEmployee(true);
    super.onReady();
  }
   @override
  void onClose() {
    super.onClose();
  }
// Future<void> SearchEmployee(bool typeRequest) async{
//  var result = await attendantEmployee.searchEmployoff();
//   if(result.statusCode == 0){
//       if(typeRequest){
//         listoff= result.data;
//         page.value = 1;
//         totalPage.value = result.totalRecord~/pageSize;
//       }
//       else{
//         listoff.addAll(result.data);
//       }
//     }
//     else{
//       Alert.dialogShow("Thông báo",result.msg);
//     }
// }

}