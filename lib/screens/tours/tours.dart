// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'dart:typed_data';

import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:Fuligo/widgets/custom_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tours extends StatefulWidget {
  const Tours({Key? key}) : super(key: key);

  @override
  ToursState createState() => ToursState();
}

class ToursState extends State<Tours> {
  @override
  void initState() {
    super.initState();
    getTourData();
  }

  List<Uint8List> imageList = [];
  List tourData = [];
  bool loading = true;

  final CollectionReference _tourCollection =
      FirebaseFirestore.instance.collection('cityGuide');

  Future<List> getTourData() async {
    QuerySnapshot querySnapshot = await _tourCollection.get();
    final prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('lang') ?? "";
    List snapdata = [];
    List idList = [];
    // Get data from docs and convert map to List
    if (querySnapshot.docs.isNotEmpty) {
      for (var element in querySnapshot.docs) {
        snapdata.add(element.data());
        idList.add(element.id);
      }

      for (var i = 0; i < snapdata.length; i++) {
        var item = snapdata[i];
        String imageUrl = await getUrlFromFirebase(item["image"][0]);
        Uint8List uint8image =
            (await NetworkAssetBundle(Uri.parse(imageUrl)).load(""))
                .buffer
                .asUint8List();

        imageList.add(uint8image);

        String name = item["name"][lang];
        String description = item["description"][lang];
        List pointOfInterests = item["pointOfInterests"];

        Map temp = {
          "id": idList[i],
          "name": name,
          "description": description,
          "pointOfInterests": pointOfInterests,
          "active": item["active"],
          "duration": item["duration"]
        };
        tourData.add(temp);
      }
      setState(() {
        tourData = tourData;
        imageList = imageList;
        loading = false;
      });
    } else {
      loading = false;
      setState(() {});
    }
    return tourData;
  }

  Future<String> getUrlFromFirebase(String firebaseURL) async {
    Reference ref = FirebaseStorage.instance.ref().child(firebaseURL);
    String url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    List<Widget> tourlist = [];
    for (var i = 0; i < tourData.length; i++) {
      var each = tourData[i];
      if (each["active"] == false) {
        /// each["active"] == true
        tourlist.add(TourCard(context, imageList[i], each));
      }
    }

    return Container(
      decoration: bgDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              width: mq.width,
              height: mq.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: mq.height * 0.17,
                  ),
                  PageHeader(
                    context,
                    "Tours",
                    "Dicovery the city with one of \n our digital travel tours",
                  ),
                  !loading
                      ? tourlist.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              height: mq.height - 230,
                              child: ListView(
                                padding: EdgeInsets.all(0),
                                children: tourlist,
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
                                  "No Tour data",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white30),
                                ),
                              ],
                            )
                      : Container(
                          // color: widget.backgroundColor,
                          margin: EdgeInsets.symmetric(vertical: 100),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: mq.height * 0.1,
                                ),
                                kRingWidget(context),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SecondaryButton(context),
          ],
        ),
      ),
    );
  }
}
