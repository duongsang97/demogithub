import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/homeFunctionItem.Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoutesMenuComponent extends StatefulWidget {
  const RoutesMenuComponent({super.key, required this.listMenu, this.onPressRoutes});

  final List<HomeFunctionItemModel> listMenu;
  final Function(HomeFunctionItemModel)? onPressRoutes;
  @override
  State<RoutesMenuComponent> createState() => _RoutesMenuComponentState();
}

class _RoutesMenuComponentState extends State<RoutesMenuComponent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: 130,
      padding: const EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
        bottom: 2,
      ),
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      child: _buildHeader(),
    );
  }

  Widget _buildHeader(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Chức năng",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            GestureDetector(
              child: const Icon(Icons.cancel,color: Colors.red,),
              onTap: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
        const Divider(color: Colors.black,thickness: 0.5,),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.listMenu.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                alignment: Alignment.center,
                width: 80,
                child:  _buildItemDrawer(widget.listMenu[index].name ?? "",
                iconM: widget.listMenu[index].assetImage ?? "",
                  callback: () async{
                    if (widget.onPressRoutes != null) {
                      widget.onPressRoutes!(widget.listMenu[index]);
                    }
                  }
                )
              );
            }  
          ),
        ),
      ],
    );
  }
}

 


Widget _buildItemDrawer(String label,{VoidCallback? callback, String iconM = ""}){
    Icon icon = const Icon(Icons.cloud_sync_outlined,size: 18,color: AppColor.grey,);
    return GestureDetector(
      onTap: (){
        if(callback != null){
          callback();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 5,top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconM.isNotEmpty ? Image.asset(iconM, width: 24, height: 24) : icon,
            const SizedBox(height: 2,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(
                  color: AppColor.grey,fontSize: 11
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }