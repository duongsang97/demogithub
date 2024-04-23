
import 'package:erpcore/utility/app.Utility.dart';
import 'package:flutter/material.dart';

class AppColor extends Color {
  static const Color brightBlue = Color(0xFF0165FC);
  static const Color jadeColor = Color(0xFF00A36C);
  static const Color brightRed = Color.fromRGBO(238, 75, 43, 1);
  static final Color grey700 = Colors.grey[700]!;
  static const Color azureColor = Color.fromRGBO(240, 255, 255, 1);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color orangeColor = Color(0xFFffa31a);
  static final Color artyClickOceanGreenColor = HexColor.fromHex("#00ff7f");
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160); 
  static const Color dark_grey = Color(0xFF313A44);
  static const Color violet = Color(0xFFC02ECC);
  static const Color yellow = Color.fromARGB(255, 241, 222, 13);
  static const Color bluePen = Color(0xFF000F55);
  static Color cottonSeed = const Color(0XFFBCBCBC);
  static Color cardinalRed = const Color(0xFFC41E3A);

  static const Color  darkGreyMonth = Color(0xFF566573);
  static const Color  greenMonth = Color(0xFF1E8449);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color aqua = Color(0xFF29d3e3);
  static const Color zirconColor = Color(0xFFF4F9FF);
  static const Color linkWaterColor = Color(0xFFD8E6F8);
  static const Color purpleHeart = Color(0xFF6441A4);
  static const Color oldLaceMars = Color(0XFFfaf5e6);
  static const Color purpleIris = Color(0xFF5e318c); // abbott pediasure
  static const Color laSalleGreen = Color(0xFF007F2D); // heineken
  static const Color jtiGreen = Color(0xFF00AB5F); // jti
  static const Color richElectricBlue = Color(0xFF007F2D); // abbott
  static const Color marsDeer = Color(0xFFC67B5C); // mars
  static const Color spiralColor = Color(0xFFda3c4c); // Spiral
  static const Color acacyColor = Color(0xFF268cf2); // Acacy
  static const Color pernodColor = Color(0xFF002957); // 002957

  AppColor(int value) : super(value);
}

class DesignCourseAppTheme {
  DesignCourseAppTheme._();

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText1: body2,
    bodyText2: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: AppColor.darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: AppColor.darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: AppColor.darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: AppColor.darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: AppColor.darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: AppColor.darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: AppColor.lightText, // was lightText
  );
}