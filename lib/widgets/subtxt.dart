// ignore_for_file: non_constant_identifier_names

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/utils/font_style.dart';
import 'package:flutter/material.dart';

// ignore: deprecated_member_use
Widget SubTxt(context, String uptxt, String downtxt) => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          uptxt,
          style: font_14_white_70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            downtxt,
            style: font_14_white,
          ),
        ),
      ],
    );
