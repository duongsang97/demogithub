import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/activations/dataImageAct.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoListViewAlertElement extends StatefulWidget {
  const PhotoListViewAlertElement({ Key? key,this.listImage,required this.currentIndex}) : super(key: key);
  final List<DataImageActModel>? listImage;
  final int currentIndex;
  @override
  _PhotoListViewAlertElementState createState() => _PhotoListViewAlertElementState();
}

class _PhotoListViewAlertElementState extends State<PhotoListViewAlertElement> {
  late PageController _pageController;
  late CarouselController controller;
  late int _currentIndex;
  late int _count;

  ImageProvider<Object> getImage(int index){
    late ImageProvider<Object> image;
    try{
      if(widget.listImage != null && widget.listImage!.isNotEmpty){
        if(widget.listImage![index].urlImage != null && widget.listImage![index].urlImage!.isNotEmpty){
          image = NetworkImage(widget.listImage![index].urlImage!);
        }
        else if(widget.listImage![index].assetsImage != null && widget.listImage![index].assetsImage!.isNotEmpty){
          image = FileImage(File(widget.listImage![index].assetsImage!));
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getFileImage photoListViewAlert.Element");
    }
    return image;
  }

  void getLengthImage(){
    try{
      if(widget.listImage != null && widget.listImage!.isNotEmpty){
         _count = widget.listImage?.length??0;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getLengthImage photoListViewAlert.Element");
    }
  }

  @override
  void initState(){
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    controller = CarouselController();
    getLengthImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildListPhotoView(),
        _buildIndicator(),
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,color: Colors.red,size: 30,),
            onPressed:(){
              Navigator.pop(context);
            }
          )
        )
      ],
    );
  }

  Widget _buildListPhotoView(){
    return PhotoViewGallery.builder(
      itemCount: _count,
      builder: (BuildContext context,int index){
        return PhotoViewGalleryPageOptions(
          imageProvider: getImage(index),
          // minScale: PhotoViewComputedScale.contained * .8,
          // maxScale: PhotoViewComputedScale.covered * 1.8
        );
      },
      enableRotation: true,
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: _pageController,
      loadingBuilder: (context, event){
        return const Center(child: CircularProgressIndicator(),);
      },
      onPageChanged: (int index) {
        setState(() {
          _currentIndex = index;
          controller.animateToPage(index);
        });
      },
    );
  }

  Widget _buildIndicator(){
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: CarouselSlider.builder(
        carouselController: controller,
        itemCount: _count,
        itemBuilder: (context, index, realIndex) {
          return _portfolioGalleryImage(
            image: getImage(index),
            onImageTap: (){
              _pageController.jumpToPage(index);
              controller.animateToPage(index);
            }
          );
        },
        options: CarouselOptions(
          height: 70,
          viewportFraction: .21,
          enlargeCenterPage: true,
          enableInfiniteScroll :false,
          initialPage: _currentIndex,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          
        )
      )
    );
  }

  Widget _portfolioGalleryImage({required ImageProvider<Object> image, required void Function() onImageTap}) {
    return Container(
      decoration:  BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.nearlyBlack.withOpacity(0.5),
            offset:const Offset(2, 2),
            spreadRadius: 2,
            blurRadius: 5
          )
        ],
        borderRadius: const BorderRadius.all(Radius.circular(5.0))
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            child: InkWell(onTap: onImageTap),
          ),
        ),
      ),
    );
  }

  
}