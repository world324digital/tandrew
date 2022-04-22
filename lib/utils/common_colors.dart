import 'package:flutter/material.dart';

const Color themeColor = Color(0xFF2b44ff);
const Color btnbackgroundColor = Color(0xFF1f28cf);
const Color letterColor = Color(0xFF202224);
const Color whiteColor = Color(0xFFFFFFFF);
const Color greyColor = Color(0xFFAAAAAA);
const Color titleColor = Color(0xFF2d3c49);
const Color tabColor = Color(0xFF393939);
const Color hintColor = Color(0xFF474747);
const Color aboveColor = Color(0xFF091818);
const Color chatHeaderColor = Color(0xFF134E5E);
const Color chatInputColor = Color(0xFF336573);
const Color chatMessageColor = Color(0xFF527e87);
// Background Color
const Color bgColor = Color.fromRGBO(85, 144, 151, 1);
const Color gradientFrom = Color.fromRGBO(19, 78, 94, 1);
const Color gradientFrom1 = Color.fromRGBO(19, 78, 90, 0.2);
const Color gradientTo = Color.fromRGBO(19, 78, 90, 0);
Color bgDecorationColor = chatHeaderColor.withOpacity(0.7);
const bgDecoration = BoxDecoration(
  color: bgColor,
  gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [gradientFrom, bgColor]),
);
const Color chatTitleColor = Color.fromRGBO(24, 83, 98, 1);
const Color chatContentColor = Color.fromRGBO(66, 120, 125, 1);
