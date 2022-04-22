// ignore_for_file: sized_box_for_whitespace

import 'dart:typed_data';

import 'package:Fuligo/screens/tours/cancel_tour.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:Fuligo/widgets/custom_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';
import 'package:Fuligo/widgets/custom_button.dart';
import 'package:Fuligo/widgets/subtxt.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourList extends StatefulWidget {
  final Map detailData;
  const TourList({Key? key, required this.detailData}) : super(key: key);

  @override
  TourListState createState() => TourListState();
}

class TourListState extends State<TourList> {
  List _tourdetail = [];
  List<Uint8List> imageList = [];
  bool loading = true;
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  void initState() {
    super.initState();
    Map detailData = widget.detailData;

    getData(detailData["pointOfInterests"]);
  }

  Future<void> getData(List _detail) async {
    final prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('lang') ?? "";
    if (_detail.isNotEmpty) {
      int n = 0;
      for (var referId in _detail) {
        referId.get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            print('Document exists on the database');

            var image_ist = documentSnapshot.get("image");
            Reference ref = storage.ref().child(image_ist[0]);

            String url = await ref.getDownloadURL();
            Uint8List uint8image =
                (await NetworkAssetBundle(Uri.parse(url)).load(""))
                    .buffer
                    .asUint8List();

            imageList.add(uint8image);

            String description = documentSnapshot.get('description')[lang];

            String name = documentSnapshot.get('name')[lang];
            var location = documentSnapshot.get('location');

            Map temp = {
              "description": description,
              "name": name,
              "image": url,
              "location": location,
              // "datetime": datetime,
            };

            _tourdetail.add(temp);
            n++;
            if (n == _detail.length) {
              setState(() {
                _tourdetail = _tourdetail;
                loading = false;
                imageList = imageList;
              });
            }
          }
        });
      }
    } else {
      loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Map _detailData = widget.detailData;
    print("_tourdetail");
    print(_tourdetail);
    List<Widget> _pointwidgets = [];

    if (_tourdetail.isNotEmpty) {
      for (var i = 0; i < _tourdetail.length; i++) {
        var item = _tourdetail[i];

        _pointwidgets.add(
          TourSmallImage(context, imageList[i], "Stop ${i + 1}", item["name"]),
        );
      }
    }

    var mq = MediaQuery.of(context).size;

    return !loading
        ? Container(
            decoration: bgDecoration,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _pointwidgets.isNotEmpty
                        ? Container(
                            width: mq.width,
                            height: mq.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: mq.height * 0.17,
                                ),
                                PageHeader(context, _detailData["name"],
                                    _detailData["description"]),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 60),
                                        child: SubTxt(context, 'Stops',
                                            _pointwidgets.length.toString()),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 60),
                                        child: SubTxt(context, 'Duration',
                                            '${widget.detailData["duration"]} Stunden'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: mq.width,
                            height: mq.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: mq.height * 0.1,
                                ),
                                Text(
                                  "No order data",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white30),
                                ),
                              ],
                            ),
                          ),
                    SecondaryButton(context),
                    Positioned(
                      bottom: 100,
                      left: 20,
                      child: SizedBox(
                        height: 140,
                        width: mq.width,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: _pointwidgets,
                        ),
                      ),
                    ),
                    _pointwidgets.isNotEmpty
                        ? Positioned(
                            bottom: 30,
                            child: Container(
                              width: mq.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 350,
                                    height: 50,
                                    child: CustomButton(
                                        context,
                                        CancelTour(id: _detailData["id"]),
                                        "Start tour"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Text(""),
                  ],
                ),
              ),
            ),
          )
        : defaultloading(context);
  }
}
