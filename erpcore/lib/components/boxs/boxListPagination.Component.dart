import 'package:erpcore/components/shimmerPage/shimmerList.Component.dart';
import 'package:flutter/material.dart';

import 'models/paginationInfo.Model.dart';

class BoxListPaginationComponent extends StatefulWidget{
  BoxListPaginationComponent({ Key? key,required this.child,this.isLoading=false,this.pageLoading=false,required this.onRefresh,required this.page,required this.onFetchData, this.onScroll}): super(key: key);
  final Widget child;
  final VoidCallback onRefresh;
  final Function onFetchData; // xử lý sự kiến cuộn trang
  final bool pageLoading;
  final bool isLoading;
  final PaginationInfoModel page;
  final Function(double)? onScroll;
  @override
  State<BoxListPaginationComponent> createState() => _BoxListPaginationComponentState();

}

class _BoxListPaginationComponentState extends State<BoxListPaginationComponent> {
  late ScrollController controller;
  late Size size;
  double appBarOpacity=0.0;
  double safePadding = 0.0;
  @override
  void initState() {
    controller = ScrollController();
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
    if (widget.onScroll != null) {
      widget.onScroll!(controller.offset);
    }
  }

  void getOpacityFromOffset(){
    if(controller.offset >= 0 && controller.offset <=150){
      setState(() {
        appBarOpacity = (controller.offset/150);
      });
    }

    // cuối trang
    if(controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange){
        if((widget.page.page! < widget.page.totalPage!) && !(widget.isLoading)){
        widget.page.page = (widget.page.page)! +1;
        widget.onFetchData();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    safePadding = MediaQuery.of(context).padding.top;
    return SizedBox(
        width: double.maxFinite,
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async{
              widget.page.page = 1;
              widget.onRefresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              child: Container(
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight:  Radius.circular(20.0)
                  ),
                ),
                child: _handleUI()
              ),
            ),
          ),
        )
      );
  }

   Widget _handleUI(){
    Widget result = const SizedBox();
    if(widget.pageLoading == false){
      result = widget.child;
    }
    else{
      return const ShimmerListComponent();
    }
    return result;
  }
}