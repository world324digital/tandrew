import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:Fuligo/screens/video/audio.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:Fuligo/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/common_colors.dart';
import '../../widgets/circleimage.dart';
import '../../widgets/custom_button.dart';
import 'package:mapbox_api/mapbox_api.dart';
import 'package:http/http.dart' as http;
import '../video/video.dart';

// ignore: must_be_immutable
class CancelTour extends StatefulWidget {
  String id;
  CancelTour({Key? key, required this.id}) : super(key: key);

  @override
  _CancelTourState createState() => _CancelTourState();
}

class _CancelTourState extends State<CancelTour> {
  MapController mapController = MapController();
  LatLng currentUserPoistion =
      LatLng(38.9036614038578, -76.99211156195398); // call getcurrentposition
  LatLng nearestPosition = LatLng(0.00, 0.00);
  final mapbox = MapboxApi(
    accessToken: LocalText.accessToken,
  );
  List<LatLng> points = [];
  List<Marker> markers = [];
  List pointdata = [];
  bool loading = true;
  List nameList = [];
  List flagList = [];
  List<Uint8List> imageList = [];
  List<Map> mediaList = [];
  double shortDistance = 0;

  int index = 0;
  List selectedLocation = [];

  final CollectionReference _tourCollection =
      FirebaseFirestore.instance.collection('cityGuide');

  final CollectionReference _pointCollection =
      FirebaseFirestore.instance.collection('pointOfInterest');
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  void initState() {
    super.initState();
    getPointInterest();
  }

  Future<void> _getUserLocation() async {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();
    LatLng tmp = LatLng(position.latitude, position.longitude);
    setState(() {
      currentUserPoistion = tmp;
    });
    // getLocationUpdates();
  }

