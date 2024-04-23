import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/boxs/boxElementTitle.Component.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/actInventoryTracking/actInvGiftModel/requestItem.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

import '../modalSheet/modalSheet.Component.dart';

class BoxApproveButtonComponent extends StatefulWidget {
  const BoxApproveButtonComponent({super.key,required this.onPress,required this.formType,required this.item,required this.funcApproveActWareHouseRequest});
  final VoidCallback onPress;
  final int formType;
  final RequestItemModel item;
  final Function(int ,{String sysCode,int approveStatus,String note}) funcApproveActWareHouseRequest;
  @override
  State<BoxApproveButtonComponent> createState() => _BoxApproveButtonComponentState();
}

class _BoxApproveButtonComponentState extends State<BoxApproveButtonComponent> {
  bool isLoadingApprove = false;
  bool isLoadingRefuse = false;
  // ActInventoryProvider actInventoryProvider = ActInventoryProvider();
  TextEditingController txtNoteController = TextEditingController();

  String getStoreNameByType(){
    String result = "";
    try{
      if(widget.formType == 0){
        result=  (widget.item.toStore?.name)??"n/a";
      }
      else{
        result= (widget.item.fromStore?.name)??"n/a";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getStoreNameByType boxApproveButton.Component");
    }
    return result;
  }


  String getCustomerInfo(){
    String result = "";
    try{
      if(widget.item.consumer != null && widget.item.consumer?.name != null && widget.item.consumer!.name!.isNotEmpty){
        result+= (widget.item.consumer?.name)!;
      }
      if(widget.item.consumer != null && widget.item.consumer?.phoneNumber != null && widget.item.consumer!.phoneNumber!.isNotEmpty){
        result+=  " ( ${(widget.item.consumer?.phoneNumber)!} )";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getCustomerInfo boxApproveButton.Component");
    }
    return result;
  }

   //duyệt/từ chối phiếu
  Future<void> approveWareHouseRequest({String? sysCode,int status = 1}) async{
    try{
      ResponsesModel result = ResponsesModel();
      if(widget.formType>-1){
        if(status ==3){
          setState(() {
            isLoadingRefuse = true;
          });
        }
        else if(status==2){
          setState(() {
            isLoadingApprove = true;
          });
        }
        result = await widget.funcApproveActWareHouseRequest(widget.formType,sysCode: sysCode??'',approveStatus: status,note: txtNoteController.text);
        if(status ==3){
          setState(() {
            isLoadingRefuse = false;
          });
        }
        else if(status==2){
          setState(() {
            isLoadingApprove = false;
          });
        }
        if(result.statusCode == 0){
          widget.onPress();
          AlertControl.push(result.msg??"", type: AlertType.SUCCESS);
        }
        else{
          AlertControl.push(result.msg??"", type: AlertType.ERROR);
        }
      }else{
        AlertControl.push("Loại yêu cầu không tồn tại!", type: AlertType.ERROR);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "approveWareHouseRequest boxApproveButton.Component");
      AlertControl.push(ex.toString(), type: AlertType.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ButtonDefaultComponent(
          isLoading:isLoadingApprove,
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          backgroundColor:  AppColor.jadeColor,
          title:"Duyệt",
          onPress: (){
            approveWareHouseRequest(status: 2,sysCode: widget.item.sysCode);
          }
        ),
        const SizedBox(width: 10.0),
        ButtonDefaultComponent(
          isLoading: isLoadingRefuse,
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          backgroundColor:AppColor.brightRed,
          title:"Từ chối",
          onPress: () async {
            await ModalSheetComponent.showBarModalBottomSheet(
              context: context,
              isDismissible: true,
              expand: true,
              formSize: 0.5,
              _buildReasonBox(context),
              title: "Ghi chú từ chối duyệt"
            );
          }
        )
      ],
    );
  }

  Widget _buildReasonBox(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Container(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const BoxElementTitleComponent(
                  title: "Thông tin phiếu",
                  rightNavbar: SizedBox()
                ),
                  Text("Loại phiếu : ${widget.item.kind?.name??''}",style: const TextStyle(color: AppColor.grey,fontSize: 15, fontWeight: FontWeight.bold)),
                  _buildBody()
                ],
              ),
              ),
              TextInputComponent(
                  title: "Ghi chú", 
                  placeholder: "Nhập ghi chú", 
                  controller: txtNoteController,
                  heightBox: 100,
                  maxLine: 10,
                  icon: const Icon(Icons.note),
                ),
              ButtonDefaultComponent(
                backgroundColor: AppColor.brightRed,
                title: "Xác nhận",
                onPress: ()async {
                  approveWareHouseRequest(status: 3,sysCode: widget.item.sysCode);
                  Navigator.pop(context);
                },
              ),
             SizedBox(height:  MediaQuery.of(context).padding.bottom,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(){
    return Wrap(
      children: [
        Visibility(
          visible: widget.formType == 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Cửa hàng: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.shop?.name??""),style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: "Địa chỉ CH: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.shop?.codeDisplay??""),style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              )
            ],
          )
        ),
        Visibility(
          visible: widget.formType == 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Kho xuất: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.fromStore?.name??""),style: const TextStyle(color: AppColor.brightRed,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: "Kho nhận: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.toStore?.name??""),style: const TextStyle(color: AppColor.greenMonth,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: "Số lượng chuyển: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: "${widget.item.totalQty??0} sp",style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.formType == 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Lý do: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.reason?.name??""),style: const TextStyle(color: AppColor.brightRed,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: "Cửa hàng: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.shop?.name??""),style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: "Địa chỉ CH: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.shop?.codeDisplay??""),style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: "Khách hàng: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: getCustomerInfo(),style: const TextStyle(color: AppColor.greenMonth,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
            ],
          )
        ),
        const SizedBox(height: 2,),
        Visibility(
          visible: (widget.formType == 0 || widget.formType ==1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RichText(
              //   text: TextSpan(
              //     text: (widget.formType==0)?"Kho nhập: ":"Kho xuất: ",
              //     style: const TextStyle(color: AppColor.darkText,fontSize: 13),
              //     children: <TextSpan>[
              //       TextSpan(text: getStoreNameByType(),style: TextStyle(color: (widget.formType==0)?AppColor.greenMonth:AppColor.brightRed,fontSize: 14,fontWeight: FontWeight.bold))
              //     ]
              //   )
              // ),
              // const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: (widget.formType==0)?"Số lượng nhập: ":"Số lượng xuất: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: "${widget.item.totalQty??0} sp",style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
            ],
          )
        ),
        const SizedBox(height: 2,),
        Visibility(
          visible: widget.formType == 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Vị trí: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.position?.name??""),style: const TextStyle(color: AppColor.brightRed,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: "Ngày làm việc: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: (widget.item.sWorkingDay??""),style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold))
                  ]
                )
              ),
              const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: "Ca: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: "${widget.item.shift?.name??""} (${widget.item.fromTime??"n.a"} - ${widget.item.toTime??"n.a"})",style: const TextStyle(color: AppColor.jadeColor,fontSize: 14,fontWeight: FontWeight.bold)),
                  ]
                )
              ),
              const SizedBox(height: 2,),
              RichText(
                text: TextSpan(
                  text: "Nơi làm việc: ",
                  style: const TextStyle(color: AppColor.darkText,fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(text: "${widget.item.workPlace?.name??""}",style: const TextStyle(color: AppColor.darkText,fontSize: 14,fontWeight: FontWeight.bold)),
                  ]
                )
              ),
              const SizedBox(height: 2,),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget.item.date?.sD??"n.a",style: const TextStyle(
                color: AppColor.grey,fontSize: 12, fontStyle: FontStyle.italic
              ),
            )
          ],
        ),
      ) 
    ],
  );}
}