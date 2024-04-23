import 'package:erpcore/components/boxs/dynamicBoxOffset.component.dart';
import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/erpCore.dart';
import 'package:erpcore/models/apps/homeFunctionItem.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/localStorage/permission.dbLocal.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:erpcore/components/boxs/RoutesMenu.Component.dart';

class AppBarTabComponent extends StatefulWidget implements PreferredSizeWidget{
  const AppBarTabComponent({super.key,this.height = 50,this.actionSearch,this.txtSeachController,this.title,this.titleText,this.onBack, this.appBarTitleSub,
    this.tabs,this.pagingInfo,this.tabSelected,this.tabOnChange,this.actionWidget, this.isRoute = false,
  });
  final VoidCallback? onBack;
  final double height;
  final Function(String)? actionSearch;
  final TextEditingController? txtSeachController;
  final Widget? title;
  final String? titleText;
  final List<PrCodeName>? tabs;
  final PaginationInfoModel? pagingInfo;
  final PrCodeName? tabSelected;
  final Function(PrCodeName)? tabOnChange;
  final Widget? actionWidget;
  final bool isRoute;
  final Widget? appBarTitleSub;
  
  @override
  Size get preferredSize => Size.fromHeight(height);
  @override
  State<AppBarTabComponent> createState() => _AppBarTabComponentState();
}

class _AppBarTabComponentState extends State<AppBarTabComponent> {
  late Size size;
  late List<HomeFunctionItemModel> listMenu = List.empty(growable: true);
  bool isSearchShow = false;
  String routeTitle = "";
  String colorText = "";

  Widget get title => getTitle();
   // false = nếu tabs chứ đủ trong màn hình, ngược lại true;
  bool get tabScrollType{
    bool result = true;
    try{
      double totalTitleSize = 0.0;
      if(widget.tabs != null){
        for(var item in widget.tabs!){
          totalTitleSize+=getItemSize(item)+50; // 50 là kích thước cộng thêm và padding thực tế
        }
      }
      if(totalTitleSize <= (size.width)){
        result = false;
      }

    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "tabScrollType");
    }
    
