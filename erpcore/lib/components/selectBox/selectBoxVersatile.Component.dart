import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/components/buttons/iconButton.Component.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/components/loading/loading.component.dart';

class SelectBoxVersatileComponent extends StatefulWidget {
  const SelectBoxVersatileComponent({super.key,this.label,this.placeholder="Chọn giá trị",this.selectedItem,this.listData,this.asyncListData,this.displayType=false,this.enable=true,this.isMultipleSeleted=false,this.listSelectedItem,this.onChanged,this.onChangedMultiple,this.onFind
    ,this.paging,this.isRemove = false, this.isReload = false
  });
  final String? label;
  final String placeholder;
  //final TextEditingController searchController;
  final PrCodeName? selectedItem;
  final List<PrCodeName>? listSelectedItem;
  final Function(String)? onFind;
  final List<PrCodeName>? listData;
  final Function(String,int,int)? asyncListData;
  final Function(PrCodeName)? onChanged;
  final Function(List<PrCodeName>)? onChangedMultiple;
  final bool enable;
  final bool displayType;
  final bool isMultipleSeleted;
  final PaginationInfoModel? paging;
  final bool? isRemove;
  final bool isReload;
  @override
  State<SelectBoxVersatileComponent> createState() => _SelectBoxVersatileComponentState();
}

