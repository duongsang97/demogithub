import 'dart:io';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/boxs/boxElementTitle.Component.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/actInventoryTracking/actInvGiftModel/dataPrdActInvGift.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import '../dataTableCustom/dataTableCustom.Component.dart';
import '../modalSheet/modalSheet.Component.dart';
import '../selectBox/selectBoxVersatile.Component.dart';
import 'package:get/get.dart';

class ProductHandleComponent extends StatefulWidget {
  ProductHandleComponent({super.key,this.title="Danh sách dữ liệu",this.isAdd=true, this.onChangedText, this.formType = true,
  required this.listData,required this.listProducts, required this.listTemp, this.type,this.isEdit=true,this.isView=false, this.listFormatInput});
  final String title;
  final bool isAdd;
  final bool isEdit;
  final PrCodeName? type;
  final bool? isView; // xử lý hiển thị đối với phiếu yêu cầu qua
  final List<DataPrdActInvGiftModel> listData;
  final List<DataPrdActInvGiftModel> listTemp;
  final List<PrCodeName> listProducts;
  final List<PrCodeName>? listFormatInput;
  final Function(String)? onChangedText;
  final bool formType; // false --> thêm mới , true --> sửa
  @override
  State<ProductHandleComponent> createState() => _ProductHandleComponentState();
}

class _ProductHandleComponentState extends State<ProductHandleComponent> {
  
  PrCodeName productSelected = PrCodeName();
  DataPrdActInvGiftModel dataSelected = DataPrdActInvGiftModel();
  bool formType = false; // false = thêm mới, true = sửa
  TextEditingController txtQuantityActualController  = TextEditingController(); // số lượng thực tế tại của hàng
  TextEditingController txtQuantityController  = TextEditingController(); // só lượng
  TextEditingController txtQuantityCreatedController  = TextEditingController(); // só lượng
  TextEditingController txtQuantityRemainController  = TextEditingController(); // só lượng
  List<Widget> columns = List<Widget>.empty(growable: true);
  Map<int, TableColumnWidth> columnSize = {};
  bool isSearch = false;
  TextEditingController textSearchKeyWordController = TextEditingController();
  
  int getTypeForm(){
    int result =-1;
    try{
      result = int.parse(widget.type?.code??"-1");
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getTypeForm productHandle.Component");
    }
    return result;
  }

  double handleInputData(String? input){
    double result = 0.0;
    try{
      result = double.parse(input??"0");
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleInputData productHandle.Component");
    }
    return result;
  }

  // void onChangedText(String value) async {
  //   try {
  //     List<DataPrdActInvGiftModel> listGift = List.empty(growable: true);
  //     for (var gift in widget.listTemp) {
  //       if (gift.product != null && gift.product!.keyword != null && gift.product!.keyword!.contains(value)) {
  //         listGift.add(gift);
  //       }
  //     }
  //     widget.listData = listGift;
  //   } catch (ex) {
  //     AppLogsUtils.instance.writeLogs(ex,func: "saveInOutGift createWareHouseInOut.Controller");
  //   }
  // }

