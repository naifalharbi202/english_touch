import 'package:flutter/material.dart';

class Dimensions {
  static double size(double size, context) {
    final screenHeight =
        MediaQuery.of(context).size.height; // brings me height of screen
    // final screenWidth =   MediaQuery.of(context).size.width; // brings me width of screen

    // Equation for factor x : screenHeight/size you want then (screenHeight/result)
    // my device screen size is 740 .. Let's say you have container with 30 height
    // factor x would be 740/30
    return screenHeight / (screenHeight / size);
  }

  // sizes (height,width,radius)
  // static double size300 = screenHeight / 2.47;
  // static double size10 = screenHeight / 74.0;
  // static double size5 = screenHeight / 148.0;
  // static double size20 = screenHeight / 37.0;
  // static double size200 = screenHeight / 3.7;
  // static double size30 = screenHeight / 24.7;
  // static double size40 = screenHeight / 18.5;
  // static double size120 = screenHeight / 6.17;
  // static double size115 = screenHeight / 6.43;
  // static double size100 = screenHeight / 7.4;
  // static double size15 = screenHeight / 49.3;
  // static double size250 = screenHeight / 2.98;
  // static double size80 = screenHeight / 9.3;
}
