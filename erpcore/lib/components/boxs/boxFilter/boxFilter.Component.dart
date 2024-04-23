import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/boxs/boxFilter/models/filterInfo.Model.dart';
import 'package:erpcore/components/boxs/boxTitleContent.Component.dart';
import 'package:erpcore/components/buttons/buttonLogin.Component.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/components/radioButton/radioButton.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

import '../../selectBox/selectBoxVersatile.Component.dart';

class BoxFilterComponent extends StatefulWidget {
  BoxFilterComponent({Key? key,required this.onPress,required this.boxItemFilter,this.funcGetListShift,this.funcGetListProductActSellOut,this.funcGetListShopAct,this.funcGetListStatusApprovedInv,this.funcGetListStatusMaintenance,this.funcGetListStatusTransport,
    this.funcGetListCustomer, this.funcGetListProject, this.funcGetListDocument, this.funcGetListStatusProcessApprovedInv, this.isCancelClearDate = true, this.funcGetListStaff, this.isMultiSelectShop = false,this.funcGetListPrStatus
  }) : super(key: key);
  final VoidCallback onPress;
  final FilterInfoModel boxItemFilter;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize})? funcGetListShift;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize})? funcGetListCustomer;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize})? funcGetListDocument;
  final Function({String keyword,int pageNumber,int pageSize})? funcGetListPrStatus;
  final Function({String cusCode, String departCode, String keyWord, int page, int pageSize, String prjCode})? funcGetListStaff;
  final Function()? funcGetListProject;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize, int isOwner})? funcGetListShopAct;
  final Function({String? shopCode})? funcGetListProductActSellOut;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize,String? kind})? funcGetListStatusApprovedInv;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize,String? kind})? funcGetListStatusProcessApprovedInv;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize,String? kind})? funcGetListStatusTransport;
  final Function({String keyword,int sysStatus,int pageNumber,int pageSize,String? kind})? funcGetListStatusMaintenance;
  final bool isCancelClearDate;
  final bool isMultiSelectShop;
  @override
  State<BoxFilterComponent> createState() => _BoxFilterComponentState();
}

var _selectedDate = DateTime.now();
TextStyle txtStyle = TextStyle(color: Colors.grey[600],fontSize: 15);

