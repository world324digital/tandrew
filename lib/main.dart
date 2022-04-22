// @dart=2.9

import 'dart:convert';

import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/screens/home.dart';
import 'package:Fuligo/screens/splash_page.dart';
import 'package:Fuligo/utils/common_header_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Fuligo/routes/route.dart' as router;
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  //initilization of Firebase app

  // other Firebase service initialization

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String isLoad = "false";
  String title = '';
  String subtitle = '';
  @override
  void initState() {
    super.initState();
    setLang();
    getHeaderData(
      CollectionNameList.header,
      DocIdList.header,
    );
  }

  @override
  Future<String> getHeaderData(String collectionName, String docId) async {
    DocumentSnapshot headerData = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docId)
        .get();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('headerlist', jsonEncode(headerData.data()));
    isLoad = "true";
    setState(() {});
    return isLoad;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          // statusBarColor: AppColors.statusbarColor,
          //color set to transperent or set your own color
          // statusBarIconBrightness: Brightness.light,
          //set brightness for icons, like dark background light icons
          ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Flugio',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Noto_Sans_JP',
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashPage(),
          builder: FlutterSmartDialog.init(),
          onGenerateRoute: router.generateRoute),
    );
  }

  Future<void> setLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', "en_GB");
  }
}
