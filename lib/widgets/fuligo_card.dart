import 'package:flutter/material.dart';
import 'package:Fuligo/utils/common_colors.dart';

// ignore: non_constant_identifier_names
Widget FuligoCard(context, String content, Color color) => Stack(
      children: [
        Container(
          width: 165,
          height: 140,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,

                offset: const Offset(1, 0), // changes position of shadow
              ),
            ],
            color: bgColor,
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradientFrom, bgColor]),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Icon(
                  Icons.audiotrack,
                  color: color,
                  size: 30.0,
                ),
              ),
              Text(
                content,
                style: TextStyle(color: color, fontSize: 16),
              ),
            ],
          ),
        ),
        Positioned(
          top: 25,
          right: 20,
          child: Icon(
            color == whiteColor ? Icons.check_circle : Icons.cancel,
            color: color,
            size: 16.0,
          ),
        ),
      ],
    );