class _BoxFilterComponentState extends State<BoxFilterComponent> {
  late Size size;
  DateTime dateNow = DateTime.now();
  @override
  void initState() {
    super.initState();
    // if(widget.boxItemFilter.shopSelected!=null){
    //   if(!(widget.boxItemFilter.listShops!=null&&widget.boxItemFilter.listShops!.isNotEmpty)){
    //     fetchDataActShops();
    //   }
    // }
    if(widget.boxItemFilter.productSelected!=null){
      if(!(widget.boxItemFilter.listProducts!=null&&widget.boxItemFilter.listProducts!.isNotEmpty)){
        fetchDataActProducts();
      }
    }
    if(widget.boxItemFilter.workTimeSelected!=null){
      if(!(widget.boxItemFilter.workTimeList!=null&&widget.boxItemFilter.workTimeList!.isNotEmpty)){
        fetchDataShift();
      }
    }
    if(widget.boxItemFilter.statusSelected!=null){
      if(!(widget.boxItemFilter.statusRadioList!=null&& widget.boxItemFilter.statusRadioList!.isNotEmpty)){
        widget.boxItemFilter.statusRadioList?.add(ItemSelectDataActModel(code: '',name: 'Bỏ lọc'));
        fetchDataStatusApproved();
      }
      if(!(widget.boxItemFilter.statusSelected?.code!=null&&widget.boxItemFilter.statusSelected!.code!.isNotEmpty)) {
        widget.boxItemFilter.statusSelected = widget.boxItemFilter.statusRadioList?.first;
      }
    }
    if(widget.boxItemFilter.statusProcessSelected!=null){
      if(!(widget.boxItemFilter.statusProcessRadioList!=null&& widget.boxItemFilter.statusProcessRadioList!.isNotEmpty)){
        widget.boxItemFilter.statusProcessRadioList?.add(ItemSelectDataActModel(code: '',name: 'Bỏ lọc'));
        fetchDataProcessStatusApproved();
      }
      if(!(widget.boxItemFilter.statusProcessSelected?.code!=null&&widget.boxItemFilter.statusProcessSelected!.code!.isNotEmpty)) {
        widget.boxItemFilter.statusProcessSelected = widget.boxItemFilter.statusProcessRadioList?.first;
      }
    }
    if(widget.boxItemFilter.signatureSelected!=null){
      if(!(widget.boxItemFilter.signatureSelected?.code!=null&&widget.boxItemFilter.signatureSelected!.code!.isNotEmpty)) {
        widget.boxItemFilter.signatureSelected = widget.boxItemFilter.signatureRadioList?.first;
      }
    }
    if(widget.boxItemFilter.customerSelected!=null){
      if(!(widget.boxItemFilter.customerList!=null&&widget.boxItemFilter.customerList!.isNotEmpty)){
        fetchDataCustomer().then((value) {
          if(widget.boxItemFilter.staffSelected!=null){
            if(!(widget.boxItemFilter.staffList!=null&&widget.boxItemFilter.staffList!.isNotEmpty)){
              fetchDataStaff();
            }
          }
        });
      }
    } else {
      if(widget.boxItemFilter.staffSelected!=null){
        if(!(widget.boxItemFilter.staffList!=null&&widget.boxItemFilter.staffList!.isNotEmpty)){
          fetchDataStaff();
        }
      }
    }
    if(widget.boxItemFilter.projectSelected!=null){
      if(!(widget.boxItemFilter.projectList!=null&&widget.boxItemFilter.projectList!.isNotEmpty)){
        fetchDataProject();
      }
    }
    if(widget.boxItemFilter.documentSelected!=null){
      if(!(widget.boxItemFilter.documentList!=null&&widget.boxItemFilter.documentList!.isNotEmpty)){
        fetchDataDocument();
      }
    }
    LoadingComponent.dismiss();

    setStateIfMounted();
  }
  @override
  void dispose() {
    super.dispose();
  }
  void setStateIfMounted() {
    if (mounted){
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: widget.boxItemFilter.txtKeywordController != null,
              child: TextInputComponent(
                heightBox: 45,
                title: "Từ khoá ", 
                placeholder: "Nhập giá trị",
                controller: widget.boxItemFilter.txtKeywordController??TextEditingController(),
              ),
            ),
            Visibility(
              visible: widget.boxItemFilter.shopSelected!=null,
              child: SelectBoxVersatileComponent(
                displayType: true,
                enable: widget.boxItemFilter.listShops!=null,
                isMultipleSeleted: widget.isMultiSelectShop,
                label: "Cửa hàng",
                listSelectedItem: widget.boxItemFilter.shopsSelected,
                selectedItem: widget.boxItemFilter.shopSelected,
                asyncListData: (String keyword,int page, int pageSize){
                  return fetchDataActShops(keyword: keyword,page: page,pageSize: pageSize);
                },
                listData: (widget.boxItemFilter.listShops)??[],
                onChangedMultiple: (List<PrCodeName> items){
                  widget.boxItemFilter.shopsSelected = items;
                  setStateIfMounted();
                  if(widget.boxItemFilter.productSelected!=null){
                    fetchDataActProducts();
                  }
                  
                },
                isRemove: true,
                onChanged: (PrCodeName? item) async{
                  if(!PrCodeName.isEmpty(item)){
                      widget.boxItemFilter.shopSelected = item!;
                      if(widget.boxItemFilter.productSelected!=null){
                        fetchDataActProducts();
                      }
                    }
                    else{
                      widget.boxItemFilter.shopSelected = PrCodeName();
                      if(widget.boxItemFilter.productSelected!=null){
                        widget.boxItemFilter.productSelected = PrCodeName();
                        widget.boxItemFilter.listProducts?.clear();
                      }
                    }
                  setStateIfMounted();
                }
              ),
            ),
            Visibility(
              visible: widget.boxItemFilter.productSelected!=null,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  SelectBoxVersatileComponent(
                    enable: !PrCodeName.isEmpty(widget.boxItemFilter.shopSelected),
                    displayType: true,
                    label: "Sản phẩm",
                    selectedItem: widget.boxItemFilter.productSelected,
                    listData:widget.boxItemFilter.listProducts??[],
                    onChanged: (PrCodeName? item) async {
                      if (!PrCodeName.isEmpty(item)) {
                        widget.boxItemFilter.productSelected = item!;
                      } else {
                        widget.boxItemFilter.productSelected = PrCodeName();
                      }
                      setStateIfMounted();
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.boxItemFilter.statusProcessSelected!=null,
              child: BoxTitleContentComponent(
                title: 'Trạng thái xử lý',
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics:  const NeverScrollableScrollPhysics(),
                  itemCount: widget.boxItemFilter.statusProcessRadioList?.length??0,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio: (1 / .3),
                    childAspectRatio: (size.width / (size.height*.1)),
                  ),
                  itemBuilder: (context, index) {
                    return RadioButtonComponent(
                      itemSelected: widget.boxItemFilter.statusProcessSelected,
                      item: (widget.boxItemFilter.statusProcessRadioList??[])[index],
                      onChanged: (item) {
                        widget.boxItemFilter.statusProcessSelected = item;
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ), 
            Visibility(
              visible: widget.boxItemFilter.statusSelected!=null,
              child: BoxTitleContentComponent(
                title: 'Trạng thái',
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.boxItemFilter.statusRadioList?.length??0,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio: (1 / .3),
                    childAspectRatio: (size.width / (size.height*.1)),
                  ),
                  itemBuilder: (context, index) {
                    return RadioButtonComponent(
                      itemSelected: widget.boxItemFilter.statusSelected,
                      item: (widget.boxItemFilter.statusRadioList??[])[index],
                      onChanged: (item) {
                        widget.boxItemFilter.statusSelected = item;
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ), 
             Visibility(
              visible: widget.boxItemFilter.prCodeStatusSelected!=null || widget.boxItemFilter.prCodeListStatusSelected != null,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SelectBoxVersatileComponent(
                  displayType: true,
                  isMultipleSeleted: widget.boxItemFilter.prCodeListStatusSelected != null,
                  label: "Trạng thái",
                  selectedItem: widget.boxItemFilter.prCodeStatusSelected,
                  listSelectedItem: widget.boxItemFilter.prCodeListStatusSelected,
                  asyncListData: (String keyword,int page,int pageSize){
                    if(widget.funcGetListPrStatus != null){
                      return widget.funcGetListPrStatus!(keyword: keyword,pageNumber: page,pageSize: pageSize);
                    }
                  },
                  onChanged: (PrCodeName? item) async {
                    if (!PrCodeName.isEmpty(item)) {
                      widget.boxItemFilter.prCodeStatusSelected = item!;
                    } else {
                      widget.boxItemFilter.prCodeStatusSelected = PrCodeName();
                    }
                    setStateIfMounted();
                  },
                  onChangedMultiple: (v){
                    widget.boxItemFilter.prCodeListStatusSelected =v;
                    setStateIfMounted();
                  },
                ),
              ),
            ),
            Visibility(
              visible: widget.boxItemFilter.workTimeSelected!=null,
              child: Column(
                children: [
                  const SizedBox( height: 15),
                  SelectBoxVersatileComponent(
                    enable: widget.boxItemFilter.workTimeList!=null,
                    displayType: true,
                    label: "Ca làm việc",
                    selectedItem: widget.boxItemFilter.workTimeSelected,
                    listData: widget.boxItemFilter.workTimeList??[],
                    onChanged: (PrCodeName? item) async{
                      if(!PrCodeName.isEmpty(item)){
                        widget.boxItemFilter.workTimeSelected = item;
                      }
                      else{
                        widget.boxItemFilter.workTimeSelected =PrCodeName();
                      }
                    }
                  ),  
                ],
              ),
            ),  
            Visibility(
              visible: widget.boxItemFilter.customerSelected!=null,
              child: Column(
                children: [
                  const SizedBox( height: 15),
                  SelectBoxVersatileComponent(
                    enable: widget.boxItemFilter.customerList!=null,
                    displayType: true,
                    label: "Khách hàng",
                    selectedItem: widget.boxItemFilter.customerSelected,
                    listData: widget.boxItemFilter.customerList??[],
                    isRemove: true,
                    onChanged: (PrCodeName? item) async{
                      if(!PrCodeName.isEmpty(item)){
                        widget.boxItemFilter.customerSelected = item;
                        if(widget.boxItemFilter.projectSelected!=null){
                          widget.boxItemFilter.projectList!.clear();
                          widget.boxItemFilter.projectSelected = PrCodeName();
                          fetchDataProject();
                        }
                      }
                      else{
                        widget.boxItemFilter.customerSelected =PrCodeName();
                      }
                    }
                  ),  
                ],
              ),
            ),  
            Visibility(
              visible: widget.boxItemFilter.staffSelected!=null || widget.boxItemFilter.staffListSelected != null,
              child: Column(
                children: [
                  const SizedBox( height: 15),
                  SelectBoxVersatileComponent(
                    displayType: true,
                    isMultipleSeleted: widget.boxItemFilter.staffListSelected != null?true:false,
                    label: "Nhân viên",
                    selectedItem: widget.boxItemFilter.staffSelected,
                    listSelectedItem: widget.boxItemFilter.staffListSelected,
                    isRemove: true,
                    listData: widget.boxItemFilter.staffList??[],
                    asyncListData: (String keyword,int page,int pageSize){
                      if(widget.funcGetListStaff != null){
                        return widget.funcGetListStaff!(keyWord: keyword,page: page,pageSize: pageSize);
                      }
                    },
                    onChanged: (PrCodeName? item) async{
                      if(!PrCodeName.isEmpty(item)){
                        widget.boxItemFilter.staffSelected = item;
                        if(widget.boxItemFilter.projectSelected!=null){
                          widget.boxItemFilter.projectList!.clear();
                          widget.boxItemFilter.projectSelected = PrCodeName();
                          fetchDataStaff();
                        }
                      }
                      else{
                        widget.boxItemFilter.staffSelected =PrCodeName();
                        setState(() {
                          
                        });
                      }
                    },
                    onChangedMultiple: (v){
                      setState(() {
                        widget.boxItemFilter.staffListSelected = v;
                      });
                    },
                  ),  
                ],
              ),
            ),  
            Visibility(
              visible: widget.boxItemFilter.projectSelected!=null,
              child: Column(
                children: [
                  const SizedBox( height: 15),
                  SelectBoxVersatileComponent(
                    enable: widget.boxItemFilter.projectList!=null,
                    displayType: true,
                    label: "Dự án",
                    selectedItem: widget.boxItemFilter.projectSelected,
                    listData: widget.boxItemFilter.projectList??[],
                    onChanged: (PrCodeName? item) async{
                      if(!PrCodeName.isEmpty(item)){
                        widget.boxItemFilter.projectSelected = item;
                      }
                      else{
                        widget.boxItemFilter.projectSelected =PrCodeName();
                      }
                    }
                  ),  
                ],
              ),
            ),  
            Visibility(
              visible: widget.boxItemFilter.documentSelected!=null,
              child: Column(
                children: [
                  const SizedBox( height: 15),
                  SelectBoxVersatileComponent(
                    enable: widget.boxItemFilter.documentList!=null,
                    displayType: true,
                    label: "Loại tài liệu",
                    selectedItem: widget.boxItemFilter.documentSelected,
                    isMultipleSeleted: true,
                    listSelectedItem: const [],
                    onChangedMultiple:(List<PrCodeName>? item) {
                      
                    },
                    listData: widget.boxItemFilter.documentList??[],
                    onChanged: (PrCodeName? item) async{
                      if(!PrCodeName.isEmpty(item)){
                        widget.boxItemFilter.documentSelected = item;
                      }
                      else{
                        widget.boxItemFilter.documentSelected =PrCodeName();
                      }
                    }
                  ),  
                ],
              ),
            ),  
            const SizedBox( height: 10),
            Visibility(
              visible: widget.boxItemFilter.txtFromDateController!=null && widget.boxItemFilter.txtToDateController!=null,
              child: _buildBoxInput(),
            ),
            const SizedBox( height: 15),
            ButtonLoginComponent(
              btnLabel: "Áp dụng",
              onPressed: (){
                  widget.onPress();
                Navigator.pop(context);
              },
            )
          ],
        )
      ),
    );
  }
    Widget _buildBoxInput(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextInputComponent(title: "Từ ngày", placeholder: "yyyy-MM-dd",
            heightBox: 45,
            icon: const Icon(Icons.calendar_month),
            controller: (widget.boxItemFilter.txtFromDateController)??TextEditingController(),
            enable: false,
            onTab: (){
              onTabChooseDatetion(context,
                onConfirm: (v){
                  widget.boxItemFilter.txtFromDateController?.text = v;
                  (widget.boxItemFilter.txtToDateController)?.clear();
                  setStateIfMounted();
                },
                onCancel: ()=>{
                 widget.isCancelClearDate ? (widget.boxItemFilter.txtFromDateController)?.clear() : null
                }
              );
            },
          )
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: TextInputComponent(
            heightBox: 45,
            title: "Đến ngày", 
            placeholder: "yyyy-MM-dd",
            icon: const Icon(Icons.calendar_month),
            controller: (widget.boxItemFilter.txtToDateController)??TextEditingController(),
            enable: false,
            onTab: (){
              onTabChooseDatetion(context,
              minTime: ((widget.boxItemFilter.txtFromDateController?.text??"").isNotEmpty)?DateTime.parse(widget.boxItemFilter.txtFromDateController!.text):null,
                onConfirm: (v)=>{
                  widget.boxItemFilter.txtToDateController?.text = v
                },
                onCancel: ()=>{
                  widget.isCancelClearDate ? widget.boxItemFilter.txtToDateController?.clear() : null
                }
              );
            },
          )
        ),
      ],
    );
  }
  Future<ResponsesModel> fetchDataActShops({String keyword ="",int page =1,int pageSize =15}) async{
    return await widget.funcGetListShopAct!(keyword: keyword,pageNumber:page,pageSize:pageSize);
  }
  // // danh sách cửa hàng
  // Future<void> fetchDataActShops({String? keyword}) async{
  //   if(widget.funcGetListShopAct!=null){
  //     LoadingComponent.show(status: "Đang lấy danh sách cửa hàng");
  //     var result = await widget.funcGetListShopAct!(keyword: keyword??"",pageSize:1000);
  //     LoadingComponent.dismiss();
  //     if(result.statusCode == 0){
  //       widget.boxItemFilter.listShops = result.data;
  //       if((widget.boxItemFilter.listShops??[]).isNotEmpty && widget.boxItemFilter.listShops?.length == 1){
  //         widget.boxItemFilter.shopSelected = widget.boxItemFilter.listShops?.first;
  //         if(widget.boxItemFilter.productSelected!=null){
  //           fetchDataActProducts();
  //         }
  //       }
  //     setStateIfMounted();
  //     }
  //     else{
  //       AlertControl.push(result.msg??"",type: AlertType.ERROR);
  //     }
  //   }
  // }

