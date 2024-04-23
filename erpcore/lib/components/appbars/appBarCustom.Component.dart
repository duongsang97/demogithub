import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

class CustomAppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final int? appbarType;
  final String? hexColor;
  CustomAppBarComponent({required this.child,this.height = kToolbarHeight,required this.borderRadius,this.appbarType = 1,this.hexColor});

  @override
  State<CustomAppBarComponent> createState() => _CustomAppBarComponentState();
  
  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarComponentState extends State<CustomAppBarComponent> {
  Size get preferredSize => Size.fromHeight(widget.height);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    Widget AppBarCustom(){
      return Container(
        height: preferredSize.height + topPadding,
        padding: EdgeInsets.only(top: topPadding),
        decoration: BoxDecoration(
          color: widget.hexColor!=null&&widget.hexColor!.isNotEmpty?HexColor.fromHex(widget.hexColor!):AppConfig.appColor,
          borderRadius: widget.borderRadius,
          image: AppConfig.appbarSky?DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/background/header_erp_background.png")):null
          ),
        alignment: Alignment.center,
        child: widget.child,
      );
    }
    Widget AppBarManagement(){
      return  Container(
        height: preferredSize.height + topPadding,
        child: Stack(
          children: [
            Column(
            children: [
              Container(
                height: preferredSize.height + topPadding,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppConfig.appColor,
                  image: AppConfig.appbarSky?DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/background/header_erp_background.png")):null
                ),
                child: widget.child,
              ),
            ]
          ),
          ],
        ),
      );
    }

    Widget result = SizedBox();
    if (widget.appbarType == 1) {
      result = AppBarCustom();
    } else if (widget.appbarType == 2) {
      result = AppBarManagement();
    }
    return result;
  }
}
