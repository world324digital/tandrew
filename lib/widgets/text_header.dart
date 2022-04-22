// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:Fuligo/utils/font_style.dart';

Widget PageHeader(context, String title, String content) => Container(
      // height: 70,
      // padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: font_20_white,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
              width: 62,
              height: 2.5,
              decoration: const BoxDecoration(color: Colors.white30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              content,
              style: font_14_white,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

// Widget PageHeader1(context, String title, String content) => Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//           child: Text(
//             title,
//             style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w400,
//                 letterSpacing: 2,
//                 color: whiteColor),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//           child: Container(
//             width: 62,
//             height: 2.5,
//             decoration: const BoxDecoration(color: Colors.grey),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
//           child: Text(
//             content,
//             style: const TextStyle(
//               fontSize: 13,
//               color: whiteColor,
//               fontWeight: FontWeight.w400,
//               letterSpacing: 1,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