    // danh sách sản phẩm theo cửa hàng
  Future<void> fetchDataActProducts({String? keyword}) async{
    if(widget.funcGetListProductActSellOut!=null){
      LoadingComponent.show(msg: "Đang lấy danh sách sản phẩm");
      var result = await widget.funcGetListProductActSellOut!(shopCode: widget.boxItemFilter.shopSelected?.code??"");
      LoadingComponent.dismiss();
      if(result.statusCode == 0){
        widget.boxItemFilter.listProducts = result.data;
        if((widget.boxItemFilter.listProducts??[]).isNotEmpty && (widget.boxItemFilter.listProducts?.length??0) == 1){
          widget.boxItemFilter.productSelected = widget.boxItemFilter.listProducts?.first;
        }
      setStateIfMounted();
      }
      else{
        AlertControl.push(result.msg??"",type: AlertType.ERROR);
      }
    }
  }

  // lấy danh sách ca làm việc
  Future<void> fetchDataShift() async{
    if(widget.funcGetListShift != null){
      LoadingComponent.show(msg: "Đang tải dữ liệu ca làm việc");
      var result = await widget.funcGetListShift!(pageSize:10);
      LoadingComponent.dismiss();
      if(result.statusCode == 0){
        widget.boxItemFilter.workTimeList = result.data;
        setStateIfMounted();
      }
      else{
        AlertControl.push(result.msg??"",type: AlertType.ERROR);
      }
    }
  }

