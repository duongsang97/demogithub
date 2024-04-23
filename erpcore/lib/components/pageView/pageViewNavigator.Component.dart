// ignore_for_file: must_be_immutable

import 'package:erpcore/components/pageView/models/pageViewNavigator.Model.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageViewNavigatorComponent extends StatefulWidget {
  PageViewNavigatorComponent({super.key,required this.currentIndex,required this.routerList,required this.onChangeTab});
  final int currentIndex;
  final Function(int) onChangeTab;
  List<PageViewNavigatorModel> routerList;
  @override
  State<PageViewNavigatorComponent> createState() => _PageViewNavigatorComponentState();
}

class _PageViewNavigatorComponentState extends State<PageViewNavigatorComponent> {
  late Size size;
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
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
        Expanded(
          child: widget.routerList.isNotEmpty?Navigator(
            key: _navigatorKey,
            initialRoute: widget.routerList[widget.currentIndex].router,
            onGenerateRoute: onGenerateRoute,
          ): const SizedBox(),
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
          children: widget.routerList.asMap().map((i, element)=>MapEntry(i,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _buildTabItem(i,element.name),
            )
          )).values.toList()
        )
      )
    );
  }

  Widget _buildTabItem(int index,String name){
    var _boxDecoration  = const BoxDecoration();
    if(widget.currentIndex == index){
      _boxDecoration = BoxDecoration(
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
        if(widget.currentIndex!=index && widget.routerList.isNotEmpty){
          _navigatorKey.currentState!.pushNamed(widget.routerList[index].router);
        }
      },
      child: AnimatedContainer(
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: _boxDecoration,
        child: Text(name),
      ),
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    var temp =  widget.routerList.firstWhere((element) => element.router == settings.name,orElse: ()=> widget.routerList.first);
    return GetPageRoute(
      transition: temp.transition,
      settings: settings,
      page: temp.page,
      binding: temp.binding,
    );
  }
}
