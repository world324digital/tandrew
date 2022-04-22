// ignore_for_file: sized_box_for_whitespace

import 'package:Fuligo/widgets/clear_button.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';

// import 'package:Fuligo/screens/tours.dart';

class Info extends StatefulWidget {
  Map infodata;
  Info({Key? key, required this.infodata}) : super(key: key);

  @override
  InfoState createState() => InfoState();
}

class InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    Map infodata = widget.infodata;
    print("Info page");
    print(infodata["image"]);

    var mq = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(infodata["image"]), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text('TEST'),
        // ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(color: aboveColor.withOpacity(0.8)),
                width: mq.width,
                height: mq.height,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: mq.height * 0.17,
                    ),
                    PageHeader(
                      context,
                      infodata["name"]!,
                      infodata["description"]!,
                    ),
                  ],
                )),
            ClearRoundButton(context, mq.width / 2 - 40),
          ],
        ),
      ),
    );
  }
}
