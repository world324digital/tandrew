// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget SecondaryButton(context) => Positioned(
      top: 50,
      left: 20,
      child: GestureDetector(
        onTap: () => {(Navigator.pop(context))},
        child: Image.asset(
          'assets/images/icon-close.png',
          scale: 11,
        ),
      ),
    );
Widget ClearRoundButton(context, double left) => Positioned(
      bottom: 30,
      left: left,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          "assets/images/direction_close.png",
          scale: 3.5,
        ),
      ),
    );
