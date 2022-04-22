// ignore_for_file: unused_element

import 'dart:async';

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/screens/configuration/location.dart';
import 'package:Fuligo/screens/tours/start_tour.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:Fuligo/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/widgets/text_header.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import 'package:latlong2/latlong.dart';

// import 'package:location/location.dart';

// ignore: must_be_immutable
class VerifyTracking extends StatefulWidget {
  String permission;
  VerifyTracking({Key? key, required this.permission}) : super(key: key);

  @override
  VerifyTrackingState createState() => VerifyTrackingState();
}

class VerifyTrackingState extends State<VerifyTracking> {
  List<Marker> markers = [];
  bool permission = false;
  bool emailVerified = false;
  String page = "Verify";
  Map headerData = {};

  late Timer timer;
  User? user;
  bool loading = true;
  bool isUserEmailVerified = false;
  // late LatLng currentUserPoistion;
  LatLng currentUserPoistion = LatLng(38.9036614038578, -76.99211156195398);

  @override
  void initState() {
    super.initState();
    getHeader();
    User? fireUser = FirebaseAuth.instance.currentUser;

    if (fireUser?.emailVerified == false) {
      fireUser?.sendEmailVerification();
    }
    timer = Timer.periodic(
      const Duration(
        seconds: 5,
      ),
      (timer) {
        checkEmailVerified();
      },
    );
  }

  Future<void> getHeader() async {
    FirebaseFirestore.instance
        .collection('header')
        .doc("od9KyauEGUn5PYycMKS6")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        headerData = documentSnapshot[page];
        print("headerData");
        print(headerData);
        setState(() {
          headerData = headerData;
        });
      }
    });
    await getUserLocation();
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // LocationPermission permission2;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();

    print("permission status");
    print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaa");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationScreen(),
          ),
        );
      }
    } else {
      Position position =
          await GeolocatorPlatform.instance.getCurrentPosition();
      LatLng tmp = LatLng(position.latitude, position.longitude);
      setState(() {
        currentUserPoistion = tmp;
        loading = false;
      });
    }
  }

  Future<void> checkEmailVerified() async {
    User? fireUser = FirebaseAuth.instance.currentUser;

    await fireUser?.reload();
    final signedInUser = fireUser;
    if (signedInUser != null && signedInUser.emailVerified) {
      timer.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StartTour(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userInfo = AuthProvider.of(context).userModel;

    String lang = userInfo.app_lang.toString();
    var mq = MediaQuery.of(context).size;
    var mapHeight = mq * 0.5;
    return !loading
        ? Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/discover.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Center(
                      child: Column(
                    children: [
                      Logo,
                      PageHeader(context, headerData["title"][lang].toString(),
                          headerData["subtitle"][lang].toString()),
                      !permission
                          ? Container(
                              height: mapHeight.height,
                              width: mq.width * 0.6,
                              margin: const EdgeInsets.only(top: 15),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                LocalText.allow_title[lang]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Text(
                                                  LocalText
                                                      .allow_description[lang]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: FlutterMap(
                                            options: MapOptions(
                                              center: currentUserPoistion,
                                              zoom: 16.0,
                                            ),
                                            layers: [
                                              TileLayerOptions(
                                                urlTemplate:
                                                    'https://api.mapbox.com/styles/v1/sakura0122/cl0asbsbv000314menn31lgqa/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2FrdXJhMDEyMiIsImEiOiJja3pmNTFjam0yZ3M0Mm9tbTJ3bnFqbHc0In0.SbKkWu_yR23brbvErKLL9Q',
                                                additionalOptions: {
                                                  'accessToken':
                                                      LocalText.accessToken,
                                                },
                                              ),
                                              MarkerLayerOptions(
                                                markers: [
                                                  Marker(
                                                    point: currentUserPoistion,
                                                    builder: (ctx) =>
                                                        IconButton(
                                                      icon: Icon(Icons
                                                          .person_pin_circle),
                                                      iconSize: 40,
                                                      color: Color.fromARGB(
                                                          255, 243, 33, 33),
                                                      onPressed: null,
                                                      // color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Text("")
                    ],
                  ))
                ],
              ),
            ),
          )
        : defaultloading(context);
  }
}
