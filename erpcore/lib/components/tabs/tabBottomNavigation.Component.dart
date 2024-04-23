import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/logs/appLogs.Utility.dart';

class TabBottomComponent extends StatefulWidget {
  TabBottomComponent({super.key,required this.tabItems,required this.switchTap,this.hexColor,this.tabSelected,this.tabIndex=0});
  final List<ItemBottomModel> tabItems;
  final ItemBottomModel? tabSelected;
  final int? tabIndex;
  final Function(int) switchTap;
  final String? hexColor;
  @override
  State<TabBottomComponent> createState() => _TabBottomComponentState();
}

class _TabBottomComponentState extends State<TabBottomComponent> {
  @override
  void initState() {
    super.initState();
  }
  late Size size;
  // double getItemSize(PrCodeName tab) {
  //   double result = 50;
  //   try{
  //     final key = tab.value3;
  //     if(key != null){
  //       final context = key.currentContext;
  //       final renderBox = context.findRenderObject();
  //       if (renderBox is RenderBox) {
  //         final size = renderBox.size;
  //         result = size.width;
  //       }
  //     }
  //   }
  //   catch(ex){
  //     AppLogsUtils.instance.writeLogs(ex,func: "getItemSize AppBarTabComponent");
  //   }
  //   return result;
  // }
  int getSelectedId(ItemBottomModel item){
    int result =-1;
    result = widget.tabItems.indexWhere((element) => item.sysCode == element.sysCode);
    return result;
  }
  bool isSelected(ItemBottomModel item){
    bool result = false;
    if((widget.tabSelected != null && widget.tabSelected!.sysCode == item.sysCode) || widget.tabIndex == getSelectedId(item)){
      result = true;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    EdgeInsets padding = MediaQuery.paddingOf(context);
    if(widget.tabItems.isNotEmpty){
      return Container(
        width: size.width,
        height: 50+padding.bottom,
        padding: EdgeInsets.only(bottom: padding.bottom),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.grey,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBoxLine(),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.tabItems.map<Widget>((e) => buildNavigationItem(e)).toList()
              )
            )
          ],
        )
      );
    }
    else{
      return const SizedBox();
    }
  }

  Widget buildBoxLine(){
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          height: 2.5,
          width: size.width,
          decoration: BoxDecoration(
            color: AppColor.grey.withOpacity(0.2)
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.tabItems.map<Widget>((e) => buildItemLine(e)).toList()
        ),
      ],
    );
  }

  Widget buildItemLine(ItemBottomModel item){
     bool isSelect = isSelected(item);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 2.5,
      width: (size.width/widget.tabItems.length)*.6,
      decoration: BoxDecoration(
        color:isSelect?AppColor.acacyColor:null,
        borderRadius: const BorderRadius.all(Radius.circular(10.0))
      ),
    );
  }

  Widget buildNavigationItem(ItemBottomModel item){
    bool isSelect = isSelected(item);
    Widget icon = isSelect?item.activeIcon:item.inActiveIcon;
    return GestureDetector(
      onTap: (){
        widget.switchTap(getSelectedId(item));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5,),
          icon,
          Text(item.label??"",style: TextStyle(color: isSelect?AppColor.acacyColor:AppColor.grey,fontSize: isSelect?10:10,fontWeight: isSelect?FontWeight.bold:FontWeight.normal),),
        ],
      ),
    );
  }
}

class ItemBottomModel{
  String sysCode ="";
  late Widget activeIcon;
  late Widget inActiveIcon;
  String? label;

  ItemBottomModel({required this.activeIcon,required this.inActiveIcon,this.label,required this.sysCode});
}


