// import 'package:diacritic/diacritic.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
// import 'package:erpcore/components/buttons/iconButton.Component.dart';
// import 'package:erpcore/configs/appStyle.Config.dart';
// import 'package:erpcore/datas/iconApp.Data.dart';
// import 'package:erpcore/models/apps/prCodeName.Model.dart';
// import 'package:erpcore/models/apps/responses.Model.dart';
// import 'package:erpcore/utility/logs/appLogs.Utility.dart';
// import 'package:flutter/material.dart';

// class SelectBoxComponent extends StatefulWidget {
//   final String? label;
//   final double heigth;
//   final String hintBox;
//   //final TextEditingController searchController;
//   final PrCodeName? selectedItem;
//   final List<PrCodeName>? listSelectedItem;
//   final Function(String)? onFind;
//   final List<PrCodeName>? listData;
//   final Function(String,int)? asyncListData;
//   final Function(PrCodeName)? onChanged;
//   final Function(List<PrCodeName>)? onChangedMultiple;
//   final bool enable;
//   final bool displayType;
//   final bool isMultipleSeleted;
//   const SelectBoxComponent({ Key? key ,this.heigth =65,this.hintBox ="Chọn giá trị",this.selectedItem,this.onFind,this.listData,this.onChanged,this.enable=true,this.label,this.displayType=false,this.isMultipleSeleted = false,this.listSelectedItem,this.onChangedMultiple,this.asyncListData,}) : super(key: key);

//   @override
//   _SelectBoxComponentState createState() => _SelectBoxComponentState();
// }

// class _SelectBoxComponentState extends State<SelectBoxComponent> {
//   TextEditingController txtSearchController = TextEditingController();
//   ScrollController scrollController = ScrollController();
//   PaginationInfoModel pageInfo = PaginationInfoModel();
//   List<PrCodeName> listDataSelect = List<PrCodeName>.empty(growable: true);
//   bool isLoading = false;
//   bool fillterOffline(PrCodeName item, String keyword){
//     bool result = true;
//     String _keyword = removeDiacritics(keyword).toLowerCase();
//     if(keyword.isNotEmpty){
//       if(removeDiacritics((item.code??"").toLowerCase()).contains(_keyword) || removeDiacritics((item.name??"").toLowerCase()).contains(_keyword) || removeDiacritics((item.codeDisplay??"").toLowerCase()).contains(_keyword))
//       {
//         result = true;
//       }
//       else{
//         result = false;
//       }
//     }
//     return result;
//   }
//   String getCustomPopupTypeDisplay(PrCodeName? item){
//     String result ="";
//     try{
//       if(item?.codeDisplay != null && (item?.codeDisplay)!.isNotEmpty){
//         if(widget.displayType){
//           result = item?.codeDisplay??"";
//         } else {
//           result = item?.code??"";
//         }
//       }
//       else{
//         result = item?.code??"";
//       }
//     }
//     catch(ex){
//       AppLogsUtils.instance.writeLogs(ex,func: "getCustomPopupTypeDisplay selectBox.Component");
//     }
//     return result;
//   }
//   String getcustomPrCodeNameDisplay(PrCodeName? item){
//     String result ="";
//     try{
//       if(!widget.displayType && item?.codeDisplay != null && (item?.codeDisplay)!.isNotEmpty){
//         result = item?.codeDisplay??"";
//       }
//       else{
//         result = item?.name??"";
//       }
//     }
//     catch(ex){
//       AppLogsUtils.instance.writeLogs(ex,func: "getcustomPrCodeNameDisplay selectBox.Component");
//     }
//     return result;
//   }
  
//   int getPageTotal(int recordTotal){
//     int result = 1;
//     double _temp = recordTotal/(pageInfo.pageSize??1);
//     if(_temp > _temp.toInt()){
//       result = _temp.toInt()+1;
//     }
//     return result;
//   }

//  @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) 
//   {
//     return Container(
//       //height: 45,
//       child: !(widget.isMultipleSeleted)?_buildSingleChoose():_buildMultipleChoose(),
//     );
//   }

