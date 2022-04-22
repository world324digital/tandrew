import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:Fuligo/screens/achievement/success.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/circleimage.dart';
import 'package:mapbox_api/mapbox_api.dart';
import 'package:http/http.dart' as http;

import '../../widgets/custom_image.dart';
import '../../widgets/subtxt.dart';

class TourAnother extends StatefulWidget {
  TourAnother({Key? key}) : super(key: key);

  @override
  _TourAnotherState createState() => _TourAnotherState();
}

class _TourAnotherState extends State<TourAnother> {
  MapController mapController = MapController();

  LatLng currentUserPoistion =
      LatLng(39.37923, -77.0728); // call getcurrentposition

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
  List _tourdetail = [];
  List<Map> mediaList = [];
  double shortDistance = 0;
  LatLng nearestPosition = LatLng(0.00, 0.00);
  int index = 0;
  List partPoints = [];
  double lon1 = 0.00;
  double lon2 = 0.00;
  double lat1 = 0.00;
  double lat2 = 0.00;
  int remaining = 0;
  int stopcount = 0;
  int passCounts = 0;
  late Timer _timer;

  FirebaseStorage storage = FirebaseStorage.instance;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  void initState() {
   
    getPointInterest();
  }

  Future<void> _getUserLocation() async {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();
    LatLng tmp = LatLng(position.latitude, position.longitude);
    setState(() {
      currentUserPoistion = tmp;
    });
   
  }

