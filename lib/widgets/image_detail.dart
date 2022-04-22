import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget ImageDetail(context, String url, String title, String content) =>
    Container(
      // padding: EdgeInsets.fromLTRB(20, 0, 30, 10),
      width: 150,
      height: 130,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(url),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            content,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
