// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:Fuligo/utils/common_colors.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// import 'package:Fuligo/utils/common_colors.dart';

Widget MenuList(Concontext, Icon icon, String txt) => Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: ListTile(
        leading: Icon(
          Icons.map,
          color: whiteColor,
          size: 30,
        ),
        title: Text(
          txt,
          style: TextStyle(color: whiteColor, fontSize: 22),
        ),
      ),
    );
