import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/utility/image.Utility.dart';
import '../alert.dart';

class LuckyDrawAlertElement extends StatefulWidget {
  const LuckyDrawAlertElement({ Key? key,required this.gift,required this.codeGroup,required this.funcGetCardbyCodeName}) : super(key: key);
  final PrCodeName gift;
  final String codeGroup;
  final Function(String, String) funcGetCardbyCodeName;
  @override
  _LuckyDrawAlertElementState createState() => _LuckyDrawAlertElementState();
}

class _LuckyDrawAlertElementState extends State<LuckyDrawAlertElement> {

  late ConfettiController _controllerTopCenter;
  @override
  void initState() {
    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_){
            Future.delayed(Duration(milliseconds: 200),(){
            setState(() {
              _controllerTopCenter.play();
            });
          });
          if(widget.gift.code == "AF03"){
            Future.delayed(Duration(milliseconds: 4000),(){
                Alert.dialogChooseCard(context,widget.codeGroup,widget.funcGetCardbyCodeName);
            });
          }
        });
  }
  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: ImageUtils.getURLImage( widget.gift.codeDisplay??""),
          imageBuilder: (context, imageProvider) => Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              )
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Text("ĐÓNG"),
                  ),
                )
              ],
            ),
          ),
          placeholder: (context, url) => Center(child: SizedBox(height: 40,width: 40,child: CircularProgressIndicator(),),),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerTopCenter,
              blastDirection: pi / 2,
              maxBlastForce: 5, // set a lower max blast force
              minBlastForce: 2, // set a lower min blast force
              emissionFrequency: 0.05,
              numberOfParticles: 50, // a lot of particles at once
              gravity: 0.2,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually sp
            ),
          ),
      ],
    );
  }
}

