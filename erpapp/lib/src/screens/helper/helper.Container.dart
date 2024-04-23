import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/helper/helper.Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelperScreen extends GetWidget{
  final HelperController helperController = Get.find();
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage("assets/images/app_background.png"),
        //   fit: BoxFit.fill
        // )
        color: AppColor.whiteColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  expandedHeight: size.height*.2,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: const Text('BÁO CÁO SỰ CỐ', textScaleFactor: 0.6,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                    background: Image.asset('assets/images/background/header_erp_background.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: componentUpdateInfo("Hỗ trợ online","assets/images/icons/information.png",AppColor.aqua,
                          onPress: ()async{
                            helperController.sendEmail();
                          }
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: componentUpdateInfo("Sao lưu dữ liệu","assets/images/icons/information.png",AppColor.nearlyBlue,flag: false,
                          onPress: ()async{
                            helperController.openModalSelectDate();
                          }
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

   Widget componentUpdateInfo(String name,String assets,Color colors,{VoidCallback? onPress,bool flag =true}){
    return GestureDetector(
      onTap: (){
        if(onPress != null){
          onPress();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical:10,horizontal: 20),
        decoration: BoxDecoration(
          border: const Border.symmetric(),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: flag?[colors,Colors.white]:[Colors.white,colors]
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15.0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: flag?[
            Expanded(
              child: Text(name,textAlign: TextAlign.left,style: const TextStyle(
                color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold
              ),),
            ),
            const SizedBox(width:10),
            Image.asset(assets)
          ]:[
             Image.asset(assets),
            Expanded(
              child: Text(name,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}