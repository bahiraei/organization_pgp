import 'package:flutter/material.dart';

class AppColor {
  static const int gradiantDarkColor = 0xff12144E;
  static const int gradiantLightColor = 0xff282DC4;
  static const int questionCounterColor = 0xffFFCC00;
  static const int nextQuestionColor = 0xff02E021;
  static const int previousQuestionColor = 0xffFF9200;
  static const int purpleColor = 0xffC100FF;
  static const int blue = 0xff0090FF;
  static const int redColor = 0xffFF0000;
  static const int competitionUserCount = 0xff09BFE2;
  static const int competitionQuestionCount = 0xff09E210;
  static const int greenColor = 0xff00e220;
  static const int lightBlueColor = 0xff00B3FF;

  static Gradient gradient1 = const LinearGradient(
    colors: [
      Color(0xffD9316E),
      Color(0xff7C0B86),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static List<Color> textGradientColor = [
    const Color(0xffD9316E),
    const Color(0xff7C0B86),
  ];

  static List<Color> textGradientColor2 = [
    const Color(0xff03499B),
    const Color(0xff0BF0FF),
  ];

  static List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 10,
      offset: const Offset(0, 4),
    )
  ];

  static List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 5,
      offset: const Offset(0, 2),
    )
  ];

  static List<BoxShadow> shadow4 = [
    const BoxShadow(
      color: Colors.black12,
      blurRadius: 2,
    )
  ];

  static List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.50),
      blurRadius: 5,
      offset: const Offset(0, 2),
    )
  ];
}
