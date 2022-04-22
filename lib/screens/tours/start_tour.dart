import 'dart:async';
import 'dart:typed_data';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:Fuligo/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../utils/common_colors.dart';
import '../../widgets/custom_button.dart';
import '../tours/tours.dart';
import 'package:mapbox_api/mapbox_api.dart';

import '../video/audio.dart';
import '../video/video.dart';

class StartTour extends StatefulWidget {
  const StartTour({Key? key}) : super(key: key);
  @override
  _StartTourState createState() => _StartTourState();
}

class _StartTourState extends State<StartTour> {
  MapController mapController = MapController();
  final mapbox = MapboxApi(
    accessToken: LocalText.accessToken,
  );

  List pointdata = [];
  bool loading = true;
  List imageNetList = [];
  List<Uint8List> imageList = [];
  List<Marker> markers = [];

  final CollectionReference _pointCollection =
      FirebaseFirestore.instance.collection('pointOfInterest');
  // late LatLng currentUserPoistion;
  LatLng currentUserPoistion = LatLng(39.37923, -77.0728);
  // late LatLng currentUserPoistion;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  @override
  void initState() {
    super.initState();
    // _getUserLocation();
    getPointData();
  }

  // Future<void> _getUserLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   // LocationPermission permission2;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   permission = await Geolocator.checkPermission();

  //   print("permission status");
  //   print(permission);
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => LocationScreen(),
  //         ),
  //       );
  //     }
  //   } else {
  //     Position position =
  //         await GeolocatorPlatform.instance.getCurrentPosition();
  //     LatLng tmp = LatLng(position.latitude, position.longitude);
  //     setState(() {
  //       currentUserPoistion = tmp;
  //       loading = false;
  //     });
  //   }
  // }

  Future<void> _getUserLocation() async {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();
    LatLng tmp = LatLng(position.latitude, position.longitude);
    setState(() {
      currentUserPoistion = tmp;
    });
  }

  Future<List> getPointData() async {
    await _getUserLocation();
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
        markers.add(
          Marker(
            point: currentUserPoistion,
            rotate: true,
            // point: _center,
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

    QuerySnapshot querySnapshot = await _pointCollection.get();
    List videoUrl = [];
    List imageUrlList = [];
    int n = 0;
    Map itemlocation = {};
    if (querySnapshot.docs.isNotEmpty) {
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        var ele = querySnapshot.docs[i];

        try {
          videoUrl = ele.get("video");
        } catch (e) {
          videoUrl = [];
        }
        itemlocation = ele.get('location');
        String id = ele.id;
        imageUrlList = ele.get("image");

        if (videoUrl.isNotEmpty) {
          if (imageUrlList.isNotEmpty) {
            String videoimgurl =
                await getUrlFromFirebase(imageUrlList[0].toString());
            markers.add(
              Marker(
                width: 60.0,
                height: 60.0,
                point:
                    LatLng(itemlocation["latitude"], itemlocation["longitude"]),
                builder: (ctx) => Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Video(
                            id: id,
                          ),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: videoimgurl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
            n++;
          }
        } else {
          if (imageUrlList.isNotEmpty) {
            // ignore: non_constant_identifier_names
            String Audioimgurl =
                await getUrlFromFirebase(imageUrlList[0].toString());
            markers.add(
              Marker(
                width: 100,
                height: 100,
                point:
                    LatLng(itemlocation["latitude"], itemlocation["longitude"]),
                builder: (ctx) => Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Audio(id: id),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: Audioimgurl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
            n++;
          }
        }
      }

      if (n == querySnapshot.docs.length) {
        setState(() {
          pointdata = pointdata;
          markers = markers;
          loading = false;
          imageList = imageList;
        });
      }
    } else {
      setState(() {
        loading = false;
        markers = markers;
      });
    }

    return pointdata;
  }

  Future<String> getUrlFromFirebase(String firebaseURL) async {
    Reference ref = FirebaseStorage.instance.ref().child(firebaseURL);
    String url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
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
                    center: currentUserPoistion, // current user postion
                    minZoom: 10.0,
                    zoom: 13,
                    // bounds: LatLngBounds(
                    //   LatLng(currentUserPoistion.latitude - 0.5,
                    //       currentUserPoistion.longitude - 0.5), // [west,south]
                    //   LatLng(currentUserPoistion.latitude + 0.5,
                    //       currentUserPoistion.longitude + 0.5),
                    // ), // [/ [east,north]
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
                    MarkerLayerOptions(markers: markers),
                  ],
                  mapController: mapController,
                ),
              ),
              Positioned(top: 10, child: Logo),
              MenuButton(context),
              PrimaryButton(context, const Tours(), "Start tour".toString())
            ])
          : defaultloading(context),
    );
  }
}