  // Lấy dữ liệu trạng thái phiếu (duyệt/chưa duyệt)
  Future<void> fetchDataStatusApproved() async{
    ResponsesModel result = ResponsesModel.create();
    LoadingComponent.show(msg: "Đang lấy dữ liệu trạng thái");
    if(widget.boxItemFilter.tagSelected?.code == '6'){//vận chuyển
      if(widget.funcGetListStatusTransport!=null){
        result = await widget.funcGetListStatusTransport!(pageSize:10,kind: widget.boxItemFilter.tagSelected?.code);
      }
    } else if (widget.boxItemFilter.tagSelected?.code == '7'){//bảo trì
      if(widget.funcGetListStatusMaintenance!=null){
        result = await widget.funcGetListStatusMaintenance!(pageSize:10,kind: widget.boxItemFilter.tagSelected?.code);
      }
    } else {
      if(widget.funcGetListStatusApprovedInv!=null){
        result = await widget.funcGetListStatusApprovedInv!(pageSize:10,kind: widget.boxItemFilter.tagSelected?.code);
      }
    }
    LoadingComponent.dismiss();
    if(result.statusCode == 0){
      widget.boxItemFilter.statusRadioList?.addAll(result.data);
      setStateIfMounted();
    }
    else{
      AlertControl.push(result.msg??"", type: AlertType.ERROR);
    }
  }