//   DropDownDecoratorProps getDownDecorator(){
//     return DropDownDecoratorProps(
//       baseStyle: TextStyle(fontSize: 14),
//       dropdownSearchDecoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 20),
//         enabled: widget.enable,
//         labelText: widget.label,
//         hintText: widget.hintBox,
//         //suffix: Icon(Icons.read_more),
//         labelStyle: TextStyle(fontSize: 14),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0),),
//           borderSide: BorderSide(color: AppColor.grey,width: 0.5,style: BorderStyle.solid)
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0),),
//           borderSide: BorderSide(color: AppColor.grey,width:0.5,style: BorderStyle.solid)
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0),),
//           borderSide: BorderSide(color: AppColor.grey,width:0.2,style: BorderStyle.solid)
//         ),
//       ),
//     );
//   }

//   TextFieldProps getPopupBoxSearch(){
//     return TextFieldProps(
//       contextMenuBuilder: (context, editableTextState){
//         return Container(
//           child: Text("123123"),
//         );
//       },
//       controller: txtSearchController,
//       decoration: InputDecoration(
//         labelText: "Tìm kiếm",
//         hintText: "Nhập từ khoá ...",
//         //helperText: "${pageInfo.page}/${pageInfo.totalPage}",
//         helperMaxLines: 1,
//         helperStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),
//         contentPadding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 20),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0),),
//           borderSide: BorderSide(color: AppColor.grey,width: 0.5,style: BorderStyle.solid)
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0),),
//           borderSide: BorderSide(color: AppColor.grey,width:0.5,style: BorderStyle.solid)
//         ),
//       ),
//     );
//   }

//   DialogProps getDialogProps(){
//     return DialogProps(
//       backgroundColor: AppColor.whiteColor,
//       insetPadding:EdgeInsets.symmetric(horizontal: 30,vertical: 24),
//     );
//   }
  