    return result;
  }


  Widget getTitle(){
    if(widget.title != null){
      return widget.title!;
    }
    else{
      return Container(
        //height: 50,
        alignment: Alignment.centerLeft,
        child: Text(widget.titleText??"",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: colorText.isNotEmpty ? HexColor.fromHex(colorText) : AppColor.bluePen),),
      );
    }
  }

  @override
  void initState() {
    if (widget.isRoute == true) {
      handleFnHome();
    }
    if(widget.tabs != null){
      for(var item in widget.tabs!){
        item.key = GlobalKey<State>(debugLabel: item.code??generateKeyCode());
      }
    }
    colorText = Get.find<AppController>().colorTextColor;
    super.initState();
  }

  double getItemSize(PrCodeName tab) {
    double result = 50;
    try{
      final key = (tab.key as GlobalKey<State>);
      final context = key.currentContext ;
      final renderBox = context?.findRenderObject();
      if (renderBox is RenderBox) {
        final size = renderBox.size;
        result = size.width;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getItemSize AppBarTabComponent");
    }
    return result;
  }

  void handleFnHome() async {
    PermissionDBLocal permissionDBLocal = PermissionDBLocal();
    listMenu = List.empty(growable: true);
    var listPer = await permissionDBLocal.findAllPermission();
    if (listPer.isNotEmpty) {
      var listTemp = ErpCore.getFunctionByPer(listPer);
      var routeCurrent = PreferenceUtility.getString(AppKey.routesKey);
      for (var item in listTemp) {
        if (item.code == routeCurrent) {
          routeTitle = item.name ?? "";
        } else {
          listMenu.add(item);
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void onPressRoutes (HomeFunctionItemModel item) {
    try {
      PreferenceUtility.saveString(AppKey.routesKey, item.code);
      LoadingComponent.show();
      Get.back();
      Get.back();
      Future.delayed(const Duration(milliseconds: 700),(){
        Get.toNamed(item.routerName);
      });
      LoadingComponent.dismiss();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onPressRoutes AppBarTabComponent");
    }
  }

  bool getSelectedStatus(PrCodeName tab){
    bool result = false;
    try{
      if(widget.tabSelected != null && tab.code == (widget.tabSelected!.code??"-1")){
        result= true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex, func: "getSelectedStatus HeaderElement");
    }
    return result;
  }
  
  @override
  Widget build(BuildContext context) {
    size= MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      //height: widget.height+(MediaQuery.paddingOf(context).top+10),
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top+10,
      ),
      decoration:const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/background/header_erp_background.png")
        )
      ),
      child: Column(
        mainAxisAlignment: (widget.tabs != null && widget.tabs!.isNotEmpty)?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderAction(),
          if(widget.tabs != null && widget.tabs!.length >1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildTabHeader(),
          )
        ],
      ),
    );
  }

  Widget routeBox() {
    Widget result;
    if (listMenu.isEmpty || !widget.isRoute) {
      result = title;
    } else {
      result = Container(
        margin: const EdgeInsets.only(right: 10.0),
        width: size.width,
        child: DynamicPopupMenuComponent(
          isCenter: true,
          boxDialog: RoutesMenuComponent(listMenu: listMenu, onPressRoutes: (item ){
            onPressRoutes(item);
          }),
          child: Row(
            children: [
              Icon(Icons.arrow_drop_down ,color: colorText.isNotEmpty ? HexColor.fromHex(colorText) : AppColor.bluePen,size: 26,),
              Expanded(child: title),
            ],
          ),
        ),
      );
    }
    return result;
  }

  Widget _buildHeaderAction(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    if(widget.onBack != null){
                      widget.onBack!();
                    }
                    else{
                      Get.back();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.arrow_back_ios,size: 25,color: colorText.isNotEmpty ? HexColor.fromHex(colorText) : AppColor.bluePen),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: !isSearchShow ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: routeBox()),
                      if (widget.appBarTitleSub != null) widget.appBarTitleSub!
                    ],
                  ): TextField(
                  controller: widget.txtSeachController,
                  onChanged: (value){
                    if (widget.actionSearch != null) {
                      widget.actionSearch!(value);
                    }
                  },
                  style: const TextStyle(color: AppColor.bluePen,fontSize: 14),
                    cursorColor: AppColor.bluePen,
                    decoration: const InputDecoration(
                      isDense:true,
                      border: InputBorder.none,
                      errorBorder:  InputBorder.none,
                      enabledBorder:  InputBorder.none,
                      focusedBorder:  InputBorder.none,
                      disabledBorder:  InputBorder.none,
                      labelStyle: TextStyle(fontSize: 13,color: AppColor.grey,),
                      contentPadding: EdgeInsets.only(left: 10,right: 5),
                      hintText: "Nhập từ khóa...",
                      hintStyle: TextStyle(color: AppColor.bluePen,fontSize: 13)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: [
              if(widget.txtSeachController != null)
              GestureDetector(
                onTap: (){
                  if(mounted && widget.txtSeachController != null){
                    setState(() {
                      isSearchShow = !isSearchShow;
                      widget.txtSeachController?.clear();
                      if (widget.actionSearch != null) {
                        widget.actionSearch!("");
                      }
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child:  Icon(isSearchShow ? Icons.search_off : Icons.search,size: 28,color: isSearchShow?AppColor.bluePen:colorText.isNotEmpty ? HexColor.fromHex(colorText) : AppColor.bluePen,),
                ),
              ),
              if(widget.actionWidget != null && !isSearchShow)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: widget.actionWidget!,
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabHeader(){
    Widget widgetContent = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.tabs!.length,
      shrinkWrap: true,
      itemBuilder: (context,index){
        var e = widget.tabs![index];
        e.key ??=GlobalKey<State>();
        return  _buildTabItem(e);
      }
    );
    if(!tabScrollType){
      widgetContent = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.tabs!.map<Widget>((e){
          e.key ??=GlobalKey<State>();
          return _buildTabItem(e);
        }).toList()
      );
    }
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          SizedBox(
            height: 36,
            child: widgetContent
          ),
          Container(
              height: 3,
              decoration: BoxDecoration(
                color: AppColor.grey.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabItem(PrCodeName tab){
    return GestureDetector(
      //key: tab.key,
      onTap: (){
        getItemSize(tab);
        if(widget.tabOnChange != null){
          widget.tabOnChange!(tab);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tab.name??"",
                        key:tab.key,
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: getSelectedStatus(tab)?AppColor.grey:AppColor.grey.withOpacity(0.5),
                          fontWeight: getSelectedStatus(tab)?FontWeight.bold:FontWeight.normal,
                          fontSize: getSelectedStatus(tab)?14:12
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Visibility(
                          visible: widget.pagingInfo != null && tab.code == widget.tabSelected?.code,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: buildPageInfo,
                          )
                        ),
                      )
                    ],
                  )
                ),
                AnimatedContainer(
                  //margin: const EdgeInsets.symmetric(horizontal: 5),
                  duration: const Duration(milliseconds: 400),
                  height: getSelectedStatus(tab)?3:2,
                  width: getItemSize(tab)+40,
                  decoration: BoxDecoration(
                    color: getSelectedStatus(tab)?AppColor.grey:null,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))
                  ),
                )
              ],
            ),
            Visibility(
              visible: tab.value4 != null && tab.value4 != null && tab.value4 > 0,
              child: Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: AppColor.brightRed,
                  ),
                  child: Text(tab.value4.toString(), style: const TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 9),)
                ),
              ),
            ), 
          ],
        ),
      ),
    );
  }
  Widget get buildPageInfo{
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        color: AppColor.purpleHeart,
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      child: Text(((widget.pagingInfo != null?widget.pagingInfo!.pageDisplay:"")),style: const TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold,fontSize: 10),),
    );
  }
}