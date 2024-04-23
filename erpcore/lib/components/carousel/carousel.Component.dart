import 'package:carousel_slider/carousel_slider.dart';
import 'package:erpcore/models/apps/carouselItem.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

import 'itemCarousel.Component.dart';

class CarouselComponent extends StatefulWidget {
  const CarouselComponent({ Key? key,this.onPageChanged,@required this.listCarousel}) : super(key: key);
  final Function(int, CarouselPageChangedReason)? onPageChanged;
  final List<CarouselItemModel> ?listCarousel;
  @override
  _CarouselComponentState createState() => _CarouselComponentState();
}

class _CarouselComponentState extends State<CarouselComponent> {
  late Size size;
  List<bool> listPage = List<bool>.empty(growable: true);

  @override
  void initState() {
    
    super.initState();
    handlePage();
  }

  void handleChangePage(int page)
  {
    for(int i =0 ;i<listPage.length;i++){
      if(listPage[i] == true){
        setState(() {
          listPage[i]=false;
        });
      }
    }
    try{
      listPage[page] = true;
      setState(() {});
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleChangePage carousel.Component");
    }
  }

  void handlePage()
  {
    
    listPage.clear();
    for(int i=0;i<(widget.listCarousel??[]).length;i++){
      if(i==0){
        listPage.add(true);
      }
      else{
        listPage.add(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: (widget.listCarousel??[]).length, 
          itemBuilder: (BuildContext context, int inPage,int nextPage){
            return ItemCarouselComponent(
              carouselItem: widget.listCarousel![inPage],
            );
          }, 
          options: CarouselOptions(
            height: 150,
            //aspectRatio: 16/9,
            viewportFraction: 0.95,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            autoPlayAnimationDuration: const Duration(milliseconds: 2000),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged:(int indexPage,CarouselPageChangedReason v){
              handleChangePage(indexPage);
              if(widget.onPageChanged != null){
                widget.onPageChanged!(indexPage,v);
              }
            },
            scrollDirection: Axis.horizontal,
          )
        ),
        Positioned(
          bottom: 0,
          child:  _buildBoxPage()
        )
      ],
    );
  }

  Widget _buildBoxPage(){
    return SizedBox(
      //margin: EdgeInsets.only(top: ),
      width: size.width,
      height: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  (listPage.isNotEmpty)
          ?listPage.map<Widget>((e) => _buildNotePage(e)).toList()
          :[_buildNotePage(true)],
      ),
    );
  }

  Widget _buildNotePage(bool flag){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 3.0,
      width: 15.0,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: flag?Colors.white:Colors.grey,
        shape: BoxShape.rectangle,
        border: const Border.symmetric(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(6.0, 6.0),
            blurRadius: 5.0,
          ),
        ],
      ),
    );
  }
}