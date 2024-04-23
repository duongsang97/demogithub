import 'package:erpcore/models/apps/itemMenuInfo.Model.dart';
import 'package:erp/src/screens/welcome/elements/itemListMenu.Element.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

class BoxListMenuElement extends StatefulWidget {
  @override
  _BoxListMenuElementState createState() => _BoxListMenuElementState();
}

class _BoxListMenuElementState extends State<BoxListMenuElement>
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
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: GridView.count(
      shrinkWrap: true, // use it
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisCount: 4,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      scrollDirection: Axis.vertical,
      //physics: NeverScrollableScrollPhysics(),
      children: [
       ItemListMenuElement(item: new ItemMenuInfoModel(sysCode: generateKeyCode(),nameDisplay: "ERP Login",icon: Icon(Icons.home,color: Colors.blue,size: 35,),navigation: "/login"),),
       ItemListMenuElement(item: new ItemMenuInfoModel(sysCode: generateKeyCode(),nameDisplay: "Activation",icon: Icon(Icons.agriculture_rounded,color: Colors.blue,size: 35,),navigation: "/activation/login"),),
       ItemListMenuElement(item: new ItemMenuInfoModel(sysCode: generateKeyCode(),nameDisplay: "Hỗ trợ",icon: Icon(Icons.support,color: Colors.blue,size: 35,)),),
       ItemListMenuElement(item: new ItemMenuInfoModel(sysCode: generateKeyCode(),nameDisplay: "Thông tin",icon: Icon(Icons.info,color: Colors.blue,size: 35,)),),
      ],
    ),
    );
  }
}