import 'package:flutter/material.dart';

Color defaultColor = const Color.fromARGB(255, 14, 76, 87); // default app color

Color defaultAnswerColor = Colors.white;
Color correctAnswerColor = Colors.green;
Color wrongAnswerColor = Colors.red;
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
