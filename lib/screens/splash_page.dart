import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/screens/home.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  String isLoad = "false";
  String title = '';
  String subtitle = '';
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: Home(),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: bgDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 200,
                height: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
