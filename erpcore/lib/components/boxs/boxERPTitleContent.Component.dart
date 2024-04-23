import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class BoxERPTitleContentComponent extends StatefulWidget {
  const BoxERPTitleContentComponent({ Key? key,this.child,this.isExtend=false,this.title="Chức năng",this.callback}) : super(key: key);
  final Widget? child;
  final String title;
  final bool isExtend;
  final VoidCallback? callback;
  @override
  State<BoxERPTitleContentComponent> createState() => _BoxERPTitleContentComponentState();
}

class _BoxERPTitleContentComponentState extends State<BoxERPTitleContentComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBoxTitle(),
          SizedBox(height: 2,),
          widget.child??const SizedBox()
        ],
      ),
    );
  }

  Widget _buildBoxTitle(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,style: TextStyle(color: AppColor.grey,fontSize: 15,fontWeight: FontWeight.bold)),
          Visibility(
            visible: widget.isExtend,
            child: GestureDetector(
              onTap: (){
                if(widget.callback != null){
                  widget.callback!();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(width: 0.5,color: AppColor.grey)
                ),
                child: Row(
                  children: [
                    Icon(Icons.apps,size: 16,color: AppColor.grey,),
                    SizedBox(width: 5,),
                    Text("Tất cả",style: TextStyle(fontSize: 12,color: AppColor.grey),)
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}