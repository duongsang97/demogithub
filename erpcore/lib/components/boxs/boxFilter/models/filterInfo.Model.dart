import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/cupertino.dart';

class FilterInfoModel {
  PrCodeName? tagSelected;
  PrCodeName? shopSelected;
  List<PrCodeName>? shopsSelected;
  List<PrCodeName>? listShops;
  PrCodeName? productSelected;
  List<PrCodeName>? listProducts;
  PrCodeName? workTimeSelected;
  List<PrCodeName>? workTimeList;
  ItemSelectDataActModel? statusSelected;
  List<ItemSelectDataActModel>? statusRadioList;
  ItemSelectDataActModel? statusProcessSelected;
  List<ItemSelectDataActModel>? statusProcessRadioList;
  ItemSelectDataActModel? signatureSelected;
  List<ItemSelectDataActModel>? signatureRadioList;
  TextEditingController? txtFromDateController;
  TextEditingController? txtToDateController;
  TextEditingController? txtKeywordController;
  PrCodeName? customerSelected;
  List<PrCodeName>? customerList;
  PrCodeName? staffSelected;
  List<PrCodeName>? staffListSelected;
  List<PrCodeName>? staffList;
  PrCodeName? projectSelected;
  List<PrCodeName>? projectList;
  PrCodeName? documentSelected;
  List<PrCodeName>? documentList;
  PrCodeName? prCodeStatusSelected;
  List<PrCodeName>? prCodeListStatusSelected;
  FilterInfoModel({this.shopSelected,this.listShops,this.listProducts,this.productSelected, this.signatureSelected, this.signatureRadioList,
    this.workTimeList,this.workTimeSelected,this.statusRadioList,this.statusSelected, this.documentList, this.documentSelected, this.staffList, this.staffSelected,
    this.txtFromDateController,this.txtToDateController, this.customerList, this.customerSelected, this.projectList, this.projectSelected, this.statusProcessSelected, this.statusProcessRadioList,
    this.shopsSelected,this.staffListSelected,this.tagSelected,this.prCodeListStatusSelected,this.prCodeStatusSelected,this.txtKeywordController
  });

  String get getShopLength{
    String result = "";
    try{
      if(shopsSelected != null && shopsSelected!.isNotEmpty){
        if(shopsSelected!.length ==1){
          result = shopsSelected![0].name??"";
        }
        else{
          result = "${shopsSelected!.length} cửa hàng";
        }
      }
      else if(!PrCodeName.isEmpty(shopSelected)){
        result = shopSelected?.name??"";
      }
      else if(listShops != null){
        result = "${listShops!.length} của hàng";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getShopLength");
    }
    return result;
  }
}
