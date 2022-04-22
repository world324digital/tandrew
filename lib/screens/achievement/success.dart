// ignore_for_file: sized_box_for_whitespace
import 'dart:typed_data';

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/screens/tours/tour_another.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';

import 'package:Fuligo/widgets/custom_button.dart';
import 'package:Fuligo/screens/achievement/credits.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/auth_provider.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends State<Success> {
  void initState() {
    super.initState();
    // getUserPosition();
    getData();
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  String pointName = "";
  int award = 0;
  bool loading = true;
  // List<Reference> achList = [];
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? parentID = prefs.getString('parentID');
    final langprefs = await SharedPreferences.getInstance();
    String lang = langprefs.getString('lang') ?? "";

    CollectionReference user = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('cityGuide')
        .doc("UgWAH8pQR2OLNW43HyHk")
        .get();
    pointName = snapshot["name"][lang];
    List achList = snapshot["achievements"];
    List imageList = snapshot["image"];
    Reference ref = storage.ref().child(imageList[0]);

    // String imgUrl = await ref.getDownloadURL();

    // Uint8List uint8image =
    //     (await NetworkAssetBundle(Uri.parse(imgUrl)).load(""))
    //         .buffer
    //         .asUint8List();

    for (var i = 0; i < achList.length; i++) {
      var item = achList[i];

      item.get().then(
        (DocumentSnapshot documentSnapshot) async {
          int credits = documentSnapshot["credits"];
          award = award + credits;
          if (i == achList.length - 1) {
            UserModel userInfo = AuthProvider.of(context).userModel;
            user
                .doc(userInfo.uid)
                .set({'achievements': achList, "credits": award},
                    SetOptions(merge: true))
                .then((value) => {})
                .catchError((error) => {});
            setState(() {
              award = award;
              pointName = pointName;
              loading = false;
            });
          }
        },
      );
    }

    // setState(() {
    //   achList = achList;
    // });
  }

  @override
  Widget build(BuildContext context) {
    print("award ${award}");
    var mq = MediaQuery.of(context).size;
    return !loading
        ? Container(
            decoration: const BoxDecoration(
              color: bgColor,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradientFrom, bgColor]),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // appBar: AppBar(
              //   title: Text('TEST'),
              // ),
              body: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 0, left: 0),
                    width: mq.width,
                    height: mq.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        PageHeader(
                          context,
                          "Success",
                          "You finished an achievement",
                        ),
                        Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 60),
                            decoration: BoxDecoration(
                              color: bgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    'assets/images/png/icon-umbrella.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Text(
                                  pointName.toString(),
                                  style: TextStyle(
                                      color: whiteColor, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    child: Container(
                      width: mq.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "You have earned CHF ${award}",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 12,
                                letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
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
                            child:
                                CustomButton(context, TourAnother(), "Close"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : defaultloading(context);
  }
}
