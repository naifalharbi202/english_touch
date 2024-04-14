import 'package:call_me/models/word_model.dart';
import 'package:flutter/material.dart';

String source = '';
String uId = '';
List<WordModel> cards = [];
int? currentWordStart, currentWordEnd;
bool isSpeakOn = false;
int wordsCounter = 0;
List<String> words = [];
//Source Menu Items
final List<PopupMenuItem> sourceMenuItems = [
  // Book Item
  const PopupMenuItem(
    value: "كتاب",
    child: Row(
      children: [
        Icon(
          Icons.book,
          color: Colors.amber,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'كتاب',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
  // Movie Item
  const PopupMenuItem(
    value: "فيلم",
    child: Row(
      children: [
        Icon(
          Icons.movie_creation_outlined,
          color: Colors.lightBlue,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'فيلم',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
  //Friend Item
  const PopupMenuItem(
    value: "صديق",
    child: Row(
      children: [
        Icon(
          Icons.person_3_outlined,
          color: Colors.green,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'صديق',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    value: "المدرسة",
    child: Row(
      children: [
        Icon(
          Icons.school,
          color: Colors.purpleAccent,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'المدرسة',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    value: "DiffSource",
    child: Row(
      children: [
        Icon(
          Icons.difference,
          color: Colors.redAccent,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'مصدر آخر',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
];

// Main menu vertical items
final List<PopupMenuItem> mainItems = [
  const PopupMenuItem(
    value: "settings",
    child: Row(
      children: [
        Icon(
          Icons.settings,
          color: Colors.grey,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'الإعدادات',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    value: "logout",
    child: Row(
      children: [
        Icon(
          Icons.logout,
          color: Colors.grey,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          'تسجيل خروج',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  ),
];