  List<Widget> getTableColumn(){
    List<Widget> result = List<Widget>.empty(growable: true);
    result.add(Container(height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: isSearch ? TextField(
                  controller: textSearchKeyWordController,
                  onChanged: (value) {
                    if (widget.onChangedText != null) {
                      widget.onChangedText!(value);
                      if (mounted) {
                        setState(() {
                        });
                      }
                    }
                  },
                  style: const TextStyle(color: Colors.white,fontSize: 13),
                    cursorColor: AppColor.whiteColor,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: "Nhập từ khóa...",
                        hintStyle: TextStyle(color: Colors.white)
                      ),
                  ) : const Text("Tên SP",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold, fontSize: 11),)
            ),
            Visibility(
              visible: true,
              child: GestureDetector(
                onTap:(){
                  if (mounted) {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  }
                },
                child: Align(alignment: Alignment.centerRight, child: Icon(isSearch ? Icons.search_off : Icons.search, color: AppColor.whiteColor, size: 17))
              )
            )
          ],
        ),
    ));
    if (getTypeForm()==5 || getTypeForm()==6) {
      result.add(
        Container(height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          child: Text("warehouse.productHandle.quantityCreated".tr,textAlign: TextAlign.center,style: const TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 11),),
        ),
      );
    }
    result.add(
      Container(height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        child: Text(getTypeForm()==3?"Yêu cầu":( widget.formType ? 'warehouse.productHandle.quantity'.tr : 'warehouse.productHandle.quantityCreated'.tr),textAlign: TextAlign.center,style: const TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 11),),
      ),
    );

    if((getTypeForm()==3 || getTypeForm()==4) && (widget.isView??false)){
      result.add(
        Container(height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          child: const Text("Đã chuyển",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 11),),
        ),
      );
    }
    else if(getTypeForm()==3 && !(widget.isView??false)){
      result.add(
        Container(height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          child: const Text("Tồn",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 11),),
        ),
      );
    }
    // phiếu chuyển
    else if(getTypeForm()==2 && !(widget.isView??false)){
      result.add(
        Container(height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          child: const Text("Thực nhận",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 11),),
        ),
      );
    }
    // if(widget.isEdit){
    //   result.add(
    //     Container(height: 40,
    //       padding: const EdgeInsets.symmetric(horizontal: 5),
    //       alignment: Alignment.center,
    //       child: const Text("Chức năng",textAlign: TextAlign.center,style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),),
    //     ),
    //   );
    // }
    return result;
  }

  TableRow getTableRow(DataPrdActInvGiftModel item){
    List<Widget> result = List<Widget>.empty(growable: true);
    result.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(item.product?.name??"n/a", style: const TextStyle(fontSize: 13),),
    ));
    if (getTypeForm()==5 || getTypeForm()==6) {
      result.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: AppColor.whiteColor,
          child: TextInputComponent(
            enable: getTypeForm()==6,
            contentPadding: EdgeInsets.zero,
            textStyle: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            inputFormattersCustom: widget.listFormatInput,
            keyboardType: Platform.isIOS?const TextInputType.numberWithOptions(decimal: true, signed: true):TextInputType.number,
            txtInputAction: TextInputAction.done,
            title: "",
            fillColor: AppColor.whiteColor,
            controller: item.txtQuantityCreatedController,
            onChanged: (String v) async{
            try{
                item.quantity = double.parse(v) ;
              }
              catch(ex){
                item.quantity = 0;
              }
            },
          ),
        )
      );
    }
    result.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        color: AppColor.whiteColor,
        child: TextInputComponent(
          enable: widget.isEdit,
          contentPadding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
          inputFormattersCustom: widget.listFormatInput,
          keyboardType: Platform.isIOS?const TextInputType.numberWithOptions(decimal: true, signed: true):TextInputType.number,
          txtInputAction: TextInputAction.done,
          title: "",
          fillColor: AppColor.whiteColor,
          controller: item.txtQuantityController,
          onChanged: (String v) async{
           try{
              item.quantity = double.parse(v);
            }
            catch(ex){
              item.quantity = 0;
            }
          },
        ),
      ),
      //Text('${item.quantity??0} (${item.product?.codeDisplay??""})',textAlign: TextAlign.center,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,)),
    );
    // Phiếu yêu cầu quà, Phiếu nợ quà
    if((getTypeForm()==3 || getTypeForm()==4) && (widget.isView??false)){
      result.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: AppColor.whiteColor,
          child: TextInputComponent(
            enable: widget.isEdit,
            contentPadding: EdgeInsets.zero,
            textStyle: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            inputFormattersCustom: widget.listFormatInput,
            keyboardType: Platform.isIOS?const TextInputType.numberWithOptions(decimal: true, signed: true):TextInputType.number,
            txtInputAction: TextInputAction.done,
            title: "",
            fillColor: AppColor.whiteColor,
            controller: item.txtQuantityQtyTransferController,
            onChanged: (String v) async{
              try{
                item.qtyTransfer = double.parse(v);
              }
              catch(ex){
                item.qtyTransfer = 0;
              }
            },
          ),
        ),
      );
      //result.add(Text('${item.qtyTransfer??0} (${item.product?.codeDisplay??""})',textAlign: TextAlign.center,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,)),);
    }
    // phiếu yêu cầu quà
    else if(getTypeForm()==3 && !(widget.isView??false)){
      result.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: AppColor.whiteColor,
          child: TextInputComponent(
            enable: widget.isEdit,
            contentPadding: EdgeInsets.zero,
            textStyle: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            inputFormattersCustom: widget.listFormatInput,
            keyboardType: Platform.isIOS?const TextInputType.numberWithOptions(decimal: true, signed: true):TextInputType.number,
            txtInputAction: TextInputAction.done,
            title: "",
            fillColor: AppColor.whiteColor,
            controller: item.txtQuantityRemainController,
            onChanged: (String v) async{
              try{
                item.quantityRemain = double.parse(v);
              }
              catch(ex){
                item.quantityRemain = 0;
              }
            },
          ),
        ),
      );
      //result.add(Text('${item.quantityRemain ??0} (${item.product?.codeDisplay??""})',textAlign: TextAlign.center,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,)),);
    }
    // phiếu chuyển kho
    else if(getTypeForm()==2 && !(widget.isView??false)){
      result.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: AppColor.whiteColor,
          child: TextInputComponent(
            enable: widget.isEdit,
            contentPadding: EdgeInsets.zero,
            textStyle: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            inputFormattersCustom: widget.listFormatInput,
            keyboardType: Platform.isIOS?const TextInputType.numberWithOptions(decimal: true, signed: true):TextInputType.number,
            txtInputAction: TextInputAction.done,
            title: "",
            fillColor: AppColor.whiteColor,
            controller: item.txtQuantityActualController,
            onChanged: (String v) async{
              try{
                item.quantityActual = double.parse(v);
              }
              catch(ex){
                item.quantityActual = 0;
              }
              
              // if(widget.onChange != null){
              //    widget.onChange!();
              // }
            },
          ),
        ),
      );
      //result.add(Text('${item.qtyTransfer ??0} (${item.product?.codeDisplay??""})',textAlign: TextAlign.center,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,)),);
    }
    // if(widget.isEdit){
    //   result.add(
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         IconButtonComponent(
    //           icon: const Icon(Icons.edit,color: AppColor.brightBlue), 
    //           onPress: () async{
    //             setDataInput(item);
    //             await ModalSheetComponent.showBarModalBottomSheet(
    //               isDismissible: true,
    //               context: context,
    //               formSize: 0.7,
    //               _buildBoxAddProduct(),
    //               title: "Cập nhật sản phẩm",
    //             );
    //             cleanInputData();
    //           }
    //         ),
    //         IconButtonComponent(
    //           icon: const  Icon(Icons.close_outlined,color: AppColor.brightRed,),
    //           onPress: () async {
    //             var result = await Alert.showDialogConfirm("Thông báo", "Bạn chắc chắn muốn xóa dữ liệu này?");
    //             if(result){
    //               setState(() {
    //                 widget.listData.removeWhere((element) => (element.product?.code??"") == (item.product?.code??""));
    //               });
    //             }
    //           },
    //         ),
    //       ],
    //     )
    //   );
    // }
    
    return TableRow(
      decoration: const BoxDecoration(
        color: AppColor.whiteColor
      ),
      children: result
    );
  }

  bool validateGift(){
    String msg ="";
    String pattern = r'[0-9-]';
    RegExp regExp = RegExp(pattern);
    if(PrCodeName.isEmpty(productSelected)){
      msg+="\n+ Chưa chọn sản phẩm";
    }
    if(txtQuantityController.text.isEmpty){
      msg+="\n+ Số lượng không được bỏ trống";
    }
    // if(txtQuantityCreatedController.text.isEmpty){
    //   msg+="\n+ Số lượng không được bỏ trống";
    // }
    else{
      if(txtQuantityController.text.length>16 || !regExp.hasMatch(txtQuantityController.text)){
        msg+="\n+ Số lượng không hợp lệ";
      }
    }
    if(msg.isNotEmpty){
      AlertControl.push(msg, type: AlertType.ERROR);
      return false;
    }
    else{
      return true;
    }
  }

  void cleanInputData(){
    if(mounted){
      setState(() {
        formType = false;
        productSelected = PrCodeName();
        txtQuantityController.clear();
        txtQuantityCreatedController.clear();
        txtQuantityRemainController.clear();
      });
    }
  }

  void setDataInput(DataPrdActInvGiftModel item){
    setState(() {
      formType = true;
      productSelected = item.product??PrCodeName();
      txtQuantityController.text = (item.quantity??0).toString();
      txtQuantityCreatedController.text = formatNumberDouble(item.qtyCreated??0);
      txtQuantityRemainController.text = formatNumberDouble(item.quantityRemain??0);
    });
  }

  void addItem(){
    if(validateGift()){
      final index = widget.listData.indexWhere((item) => (item.product?.code??"") == (productSelected.code??""));
      if(index >=0) {
        widget.listData[index].quantity = ((widget.listData[index].quantity)??0) + handleInputData(txtQuantityController.text);
        //widget.listData[index].qtyTransfer = ((widget.listData[index].quantityRemain)??0) +handleInputData(txtQuantityActualController.text);
        widget.listTemp[index].qtyCreated = ((widget.listTemp[index].qtyCreated)??0) + handleInputData(txtQuantityCreatedController.text);
        
      }
      else{
        widget.listData.add(DataPrdActInvGiftModel(product: productSelected,
          quantity: handleInputData(txtQuantityController.text),
          quantityRemain: handleInputData(txtQuantityRemainController.text),
          qtyTransfer: 0, quantityActual: 0
        ));
        widget.listTemp.add(DataPrdActInvGiftModel(product: productSelected,
          quantity: handleInputData(txtQuantityController.text),
          quantityRemain: handleInputData(txtQuantityRemainController.text),
          qtyTransfer: 0, quantityActual: 0
        ));
        widget.listData.add(DataPrdActInvGiftModel(product: productSelected,
          quantity: handleInputData(txtQuantityCreatedController.text),
          quantityRemain: handleInputData(txtQuantityRemainController.text),
          qtyTransfer: 0, quantityActual: 0
        ));
        widget.listTemp.add(DataPrdActInvGiftModel(product: productSelected,
          quantity: handleInputData(txtQuantityCreatedController.text),
          quantityRemain: handleInputData(txtQuantityRemainController.text),
          qtyTransfer: 0, quantityActual: 0
        ));
      }
      cleanInputData();
      AlertControl.push("Thêm thành công", type: AlertType.SUCCESS);
    }
  }

  void updateItem(){
    if(validateGift()){
      var result = widget.listData.firstWhere((element) => element.product?.code == productSelected.code,orElse: ()=>DataPrdActInvGiftModel());
      if(!PrCodeName.isEmpty(result.product)){
        result.quantity = handleInputData(txtQuantityController.text);
        result.qtyCreated = handleInputData(txtQuantityCreatedController.text);
        result.quantityRemain = handleInputData(txtQuantityRemainController.text);
      }
      cleanInputData();
      AlertControl.push("Sửa thành công", type: AlertType.SUCCESS);
    }
  }

  @override
  void initState(){
    super.initState();
    // formatNumberQuantity();
    WidgetsBinding.instance.addPostFrameCallback((_){
    });
  }

  void formatNumberQuantity() {
    try {
      for (var item in widget.listTemp) {
        if (double.tryParse(item.txtQuantityController.text) != null) {
          item.txtQuantityController.text = formatNumberDouble(double.parse(item.txtQuantityController.text));
        }
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "formatNumberQuantity");
    }
  }

  void handleTableData(){
    columns = getTableColumn();
    columnSize.clear();
    columnSize.addAll({
      0: FlexColumnWidth(columns.length>3?3.5:5),
    });
    for(int i =1; i<= (columns.length-1);i++){
      columnSize.addAll({
        i: const FlexColumnWidth(2),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    handleTableData();
    return SingleChildScrollView(
      child: Column(
        children: [
          BoxElementTitleComponent(
            title: widget.title,
            // rightNavbar: _buildRightNavbar()
          ),
          const SizedBox(height: 5,),
          _buildDataTable(),
          
        ],
      ),
    );
  }

  Widget _buildDataTable(){
    return columns.isNotEmpty
    ?DataTableCustomComponent(
      border: TableBorder.all(  
        color: Colors.green,  
        style: BorderStyle.solid,  
        width: 0.5
      ),
      columnWidths: columnSize,
      column: columns,
      columnStyle: BoxDecoration(
        color: AppColor.greenMonth,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      // rows: widget.listData.map<TableRow>((e) =>getTableRow(e)).toList()
      rows: widget.listTemp.map<TableRow>((e) =>getTableRow(e)).toList()
      ,
    ): const Center(child: Text("Không có dữ liệu"),);
  }

  // DataTable(
  //         showCheckboxColumn:false,
  //         dataRowHeight: 50,
  //         dividerThickness: 2,
  //         showBottomBorder: true,
  //         headingRowColor: MaterialStateColor.resolveWith((states) {return Color.fromRGBO(128, 139, 150, 0.4);}),
  //         headingRowHeight:40,
  //         horizontalMargin: 10, 
  //         columns: getTableColumn(),
  //         rows: widget.listData.map<DataRow>((e) => DataRow(cells:getTableRow(e))).toList()
  //       ),


}