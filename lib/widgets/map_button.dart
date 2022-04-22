import 'package:flutter/material.dart';
import 'package:Fuligo/routes/route_costant.dart';

// ignore: non_constant_identifier_names
Widget MapButton(context, String txt) => InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Color(0xFFBEBEBE)),
          ),
        ),
        child: Text(
          txt,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteName.Startour);
      },
    );
