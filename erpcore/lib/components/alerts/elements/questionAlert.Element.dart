import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
class QuestionAlertElement extends StatefulWidget {
  const QuestionAlertElement({ Key? key,this.flag = false}) : super(key: key);
  final bool flag;
  @override
  _QuestionAlertElementState createState() => _QuestionAlertElementState();
}

class _QuestionAlertElementState extends State<QuestionAlertElement> {
  late ConfettiController _controllerTopCenter;
  @override
  void initState() {
    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {
          Future.delayed(Duration(milliseconds: 200),(){
             if(widget.flag){
               setState(() {
                 _controllerTopCenter.play();
               });
             }
          })
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

  String getPathImage(bool isMobile){
    String result ="assets/images/phone/cauhoi_dapandung_phone.png";
    if(widget.flag){
      if(isMobile){
        result = "assets/images/phone/cauhoi_dapandung_phone.png";
      }
      else{
        result = "assets/images/ipad/cauhoi_dapandung_ipad.png";
      }
    }
    else{
      if(isMobile){
        result = "assets/images/phone/cauhoi_dapansai_phone.png";
      }
      else{
        result = "assets/images/ipad/cauhoi_dapansai_ipad.png";
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(getPathImage(useMobileLayout)),
              fit: BoxFit.contain,
            )
          ),child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

          height: size.height,
          width: size.width,
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