class _SelectBoxVersatileComponentState extends State<SelectBoxVersatileComponent> {
  final TextEditingController txtSearchController = TextEditingController();
  final TextEditingController txtResultController = TextEditingController();
  ScrollController scrollController = ScrollController();
  PaginationInfoModel pageInfo = PaginationInfoModel();
  bool isLoading = false;
  late Size size;
  Color? backgroundColor;
  List<PrCodeName> listSelectDataHandle = List<PrCodeName>.empty(growable: true);
  StateSetter? childSetstates;
  double beforeOffset =0.0;
  bool initDialog = false;
  @override
  void initState() {
    super.initState();
    if(widget.paging != null){
      pageInfo=widget.paging!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_){
      
    });
    scrollController.addListener(() async{
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          beforeOffset = scrollController.offset;
          handleNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void handleNextPage(){
    try{
      if(((pageInfo.page! < pageInfo.totalPage!) && !isLoading)){
        if(mounted && childSetstates != null){
          childSetstates!((){
            isLoading=true;
          });
        }
        widget.asyncListData!(txtSearchController.text,(pageInfo.page??0)+1,pageInfo.pageSize??50).then((response){
          if(mounted && childSetstates != null){
            childSetstates!((){
              isLoading=false;
            });
          }
          if(response.statusCode == 0 && mounted && childSetstates != null){
            childSetstates!((){
              isLoading=false;
              pageInfo.page = (pageInfo.page)! +1;
              listSelectDataHandle.addAll(response.data);
            });
            scrollToBeforeOffset();
          }
        });
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleNextPage");
    }
  }

  void scrollToBeforeOffset() {
    if (scrollController.hasClients) {
      scrollController.animateTo(beforeOffset, duration:const Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(const Duration(milliseconds: 400), () => scrollToBeforeOffset());
    }
 }
 
  void onSelectItem(PrCodeName item,{bool isSelected = false}){
    if(widget.isMultipleSeleted){
      if(isSelected){
        (widget.listSelectedItem??[]).removeWhere((element) => element.code == item.code);
      }
      else{
        widget.listSelectedItem?.add(item);
      }
      if(widget.onChangedMultiple != null){
        widget.onChangedMultiple!(widget.listSelectedItem??[]);
      }
      if(mounted && childSetstates != null){
        childSetstates!((){});
      }
    }
    else{
      // widget.selectedItem?.code = item.code;
      // widget.selectedItem?.name = item.name;
      // widget.selectedItem?.codeDisplay = item.codeDisplay;
      // widget.selectedItem?.value = item.value;
      // widget.selectedItem?.keyword = item.keyword;
      if(widget.onChanged != null){
        widget.onChanged!(PrCodeName(code: item.code,name: item.name,value:item.value,value2: item.value2,value3: item.value3,keyword: item.keyword));
      }
      if(mounted){
        setState(() {});
      }
      Navigator.pop(context);
    }
    
  }

  String getcustomPrCodeNameDisplay(PrCodeName? item){
    String result ="";
    try{
      if(!widget.displayType && item?.codeDisplay != null && (item?.codeDisplay)!.isNotEmpty){
        result = item?.codeDisplay??"";
      }
      else{
        result = item?.name??"";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getcustomPrCodeNameDisplay SelectBoxVersatileComponent");
    }
    return result;
  }

  String getCustomPopupTypeDisplay(PrCodeName? item){
    String result ="";
    try{
      if(widget.displayType && item?.codeDisplay != null && (item?.codeDisplay)!.isNotEmpty){
        result = item?.codeDisplay??"";
      }
      else if(!widget.displayType && item?.code != null && (item?.code)!.isNotEmpty){
        result = item?.code??"";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getCustomPopupTypeDisplay selectBox.Component");
    }
    return result;
  }

  bool fillterOffline(PrCodeName item, String keyword){
    bool result = true;
    String keywordTemp = removeDiacritics(keyword).toLowerCase();
    if(keyword.isNotEmpty){
      if((item.keyword??"").contains(keywordTemp))
      {
        result = true;
      }
      else{
        result = false;
      }
    }
    return result;
  }

  int getPageTotal(int recordTotal){
    int result = 1;
    double temp = recordTotal/(pageInfo.pageSize??1);
    if(temp > temp.toInt()){
      result = temp.toInt()+1;
    }
    return result;
  }

  Future<String> handleFillter({bool reLoad=true}) async{
    String result = "okie";
    if(widget.asyncListData == null){
      listSelectDataHandle = (widget.listData??[]).where((element) => fillterOffline(element,txtSearchController.text)).toList();
    }
    // fillter online
    else{
      if(!isLoading){
        if(mounted && childSetstates != null && reLoad){
          childSetstates!((){
            isLoading=true;
          });
        }
        else if(!reLoad){
          LoadingComponent.show();
        }
        ResponsesModel response = await widget.asyncListData!(txtSearchController.text,pageInfo.page??1,pageInfo.pageSize??50);
        if(mounted && childSetstates != null && reLoad){
          childSetstates!((){
            isLoading=false;
          });
        }
        else if(!reLoad){
          LoadingComponent.dismiss();
          if(childSetstates != null){
            childSetstates!((){
              isLoading=false;
            });
          }
        }
        if(response.statusCode == 0 && response.data is List<PrCodeName>){
          listSelectDataHandle = response.data;
          pageInfo.totalPage = getPageTotal(response.totalRecord??1);
          pageInfo.page=1;
        }
      }
    }
    if(mounted && childSetstates != null && reLoad){
      childSetstates!((){});
    }
    return result;
  }
  
  Future<void> onPressBoxResult() async{
    if(mounted){
      setState(() {
        backgroundColor = AppColor.grey.withOpacity(0.1);
      });
    }
    
    Future.delayed(const Duration(milliseconds: 50),() async{
      if(mounted){
        setState(() {
          backgroundColor = AppColor.whiteColor; //Theme.of(context).colorScheme.background;
        });
        if (widget.isReload == true) {
          initDialog = false;
        }
      }
      
      showDialog(context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (BuildContext context, _setState){
              childSetstates = _setState;
              if(!initDialog){
                initDialog = true;
                handleFillter(reLoad: true);
              }
              return Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      constraints: BoxConstraints(
                        minHeight: size.height*.6,
                        maxHeight: size.height*.7,
                        minWidth: size.width*.6,
                        maxWidth: size.width*.8
                      ),
                      decoration: const BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:const EdgeInsets.only(top: 5,left: 10,right: 10),
                            child: TextInputComponent(
                              heightBox: 45,
                              title: "Tìm kiếm", 
                              controller: txtSearchController,
                              icon: const Icon(Icons.search),
                              onFieldSubmitted: (String v){
                                handleFillter();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment:  widget.isRemove==false?MainAxisAlignment.end:MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: widget.isRemove==true,
                                  child: GestureDetector(
                                    onTap: (){
                                      if(!widget.isMultipleSeleted && widget.onChanged != null){
                                        widget.onChanged!(PrCodeName());
                                        Navigator.pop(context);
                                      }
                                      if(widget.isMultipleSeleted && widget.onChangedMultiple != null){
                                        widget.onChangedMultiple!([]);
                                        (widget.listSelectedItem??[]).clear();
                                        if(mounted && childSetstates != null){
                                          childSetstates!((){});
                                          setState(() {});
                                        }
                                      }
                                    },
                                    child: const Text("Bỏ chọn",style: TextStyle(color: AppColor.brightRed)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("${pageInfo.page}/${pageInfo.totalPage}",style: const TextStyle(color: AppColor.grey,fontSize: 12,fontWeight: FontWeight.bold),)
                                ),
                              ],
                            ),
                          ),
                          
                          
                          const SizedBox(height: 5,),
                          Expanded(
                            child: (isLoading)? const Align(
                              alignment: Alignment.center,
                              child: SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: AppConfig.appColor,),)
                              ):_buildBoxSelectList()
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButtonComponent(icon: const Icon(Icons.cancel,color: AppColor.brightRed,), onPress: (){
                        Navigator.pop(context);
                      })
                    )
                  ],
                )
              );
            },
          );
        }
      );
      //handleFillter(reLoad: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.enable ? (){
          onPressBoxResult();
      } : null,
      child: _buildBoxSearchResult()
    );
  }

  Widget _buildBoxSearchResult(){
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.only(top: 10),
          constraints: const BoxConstraints(
            minHeight: 35,
          ),
          width: double.maxFinite,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            color: backgroundColor?? AppColor.whiteColor,
            borderRadius: const BorderRadius.all(Radius.circular(10.0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 5,),
              Expanded(child: _buildBoxResult()),
              const SizedBox(width: 5,),
              const Icon(Icons.arrow_drop_down_outlined,)
            ],
          ),
        ),
        Visibility(
          visible: widget.label != null && widget.label!.isNotEmpty,
          child: Positioned(
            left: 15,
            top: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 5,right: 5),
              color:  AppColor.whiteColor,
              child: Text(widget.label??"",
                style:const  TextStyle(color: AppColor.grey, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxResult(){
    Widget result = Text(widget.placeholder,style: const TextStyle(color: AppColor.nearlyBlack,fontSize: 14),);
    try{
      if(widget.listSelectedItem != null && widget.listSelectedItem!.isNotEmpty){
        result = Wrap(
          spacing: 4,
          runSpacing: 3,
          children: widget.listSelectedItem!.map<Widget>((e){
            return _buildItemResult(e,isMultipleSeleted: true);
          }).toList(),
        );
      }
      else if(!PrCodeName.isEmpty(widget.selectedItem)){
        result = _buildItemResult(widget.selectedItem!);
      }
    } 
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "_buildBoxResult");
    }
    return result;
  }

  Widget _buildItemResult(PrCodeName item,{bool isMultipleSeleted = false}){
    return Container(
      padding: isMultipleSeleted? const EdgeInsets.symmetric(horizontal: 5):EdgeInsets.zero,
      decoration: isMultipleSeleted? const BoxDecoration(
        color: AppColor.aqua,
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ):null,
      child: Text(getcustomPrCodeNameDisplay(item),style: TextStyle(color: isMultipleSeleted?AppColor.whiteColor:AppColor.nearlyBlack,fontSize: 14),)
    );
  }

  Widget customPopupPrCodeNameItemBuilder(PrCodeName item, bool isSelected) 
  {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            onSelectItem(item,isSelected: isSelected);
          },
          child: buildItemDisplay(item,isSelected: isSelected)
        ),
        const Divider()
      ]
    );
  }

  Widget buildItemDisplay(PrCodeName item,{bool isSelected = false}){
    String subData = getCustomPopupTypeDisplay(item);
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name??"",style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
              Visibility(
                visible: subData.isNotEmpty,
                child: Text(subData,style: const TextStyle(color: AppColor.laSalleGreen,fontStyle: FontStyle.italic,fontSize: 10),),
              )
            ],
          ),),
          if(widget.isMultipleSeleted)
          Icon(isSelected?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined,color:isSelected?Colors.red:null,),
        ],
      ),
    );
  }

  Widget _buildBoxSelectList(){
    Widget result = const Align(alignment: Alignment.center,child: Text("Không có dữ liệu"));  
    if(listSelectDataHandle.isNotEmpty){
      result = Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          controller: scrollController,
          shrinkWrap: true,
          children: listSelectDataHandle.map<Widget>((e) => customPopupPrCodeNameItemBuilder(e,isMultipleCheck(e))).toList()
        )
      );
    }
    return result;
  }

  bool isMultipleCheck(PrCodeName item){
    bool result = false;
    try{
      if(widget.isMultipleSeleted && !PrCodeName.isEmpty(item)){
        var index = (widget.listSelectedItem??[]).indexWhere((element) => element.code == item.code);
        if(index>-1){
          result = true;
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "isMultipleCheck");
    }
    return result;
  }
}