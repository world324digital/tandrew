import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'common_colors.dart';

/// For Loading Widget
Widget kLoadingWidget(context) => Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 50.0,
      ),
    );
Widget kLoadingWaveWidget(context, Color color) => Center(
      child: SpinKitWave(
        color: color,
        size: 50.0,
      ),
    );
Widget kRingWidget(context) => Center(
      child: SpinKitRing(
        color: Color(0xffebebeb),
        size: 50.0,
        lineWidth: 4.0,
      ),
    );

Widget kLoadingFadingWidget(context) => Center(
      child: SpinKitFadingCircle(
        color: whiteColor,
        size: 50.0,
      ),
    );
Widget defaultloading(context) => Container(
      decoration: bgDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            constraints: const BoxConstraints.expand(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 150,
                    height: 70,
                  ),
                ),
                kRingWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