  Future<void> fetchDataProcessStatusApproved() async{
    ResponsesModel result = ResponsesModel.create();
    LoadingComponent.show(msg: "Đang lấy dữ liệu trạng thái xử lý");
    if(widget.funcGetListStatusProcessApprovedInv!=null){
      result = await widget.funcGetListStatusProcessApprovedInv!(pageSize:10,kind: widget.boxItemFilter.tagSelected?.code);
    }
    LoadingComponent.dismiss();
    if(result.statusCode == 0){
      widget.boxItemFilter.statusProcessRadioList?.addAll(result.data);
      setStateIfMounted();
    }
    else{
      AlertControl.push(result.msg??"", type: AlertType.ERROR);
    }
  }

  Future<void> fetchDataCustomer() async {
    if(widget.funcGetListCustomer != null){
      LoadingComponent.show(msg: "Đang tải dữ liệu khách hàng");
      var result = await widget.funcGetListCustomer!(pageSize:10);
      LoadingComponent.dismiss();
      if(result.statusCode == 0){
        widget.boxItemFilter.customerList = result.data;
        setStateIfMounted();
      }
      else{
        AlertControl.push(result.msg??"",type: AlertType.ERROR);
      }
    }
  }

  Future<void> fetchDataStaff() async {
    if(widget.funcGetListStaff != null){
      LoadingComponent.show(msg: "Đang tải dữ liệu nhân viên");
      var result = await widget.funcGetListStaff!(pageSize:10);
      LoadingComponent.dismiss();
      if(result.statusCode == 0){
        widget.boxItemFilter.staffList = result.data;
        setStateIfMounted();
      }
      else{
        AlertControl.push(result.msg??"",type: AlertType.ERROR);
      }
    }
  }

  Future<void> fetchDataProject() async {
    if(widget.funcGetListProject != null){
      LoadingComponent.show(msg: "Đang tải dữ liệu dự án");
      var result = await widget.funcGetListProject!();
      if(result.statusCode == 0){
        widget.boxItemFilter.projectList = result.data;
        setStateIfMounted();  
      }
      else{
        AlertControl.push(result.msg??"",type: AlertType.ERROR);
      }
    }
  }

  Future<void> fetchDataDocument() async {
    if(widget.funcGetListDocument != null){
      LoadingComponent.show(msg: "Đang tải dữ liệu dự án");
      var result = await widget.funcGetListDocument!();
      LoadingComponent.dismiss();
      if(result.statusCode == 0){
        widget.boxItemFilter.documentList = result.data;
        setStateIfMounted();  
      }
      else{
        AlertControl.push(result.msg??"",type: AlertType.ERROR);
      }
    }
  }
}
