// ignore_for_file: sized_box_for_whitespace

import 'dart:typed_data';

import 'package:Fuligo/utils/font_style.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:Fuligo/widgets/logo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';

// import 'package:Fuligo/screens/tours.dart';

class DocumentDetail extends StatefulWidget {
  List citydetail;
  // ignore: non_constant_identifier_names
  String image_url;
  // ignore: non_constant_identifier_names
  DocumentDetail({Key? key, required this.citydetail, required this.image_url})
      : super(key: key);

  @override
  DocumentDetailState createState() => DocumentDetailState();
}

class DocumentDetailState extends State<DocumentDetail> {
  Future<String> getDownloadDoc(location) async {
    Reference ref = FirebaseStorage.instance.ref().child(location);
    String url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    List<Widget> detaildata = [];
    for (var each in widget.citydetail) {
      for (var item in each) {
        detaildata.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradientFrom, bgColor]),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              leading: Icon(Icons.cloud_download_outlined,
                  color: Colors.white70, size: 32),
              title: Text(
                item["label"],
                style: font_14_white,
              ),
              subtitle: Text(
                item["type"],
                style: font_14_white_70,
              ),
              onTap: () => {
                // Navigator.pushNamed(context, RouteName.Startour),
                print("object"),
                print(getDownloadDoc(item["location"])),
              },
            ),
          ),
        );
      }
      print("123123");
      print(widget.citydetail);
    }
    return Container(
      decoration: bgDecoration,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image_url), fit: BoxFit.fill),
              ),
              width: mq.width,
              height: mq.height,
              alignment: Alignment.center,
              child: Container(
                width: mq.width,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [gradientFrom, bgColor]),
                    color: bgColor.withOpacity(0.8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Logo,
                    detaildata.length > 0
                        ? Container(
                            height: mq.height * 0.75,
                            // height: mq.height * 0.6,
                            width: mq.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.all(0),
                              children: detaildata,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: mq.height * 0.2,
                              ),
                              Text(
                                "No detail data",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white30),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            SecondaryButton(context)
          ],
        ),
      ),
    );
  }
}