  Future<void> drawPoint() async {
    // points.add(currentUserPoistion);
    print(currentUserPoistion);

    String request =
        "https://api.mapbox.com/directions/v5/mapbox/walking/${currentUserPoistion.longitude},${currentUserPoistion.latitude};${nearestPosition.longitude},${nearestPosition.latitude}?steps=true&geometries=geojson&access_token=pk.eyJ1Ijoic2FrdXJhMDEyMiIsImEiOiJja3pmNTFjam0yZ3M0Mm9tbTJ3bnFqbHc0In0.SbKkWu_yR23brbvErKLL9Q";
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      double duration = data["routes"][0]["duration"];
      double distance = data["routes"][0]["distance"];

      final eta = Duration(seconds: duration.toInt());

      var coordinates = data["routes"][0]["geometry"]["coordinates"];
      print("coordinates");
      print(coordinates);

      for (var i = 0; i < coordinates.length; i++) {
        points.add(
          LatLng(
            coordinates[i][1],
            coordinates[i][0],
          ),
        );
      }
      setState(() {
        points = points;
      });
    } else {
      SmartDialog.showToast(
        "Exceed distance. We can't point of interest near by you",
        alignment: Alignment.topCenter,
        // animationDurationTemp: Duration(seconds: 8),
      );
    }
  }

  Future<List> getPointInterest() async {
    await _getUserLocation();
    print(currentUserPoistion);
    final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
    final positionStream = _geolocatorPlatform.getPositionStream();
    _positionStreamSubscription = positionStream.handleError((error) {
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
    }).listen((position) {
      LatLng tempLocation = LatLng(position.latitude, position.longitude);
      if (tempLocation.latitude == currentUserPoistion.latitude &&
          tempLocation.longitude == currentUserPoistion.longitude) {
        return;
      } else {
        print("position");
        print(position);
        print("currentUserPoistion");
        print(currentUserPoistion);
        markers.removeWhere((element) => element.point == currentUserPoistion);
        currentUserPoistion = LatLng(position.latitude, position.longitude);

        // LatLng tempLocation = LatLng(position.latitude, position.longitude);
        // if (tempLocation.latitude == currentUserPoistion.latitude &&
        //     tempLocation.longitude == currentUserPoistion.longitude) return;

        markers.add(
          Marker(
            point: currentUserPoistion,
            rotate: true,
            // point: _center,
            builder: (ctx) =>
                Image.asset("assets/images/location_marker.png", scale: 6),
          ),
        );
        setState(() {
          // currentUserPoistion = currentUserPoistion;
        });
      }
    });

    markers.add(
      Marker(
        point: currentUserPoistion, //current user poistion
        builder: (ctx) =>
            Image.asset("assets/images/location_marker.png", scale: 6),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('lang') ?? "";
    QuerySnapshot querySnapshot = await _pointCollection.get();
    List videoUrl = [];
    List imageUrlList = [];
    int n = 0;
    Map location = {};
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('cityGuide')
        .doc(widget.id)
        .get();
    List pointList = snapshot["pointOfInterests"];

    if (pointList.isNotEmpty) {
      for (var j = 0; j < pointList.length; j++) {
        var refId = pointList[j];
        refId.get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            var sellocation = documentSnapshot.get('location');
            selectedLocation.add(sellocation);
            await calculateDistance(
                sellocation["latitude"]!, sellocation["longitude"]!, j);
          }
        });
      }
    }

    if (querySnapshot.docs.isNotEmpty) {
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        var ele = querySnapshot.docs[i];
        location = ele.get('location');

        var name = ele.get("name")[lang];
        nameList.add(name);

        try {
          videoUrl = ele.get("video");
        } catch (e) {
          videoUrl = [];
        }

        if (videoUrl.isNotEmpty) {
          flagList.add("video");
          imageUrlList = ele.get("image");

          if (imageUrlList.isNotEmpty) {
            String videoId = ele.id;

            String videoimgurl =
                await getUrlFromFirebase(imageUrlList[0].toString());
            Uint8List uint8image =
                (await NetworkAssetBundle(Uri.parse(videoimgurl)).load(""))
                    .buffer
                    .asUint8List();
            imageList.add(uint8image);
            Map video = {
              "id": videoId,
              "name": name,
              "index": i,
              "image": uint8image,
              "flag": "video",
              "parentId": widget.id
            };
            mediaList.add(video);

            markers.add(
              Marker(
                width: 120.0,
                height: 144.0,
                point: LatLng(location["latitude"], location["longitude"]),
                builder: (ctx) =>
                    CircleVideoMapImage(context, videoId, uint8image),
              ),
            );
            n++;
          }

          // pointdata.add({"id": id, "location": location, "flag": "video"});
        } else {
          imageUrlList = ele.get("image");
          flagList.add("audio");
          String audioId = ele.id;
          if (imageUrlList.isNotEmpty) {
            String audioimgUrl = await getUrlFromFirebase(imageUrlList[0]);

            Uint8List uint8image =
                (await NetworkAssetBundle(Uri.parse(audioimgUrl)).load(""))
                    .buffer
                    .asUint8List();
            imageList.add(uint8image);
            Map audio = {
              "id": audioId,
              "name": name,
              "index": i,
              "image": uint8image,
              "flag": "audio",
              "parentId": widget.id
            };
            mediaList.add(audio);
            markers.add(
              Marker(
                width: 120.0,
                height: 144.0,
                point: LatLng(location["latitude"]!, location["longitude"]!),
                builder: (ctx) =>
                    CircleAudioMapImage(context, audioId, uint8image),
              ),
            );
            n++;
          }
        }
      }

      if (n == querySnapshot.docs.length) {
        setState(() {
          shortDistance = shortDistance;
          nearestPosition = nearestPosition;
          pointdata = pointdata;
          markers = markers;
          loading = false;
          imageList = imageList;
        });
        drawPoint();
      }
    } else {
      setState(() {
        loading = false;
        markers = markers;
      });
    }

    return pointdata;
  }

  Future<void> calculateDistance(lat2, lon2, i) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - currentUserPoistion.latitude) * p) / 2 +
        c(currentUserPoistion.latitude * p) *
            c(lat2 * p) *
            (1 - c((lon2 - currentUserPoistion.longitude) * p)) /
            2;
    var distance = 1000 * 12742 * asin(sqrt(a));

    if (shortDistance == 0) {
      shortDistance = distance;
      nearestPosition.latitude = lat2;
      nearestPosition.longitude = lon2;
    } else if (distance < shortDistance) {
      shortDistance = distance;
      nearestPosition.latitude = lat2;
      nearestPosition.longitude = lon2;
      index = i;
    }
  }

  Future<String> getUrlFromFirebase(String firebaseURL) async {
    Reference ref = FirebaseStorage.instance.ref().child(firebaseURL);
    String url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    print("selectedLocation");
    print(selectedLocation);
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: !loading
          ? Stack(alignment: Alignment.center, children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [gradientFrom, bgColor]),
                    color: bgColor.withOpacity(0.5)),
                child: FlutterMap(
                  options: MapOptions(
                    center: currentUserPoistion,
                    // current user postion
                    minZoom: 13.0,

                    // bounds: LatLngBounds(
                    //   LatLng(currentUserPoistion.latitude - 0.5,
                    //       currentUserPoistion.longitude - 0.5), // [west,south]
                    //   LatLng(currentUserPoistion.latitude + 0.5,
                    //       currentUserPoistion.longitude + 0.5),
                    // ), // [east,north]
                    // boundsOptions:
                    //     const FitBoundsOptions(padding: EdgeInsets.all(8.0)),
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: LocalText.styleWithBackground,
                      // urlTemplate:
                      //     'https://api.mapbox.com/styles/v1/sakura0122/cl0asbsbv000314menn31lgqa/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2FrdXJhMDEyMiIsImEiOiJja3pmNTFjam0yZ3M0Mm9tbTJ3bnFqbHc0In0.SbKkWu_yR23brbvErKLL9Q',
                      additionalOptions: {
                        'accessToken': LocalText.accessToken,
                      },
                    ),
                    PolylineLayerOptions(polylineCulling: true, polylines: [
                      Polyline(
                          isDotted: true,
                          points: points,
                          strokeWidth: 8.0,
                          color: Colors.white)
                    ]),
                    MarkerLayerOptions(
                        markers: markers, rotateAlignment: Alignment.center),
                  ],
                  mapController: mapController,
                ),
              ),
              MenuButton(context),
              Positioned(
                bottom: 30,
                child: Container(
                  width: mq.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: CancelButton(context, "Cancel Tour"),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(top: 10, child: Logo),
              Positioned(
                bottom: 100,
                child: Container(
                  width: mq.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: mq.height * 0.1,
                        width: mq.width * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(mediaList[index]["image"],
                                scale: 0.5),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [gradientFrom, chatHeaderColor]),
                              color: chatHeaderColor.withOpacity(0.7)),
                          child: ListTile(
                            leading: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.play_arrow,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              'In ${shortDistance.round()} Meter',
                              style: const TextStyle(color: Colors.white54),
                              // textScaleFactor: 1.5,
                            ),
                            trailing: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                "assets/images/icon-route.png",
                                scale: 5,
                              ),
                            ),
                            subtitle: Text(
                              mediaList[index]["name"],
                              textScaleFactor: 1.1,
                              style: const TextStyle(color: whiteColor),
                            ),
                            selected: false,
                            onTap: () {
                              if (flagList[index] == "video") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Video(
                                      id: mediaList[index]["id"],
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Audio(
                                      id: mediaList[index]["id"],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])
          : defaultloading(context),
    );
  }
}
