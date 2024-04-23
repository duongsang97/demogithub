import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/appVersion.Model.dart';
import 'package:flutter/material.dart';

class VersionInfoElement extends StatefulWidget {
  const VersionInfoElement({ Key? key,this.appVersion}) : super(key: key);
  final AppVersionModel? appVersion;
  @override
  State<VersionInfoElement> createState() => _VersionInfoElementState();
}

class _VersionInfoElementState extends State<VersionInfoElement> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          _buildVersionName(),
          SizedBox(height: 10,),
          _buildVersionContent()
        ],
      ),
    );
  }

  Widget _buildVersionName(){
    return Container(
      padding: EdgeInsets.only(right: 10),
     
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width*.4,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              color: AppColor.jadeColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0)
              )
            ),
            child: Text("Phiên bản ${(widget.appVersion!=null)?widget.appVersion!.version:''}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.whiteColor),),
          ),
          Text("${widget.appVersion?.modifyDate?.sD}",style: TextStyle(fontSize: 14,fontStyle: FontStyle.italic))
        ],
      ),
    );
  }
  Widget _buildVersionContent(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text("${widget.appVersion?.note}"),
    );
  }
}