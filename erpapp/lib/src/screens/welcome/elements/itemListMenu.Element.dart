import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/models/apps/itemMenuInfo.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class ItemListMenuElement extends StatefulWidget {
  ItemMenuInfoModel item = new ItemMenuInfoModel(sysCode: generateKeyCode());
  ItemListMenuElement({Key? key,required this.item}):super(key: key);

  @override
  _ItemListMenuElementState createState() => _ItemListMenuElementState();
}

class _ItemListMenuElementState extends State<ItemListMenuElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      child: GestureDetector(
        onLongPress: (){
          Alert.dialogShow("Thông báo","Đừng dữ quá lâu nhé @_@");
        },
        onTap: (){
          if(widget.item.navigation != null && (widget.item.navigation)!.isNotEmpty){
            try{
              //navService.pushNamed(widget.item.navigation);
            }
            catch(ex){
              Alert.dialogShow("Thông báo",ex.toString());
              AppLogsUtils.instance.writeLogs(ex,func: "ItemListMenuElement itemListMenu.Element");
            }
          }
          else{
            Alert.dialogShow("Thông báo","Chưa cấu hình điều hướng");
          }
          
        },
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.item.icon??SizedBox(),
            Text(widget.item.nameDisplay??"",style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
      )
    );
  }
}