  Future<void> getPointInterest() async {
    await _getUserLocation();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? parentID = prefs.getString('parentID');
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
        markers.removeWhere((element) => element.point == currentUserPoistion);
        currentUserPoistion = LatLng(position.latitude, position.longitude);
        calculateDistance(partPoints);
        markers.add(
          Marker(
            point: currentUserPoistion,
            rotate: true,
            builder: (ctx) =>
                Image.asset("assets/images/location_marker.png", scale: 6),
          ),
        );
        setState(() {});
      }
    });

    markers.add(
      Marker(
        point: currentUserPoistion, //current user poistion
        builder: (ctx) =>
            Image.asset("assets/images/location_marker.png", scale: 6),
      ),
    );
    final prefs2 = await SharedPreferences.getInstance();
    String lang = prefs2.getString('lang') ?? "";
    int n = 0;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('cityGuide')
        .doc(parentID)
        .get();
    List pointOfInterests = snapshot["pointOfInterests"];

    if (pointOfInterests.isNotEmpty) {
      stopcount = pointOfInterests.length;
      for (var j = 0; j < pointOfInterests.length; j++) {
        var refId = pointOfInterests[j];

        refId.get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            List videoUrl = [];
            try {
              videoUrl = documentSnapshot.get("video");
            } catch (e) {
              videoUrl = [];
            }
            var pointLocation = documentSnapshot.get('location');
            partPoints.add(pointLocation);
            if (videoUrl.isNotEmpty) {
              // partPoints.add(pointLocation); // location of PointofInterests

              var videoImageList = documentSnapshot.get("image");
              String videoId = documentSnapshot.id;
              Reference ref = storage.ref().child(videoImageList[0]);

              String url = await ref.getDownloadURL();
              Uint8List uint8image =
                  (await NetworkAssetBundle(Uri.parse(url)).load(""))
                      .buffer
                      .asUint8List();
              String description = documentSnapshot.get('description')["en_GB"];

              String name = documentSnapshot.get('name')["en_GB"];
              var location = documentSnapshot.get('location');

              imageList.add(uint8image);
              Map temp = {
                "description": description,
                "name": name,
                "image": url,
                "location": location,
                // "datetime": datetime,
              };
              _tourdetail.add(temp);
              markers.add(
                Marker(
                  width: 120.0,
                  height: 144.0,
                  point: LatLng(location["latitude"], location["longitude"]),
                  builder: (ctx) =>
                      CircleVideoMapImage(context, videoId, uint8image),
                ),
              );
            } else {
              // var sellocation = documentSnapshot.get('location');

              // partPoints.add(pointLocation); // location of PointofInterests

              var audioImageList = documentSnapshot.get("image");
              String audioId = documentSnapshot.id;
              Reference ref = storage.ref().child(audioImageList[0]);

              String url = await ref.getDownloadURL();
              Uint8List uint8image =
                  (await NetworkAssetBundle(Uri.parse(url)).load(""))
                      .buffer
                      .asUint8List();
              String description = documentSnapshot.get('description')["en_GB"];

              String name = documentSnapshot.get('name')["en_GB"];
              var location = documentSnapshot.get('location');

              imageList.add(uint8image);
              Map temp = {
                "description": description,
                "name": name,
                "image": url,
                "location": location,
                // "datetime": datetime,
              };
              _tourdetail.add(temp);
              markers.add(
                Marker(
                  width: 120.0,
                  height: 144.0,
                  point: LatLng(location["latitude"], location["longitude"]),
                  builder: (ctx) =>
                      CircleAudioMapImage(context, audioId, uint8image),
                ),
              );
            }
            if (partPoints.length > 1) {
              await drawPoint(partPoints);
              calculateDistance(partPoints);
              // _timer = Timer.periodic(new Duration(seconds: 5), (timer) {
              //   calculateDistance(partPoints);
              // });
            }
            n++;
            if (n == pointOfInterests.length) {
              setState(() {
                _tourdetail = _tourdetail;
                loading = false;
                imageList = imageList;
                partPoints = partPoints;
                stopcount = stopcount;
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

  Future<void> calculateDistance(List points) async {
    LatLng userPosition = currentUserPoistion;
    LatLng des =
        LatLng(points[passCounts]["latitude"], points[passCounts]["longitude"]);
    final Distance distance = Distance();
    var between = distance.as(LengthUnit.Meter, userPosition, des);
    // double between = 200;
    print("caluculat");
    print(between);
    if (between > -500 && between < 500) {
      passCounts++;
      setState(() {
        passCounts = passCounts;
      });
    }
  }

  Future<void> drawPoint(List pointList) async {
    print("pointList");
    print(pointList);
    String waypoints = "";

    for (var i = 0; i < pointList.length; i++) {
      var item = pointList[i];
      if (i == pointList.length - 1) {
        waypoints = waypoints +
            item["longitude"].toString() +
            "," +
            item["latitude"].toString();
      } else {
        waypoints = waypoints +
            item["longitude"].toString() +
            "," +
            item["latitude"].toString() +
            ";";
      }
    }
    print("waypointsString");
    print(waypoints);

    String request =
        "https://api.mapbox.com/directions/v5/mapbox/walking/$waypoints?steps=true&geometries=geojson&access_token=pk.eyJ1Ijoic2FrdXJhMDEyMiIsImEiOiJja3pmNTFjam0yZ3M0Mm9tbTJ3bnFqbHc0In0.SbKkWu_yR23brbvErKLL9Q";
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      double duration = data["routes"][0]["duration"];

      final eta = Duration(seconds: duration.toInt());
      remaining = eta.inMinutes;
      setState(() {
        remaining = remaining;
      });

      var coordinates = data["routes"][0]["geometry"]["coordinates"];
      // print("coordinates");
      // print(coordinates);

      for (var i = 0; i < coordinates.length - 1; i++) {
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
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> getUrlFromFirebase(String firebaseURL) async {
    Reference ref = FirebaseStorage.instance.ref().child(firebaseURL);
    String url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pointwidgets = [];
    if (_tourdetail.isNotEmpty) {
      for (var i = 0; i < _tourdetail.length; i++) {
        var item = _tourdetail[i];

        _pointwidgets.add(
          TourSmallImage(context, imageList[i], "Stop ${i + 1}", item["name"]),
        );
      }
      if (passCounts == _tourdetail.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Success(),
          ),
        );
      }
    }

    var mq = MediaQuery.of(context).size;

    return Scaffold(
      body: !loading
          ? Stack(alignment: Alignment.center, children: <Widget>[
              FlutterMap(
                options: MapOptions(
                  // center: currentUserPoistion, // current user postion
                  center: LatLng(points[0].latitude - 0.005,
                      points[0].longitude - 0.005), // current user postion
                  minZoom: 12.0,
                  zoom: 8.0,
                  // bounds: LatLngBounds(
                  //   LatLng(partPoints[0]["latitude"] - 0.5,
                  //       partPoints[0]["longitude"] - 0.5), // [west,south]
                  //   LatLng(partPoints[0]["latitude"] + 0.5,
                  //       partPoints[0]["longitude"] + 0.5),
                  // ), // [east,north]
                  // boundsOptions:
                  //     const FitBoundsOptions(padding: EdgeInsets.all(8.0)),
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: LocalText.styleWithBackground,
                    additionalOptions: {
                      'accessToken': LocalText.accessToken,
                    },
                  ),
                  PolylineLayerOptions(
                    // polylineCulling: true,
                    polylines: [
                      Polyline(
                          isDotted: true,
                          points: points,
                          strokeWidth: 2.0,
                          color: Colors.white)
                    ],
                  ),
                  MarkerLayerOptions(
                      key:
                          Key(DateTime.now().millisecondsSinceEpoch.toString()),
                      markers: markers,
                      rotateAlignment: Alignment.center),
                ],
                mapController: mapController,
              ),
              SecondaryButton(context),
              Positioned(
                bottom: 30,
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
              Container(
                  width: mq.width,
                  height: mq.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: SubTxt(context, 'Remaining',
                                  '${remaining.toString()} min'),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: SubTxt(context, 'Stops',
                                  '${passCounts} / ${stopcount}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ])
          : defaultloading(context),
    );
  }
}
