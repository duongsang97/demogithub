import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxERPBodyComponent extends StatefulWidget {
  const BoxERPBodyComponent({ Key? key,this.imageHeader,this.child,this.title="",this.searchPlaceholder="Nhập từ khóa",
  this.searchObTab,this.listenScroll,this.rightWidget,this.headerHeight,this.showSearchBox=true,this.showBackIcon=true}): super(key: key);
  //final ScrollController controller;
  final String? imageHeader;
  final Widget? child;
  final String title;
  final String searchPlaceholder;
  final VoidCallback? searchObTab;
  final Function(String)? listenScroll;
  final Widget? rightWidget;
  final double? headerHeight;
  final bool showSearchBox;
  final bool showBackIcon;
  @override
  State<BoxERPBodyComponent> createState() => _BoxERPBodyComponentState();
}

class _BoxERPBodyComponentState extends State<BoxERPBodyComponent> {
  late ScrollController controller;
  late Size size;
  double appBarOpacity=0.0;
  double safePadding = 0.0;
  @override
  void initState() {
    controller = new ScrollController();
    controller.addListener(handleScrollPage);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleScrollPage(){
    getOpacityFromOffset();
  }

  void getOpacityFromOffset(){
    if(controller.offset >= 0 && controller.offset <=150){
      setState(() {
        appBarOpacity = (controller.offset/150);
      });
    }
    if(controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange){
      if(widget.listenScroll != null){
        widget.listenScroll!("end");
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    safePadding = MediaQuery.of(context).padding.top;
    double heightTemp =(size.height*.25);
    if(widget.headerHeight != null){
      heightTemp = widget.headerHeight!;
    }
    return Container(
      width: double.maxFinite,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          SingleChildScrollView(
            controller: this.controller,
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColor.brightBlue,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(widget.imageHeader??"assets/images/background/header_erp_background.png")
                        )
                      ),
                      height: heightTemp,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heightTemp-20,),
                    Container(
                      width: size.width,
                        //height: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight:  Radius.circular(20.0)
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.1),
                        //     spreadRadius: 10,
                        //     blurRadius: 7,
                        //     offset: Offset(10, 0), // changes position of shadow
                        //   ),
                        // ]
                      ),
                      child: widget.child??SizedBox()
                    )
                  ],
                ),
                Visibility(
                  visible: widget.showSearchBox,
                  child: Positioned(
                    top: (heightTemp)-40,
                    left: (size.width*.25)/2,
                    child: _buildBoxSearch()
                  ),
                )
              ],
            ),
          ),
          Positioned(
            child: _buildAppbar()
          )
        ],
      )
    );
  }

  Widget _buildBoxSearch(){
    return GestureDetector(
      onTap: widget.searchObTab,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
        width: size.width*.75,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.grey,width: 0.2),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 10), // changes position of shadow
            ),
          ]
        ),
        height: 40,
        child: Row(
          children: [
            Icon(Icons.search,color: AppColor.grey.withOpacity(0.6),),
            SizedBox(width: 10,),
            Text(widget.searchPlaceholder,style: TextStyle(color: AppColor.grey),)
          ],
        ),
      ),
    );
  }
  Widget _buildAppbar(){
    return Container(
      width: size.width,
      height: safePadding+40,
      padding: EdgeInsets.only(top: safePadding,right: 10,left: 10),
      decoration: BoxDecoration(
        color: AppColor.brightBlue.withOpacity(appBarOpacity),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: widget.showBackIcon,
            child: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child:  Icon(Icons.arrow_back_ios,color: Colors.white,size: 25,),
              ),
            ),
          ),
          Text(widget.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white.withOpacity(appBarOpacity)),),
          Visibility(
            child: widget.rightWidget??SizedBox()
          )
        ],
      ),
    );
  }
}