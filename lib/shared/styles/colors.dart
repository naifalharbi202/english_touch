import 'package:flutter/material.dart';

MaterialColor defaultColor = Colors.blue;

List<Color> myColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.purple,
];

Widget colorItem(
  Color color,
) =>
    Padding(
      padding: const EdgeInsetsDirectional.only(top: 4.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: color,
      ),
    );
