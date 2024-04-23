import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/providers/erp/notify.Provider.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeNotificationController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isPageLoading = true.obs;
  Rx<PaginationInfoModel> pageConfig = PaginationInfoModel().obs;
  RxList<PrCodeName> tags = RxList<PrCodeName>.empty(growable: true);
  Rx<PrCodeName> tagSelected = Rx<PrCodeName>(PrCodeName());
  RxList<NotificationInfoModel> notifys = RxList.empty(growable: true);
  late NotifyProvider notifyProvider;
  late BuildContext context;
  // RxString currentScrollDate = "".obs;
  // RxDouble offset = 0.0.obs;
  // RxDouble opacityValue = 0.0.obs;
  RxList<String> listCreateDate = RxList.empty(growable: true);
  // RxList<int> listLength = RxList.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    pageConfig.value = PaginationInfoModel(page: pageSizeConfig.page,pageSize: pageSizeConfig.pageSize,totalPage: pageSizeConfig.totalPage);
    notifyProvider = NotifyProvider();
  }

  @override
  void onReady() async{
    super.onReady();
    isPageLoading.value = true;
    fetchTagsList();
    await fetchNotifyData(false,true);
    isPageLoading.value = false;
  }

  void initTags(){
    tags.insert(0, PrCodeName(code: "0",name: "Chưa xem"));
    tags.insert(0, PrCodeName(code: "-1",name: "Tất cả"));
    if(tags.isNotEmpty){
      tagSelected.value = tags.first;
    }
  }

  void onTagSelect(PrCodeName tag) async{
    if(tag.code != null && tag.code!.isNotEmpty){
      tagSelected.value = tag;
      await fetchNotifyData(true,true);
    }
  }

  Future<void> fetchTagsList() async{
    isPageLoading.value = true;
    var result = await notifyProvider.getTagsListNotify();
    isPageLoading.value = false;
    if(result.statusCode == 0){
      tags.value = result.data;
      initTags();
    }
    else{
      AlertControl.push(result.msg??"",type: AlertType.ERROR);
    }
  }

  List<NotificationInfoModel> getListNotificationByDate (String date) {
    List<NotificationInfoModel> list = List.empty(growable: true);
    try {
      if (date.isNotEmpty) {
        for (var item in notifys) {
          if (item.createDay != "" && item.createDay == date) {
            list.add(item);
          }
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getListNotificationByDate");
    }
    return list;
  }

  Future<void> fetchNotifyData(bool isLoad,bool typeRequest,) async{
    if(typeRequest){
      pageConfig.value.page = 1;
    }
    if(isLoad){
      LoadingComponent.show();
    }
    isLoading.value = true;
    var result = await notifyProvider.getListNotify(
      tagCodeList: tagSelected.value.code=='-1'?"":((tagSelected.value.code)??""),
      pageSize: pageConfig.value.pageSize,pageNumber: pageConfig.value.page 
    );
    isLoading.value = false;
    if(isLoad){
      LoadingComponent.dismiss();
    }
    if(result.statusCode == 0){
      pageConfig.refresh();
      if(typeRequest){
        notifys.value = result.data;
        pageConfig.value.page = 1;
        pageConfig.value.totalPage = (result.totalRecord! / pageConfig.value.pageSize!).ceil();
      }
      else {
        for(NotificationInfoModel item in result.data) {
          var _index = notifys.indexWhere((element) => element.sysCode == item.sysCode);
          if(_index < 0) {
            notifys.add(item);
          }
          else{
            notifys[_index] = item;
          }
        }
      }
      for (var item in notifys) {
        if (item.createDay != "" && !listCreateDate.contains(item.createDay)) {
          listCreateDate.add(item.createDay ?? "");
        }
      }
      if (notifys.isNotEmpty) {
        List<int> listRemove = List.empty(growable: true);
        for (var date in listCreateDate) {
          int index = notifys.indexWhere((element) => element.createDay == date);
          if (index < 0) {
            int indexRemove = listCreateDate.indexOf(date);
            listRemove.add(indexRemove);
          }
        }
        for (var index in listRemove) {
          listCreateDate.removeAt(index);
        }
      } else {
        listCreateDate.clear();
        listCreateDate.refresh();
      }
      // currentScrollDate.value = listCreateDate.first;
      listCreateDate.refresh();
    }
    else{
      AlertControl.push(result.msg??"",type: AlertType.ERROR);
    }
  }
  //kiểm tra loại phiếu gì
  int getRequestType(NotificationInfoModel item){
    int type =-1;
    try{
      if(item.nextFunction != null && item.nextFunction!.code != null && item.nextFunction!.code!.isNotEmpty){
        type = int.parse(item.nextFunction!.code??"-1");
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getRequestType homeNotification.Controller");
    }
    return type;
  }

  Future<void> onPressNotify(NotificationInfoModel item) async{
    if(item.content != null && item.content!.isNotEmpty){
      await Get.toNamed(AppRouter.detailNotification,arguments: {
        "NOTIFY": item,
        "TAG": tagSelected.value
      });
    }
    else if(!PrCodeName.isEmpty(item.nextFunction) && item.refCode != null){
      // invWaitingForApprovalController.context = context;
      // invWaitingForApprovalController.isLoading.value = false;
      // await invWaitingForApprovalController.onPressRequestItem(item.refCode??"",getRequestType(item));
    }
    await fetchNotifyData(true,false);
  }

  void onScroll(double value) {
    try {
      // offset.value = value;
      // if (value >= 0 && value <= 40) {
      //   opacityValue.value = value * 0.025;
      // }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onScroll");
    }
  }
}