//   Widget _buildSingleChoose(){
//     return DropdownSearch<PrCodeName>(
//       enabled: widget.enable,
//       dropdownDecoratorProps: getDownDecorator(),
//       items: widget.listData??[],
//       filterFn: (item, filter){
//         bool result = false;
//         if(widget.listData != null){
//           result = fillterOffline(item,filter);
//         }
//         return result;
//       },
//       asyncItems: (String v) async{
//         try{
//           txtSearchController.text = v;
//           if(widget.asyncListData != null){
//             ResponsesModel response = await widget.asyncListData!(v,pageInfo.page??1);
//             if(response.statusCode == 0){
//               setState(() {
//                 listDataSelect = response.data;
//                 pageInfo.totalPage = getPageTotal(response.totalRecord??1);
//                 pageInfo.page=0;
//               });
//             }
//             else{
//               AppLogsUtils.instance.writeLogs(response.msg,func: "_buildSingleChoose asyncItems");
//             }
//           }
//         }
//         catch(ex){
//           AppLogsUtils.instance.writeLogs(ex,func: "_buildSingleChoose asyncItems");
//         }
//         return listDataSelect;
//       },
//       onChanged: (PrCodeName? v){
//         if(widget.onChanged != null){
//           widget.onChanged!(v??PrCodeName());
//         }
//       },
//       clearButtonProps: ClearButtonProps(
//         isVisible: (widget.enable && !PrCodeName.isEmpty(widget.selectedItem)),
//         icon: Icon(Icons.clear_outlined),
//         onPressed: (){
//           if(widget.onChanged != null){
//             widget.onChanged!(PrCodeName());
//           }
//         }
//       ),
//       dropdownBuilder: customPrCodeNameDropDown,
//       popupProps: PopupProps.dialog(
//         fit: FlexFit.tight,
//         showSearchBox:true,
//         isFilterOnline:true,
//         searchFieldProps: getPopupBoxSearch(),
//         itemBuilder:customPopupPrCodeNameItemBuilder,
//         dialogProps: getDialogProps(),
//         containerBuilder: (context, popupWidget){
//           return Container(
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: IconButtonComponent(icon: Icon(Icons.cancel,color: AppColor.brightRed,size: 30,), onPress: (){
//                     Navigator.pop(context);
//                   }),
//                 ),
//                 Expanded(child:popupWidget)
//               ],
//             )
//           );
//         },
//         scrollbarProps: ScrollbarProps(
//           notificationPredicate:(notification) {
//             if(notification.metrics.pixels == notification.metrics.maxScrollExtent && !isLoading){
//               if((pageInfo.page! < pageInfo.totalPage!)){
//                 isLoading= true;
//                 widget.asyncListData!(txtSearchController.text,pageInfo.page??1).then((ResponsesModel response){
//                   isLoading=false;
//                   if(response.statusCode == 0){
//                     setState(() {
//                       pageInfo.page = (pageInfo.page)! +1;
//                       listDataSelect = response.data;
//                       listDataSelect.clear();
//                     });
//                   }
//                 });
//               }
//               return false;
//             }
//             else{
//               return true;
//             }
//           },
//         ),
//       ),
//       selectedItem: widget.selectedItem,
//     );
//   }

//   Widget _buildMultipleChoose(){
//     return DropdownSearch<PrCodeName>.multiSelection(
//       enabled: widget.enable,
//       dropdownDecoratorProps: getDownDecorator(),
//       popupProps:  PopupPropsMultiSelection.dialog(
//         fit: FlexFit.tight,
//         showSearchBox:true,
//         searchFieldProps: getPopupBoxSearch(),
//         itemBuilder:customPopupPrCodeNameItemBuilder,
//         dialogProps: getDialogProps(),
//       ),
//       items: widget.listData??[],
//       filterFn: (item, filter){
//         bool result = false;
//         if(widget.listData != null){
//           result = fillterOffline(item,filter);
//         }
//         return result;
//       },
//       clearButtonProps: ClearButtonProps(
//         isVisible: (widget.enable && (widget.listSelectedItem??[]).isNotEmpty),
//         icon: Icon(Icons.clear_outlined),
//         onPressed: (){
//           if(widget.onChangedMultiple != null){
//             widget.onChangedMultiple!([]);
//           }
//         }
//       ),
//       asyncItems: (String v) async{
//         try{
//           if(widget.asyncListData != null && v.isNotEmpty){
//             ResponsesModel response = await widget.asyncListData!(v,pageInfo.page??1);
//             if(response.statusCode == 0){
//               listDataSelect = response.data;
//             }
//             else{
//               AppLogsUtils.instance.writeLogs(response.msg,func: "_buildSingleChoose asyncItems");
//             }
//           }
//         }
//         catch(ex){
//           AppLogsUtils.instance.writeLogs(ex,func: "_buildSingleChoose asyncItems");
//         }
        
//         return listDataSelect;
//       },
//       onChanged: widget.onChangedMultiple,
//     );
//   }

//   Widget customPrCodeNameDropDown(BuildContext context, PrCodeName? item) 
//   {
//     TextStyle txtStyle = TextStyle(color: AppColor.nearlyBlack,fontSize: 15);
//     return Container(
//       child: (item == null || PrCodeName.isEmpty(item))?Text(widget.hintBox.isNotEmpty?widget.hintBox:"Chọn giá trị",style: txtStyle,):Text(getcustomPrCodeNameDisplay(item),style: txtStyle,),
//     );
//   }

//   Widget customMultiplePrCodeNameDropDownDisplay(BuildContext context,List<PrCodeName> list){
//     return Container(
//       child: RichText(
//         text: TextSpan(
//           text: '',
//           style: DefaultTextStyle.of(context).style,
//           children: list.map<TextSpan>((e) =>  TextSpan(text: e.name! +", ", style: TextStyle(color: AppColor.grey)),).toList()
//         ),
//       )
//     );
//   }


//   Widget customPopupPrCodeNameItemBuilder(BuildContext context, PrCodeName item, bool isSelected) 
//   {
//     return Container(margin: EdgeInsets.symmetric(horizontal: 5),decoration: !isSelected? null
//       : BoxDecoration(
//           border: Border.all(color: Colors.black,width: 1),
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.white,
//         ),
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: EdgeInsets.symmetric(horizontal: 5),
//             selected: isSelected,
//             title: Text(item.name??"",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
//             subtitle: Text(getCustomPopupTypeDisplay(item),style: TextStyle(color: AppColor.laSalleGreen,fontStyle: FontStyle.italic,fontSize: 12),),
//           ),
//           Divider()
//         ],
//       )
//     );
//   }
// } 