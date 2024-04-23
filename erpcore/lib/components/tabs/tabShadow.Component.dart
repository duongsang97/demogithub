import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class TabShadowComponent extends StatefulWidget {
  const TabShadowComponent({super.key,this.currentIndex=0,this.childrend,required this.tabsName,required this.onChangeTab,this.pageController});
  final int currentIndex;
  final List<String> tabsName;
  final List<Widget>? childrend;
  final Function(int) onChangeTab;
  final PageController? pageController;
  @override
  State<TabShadowComponent> createState() => _TabShadowComponentState();
}

class _TabShadowComponentState extends State<TabShadowComponent> with AutomaticKeepAliveClientMixin<TabShadowComponent>{
  late Size size;
  PageController pageController = PageController();
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5,),
        Align(
          alignment: Alignment.center,
          child: _buildTabHeader(),
        ),
        const SizedBox(height: 5,),
        if(widget.childrend != null && widget.childrend!.isNotEmpty)
          Expanded(
            child:  widget.childrend!.elementAt(widget.currentIndex)
          )
      ],
    );
  }

  Widget _buildTabHeader(){
    return Container(
      width: size.width*.9,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      decoration: const BoxDecoration(
        color: AppColor.linkWaterColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.tabsName.asMap().map((i, element)=>MapEntry(i,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _buildTabItem(i,element),
            )
          )).values.toList()
        )
      )
    );
  }

  Widget _buildTabItem(int index,String name){
    var boxDecoration  = const BoxDecoration();
    if(widget.currentIndex == index){
      boxDecoration = BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: (){
        widget.onChangeTab(index);
      },
      child: AnimatedContainer(
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: boxDecoration,
        child: Text(name),
      ),
    );
  }
}