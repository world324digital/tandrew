import 'package:Fuligo/model/user_model.dart';

import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/repositories/user_repository.dart';
import 'package:Fuligo/screens/menu_screen.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:Fuligo/widgets/popup.dart';

import 'package:Fuligo/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:Fuligo/utils/common_colors.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map/map.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();

    // setState(() {});
  }

  bool loading = true;
  Future<void> getUser(String uid) async {
    final result = await UserRepository.getUserByID(uid);
    String url = "";

    var refId = result["avatar"];

    refId.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (result != null) {
          result["avatar"] = documentSnapshot["app_img"];
          UserModel _userModel = UserModel.fromJson(result);
          AuthProvider.of(context).setUserModel(_userModel);
        }
      }
    });
  }

  Future<void> saveLang(value, context) async {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    UserModel userInfo = AuthProvider.of(context).userModel;

    // if (loading) {
    //   await defaultloading(context);
    // } else {
    //   SmartDialog.showToast("changed language");
    // }
    switch (value) {
      case lang.en_GB:
        user
            .doc(userInfo.uid)
            .set({"app_lang": "en_GB"}, SetOptions(merge: true))
            .then((value) => {})
            .catchError((error) => {});
        await getUser(userInfo.uid);
        loading = false;

        break;
      case lang.de_CH:
        user
            .doc(userInfo.uid)
            .set({"app_lang": "de_CH"}, SetOptions(merge: true))
            .then((value) => {})
            .catchError((error) => {});
        await getUser(userInfo.uid);
        loading = false;
        break;

      case lang.nl_NL:
        user
            .doc(userInfo.uid)
            .set({"app_lang": "nl_NL"}, SetOptions(merge: true))
            .then((value) => {})
            .catchError((error) => {});
        break;

      default:
        user
            .doc(userInfo.uid)
            .set({"app_lang": "en_GB"}, SetOptions(merge: true))
            .then((value) => {})
            .catchError((error) => {});
        await getUser(userInfo.uid);
        loading = false;
    }
    SmartDialog.showToast("changed language");
  }

  final _headerStyle = const TextStyle(
      decoration: TextDecoration.none,
      color: Colors.white,
      fontSize: 20,
      letterSpacing: 1.5);
  final _contentStyleHeader = const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xff999999),
      fontSize: 14,
      fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xff999999),
      fontSize: 14,
      fontWeight: FontWeight.normal);
  String currentLang = "";

  Widget build(BuildContext context) {
    UserModel _userInfo = AuthProvider.of(context).userModel;
    lang? _mitem;
    switch (_userInfo.app_lang) {
      case "en_GB":
        _mitem = lang.en_GB;
        break;

      case "de_CH":
        _mitem = lang.de_CH;
        break;

      case "nl_NL":
        _mitem = lang.nl_NL;
        break;
      default:
        SmartDialog.showToast(
          LocalText.NetError,
          alignment: Alignment.topCenter,
        );
    }

    return Container(
      decoration: const BoxDecoration(
        color: bgColor,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientFrom, bgColor]),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Accordion(
              contentVerticalPadding: 0,
              contentHorizontalPadding: 0,
              paddingListTop: 150,
              maxOpenSections: 1,
              headerBackgroundColorOpened: Colors.black54,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              children: [
                AccordionSection(
                  isOpen: false,
                  leftIcon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30,
                  ),
                  headerBackgroundColor: Colors.transparent,
                  // headerBackgroundColorOpened: Colors.red,
                  header: Text(
                      LocalText.language[_userInfo.app_lang].toString(),
                      style: _headerStyle),

                  content: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(color: bgColor),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          minVerticalPadding: 0,
                          title: const Text(
                            'Germany',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Radio<lang>(
                            activeColor: Colors.black,
                            value: lang.de_CH,
                            groupValue: _mitem,
                            onChanged: (lang? value) {
                              saveLang(value, context);
                              setState(() {
                                _mitem = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'English',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Radio<lang>(
                            value: lang.en_GB,
                            activeColor: Colors.black,
                            groupValue: _mitem,
                            onChanged: (lang? value) {
                              saveLang(value, context);
                              setState(() {
                                _mitem = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Detch',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Radio<lang>(
                            activeColor: Colors.black,
                            value: lang.nl_NL,
                            groupValue: _mitem,
                            onChanged: (lang? value) {
                              saveLang(value, context);
                              setState(() {
                                _mitem = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(),
                  ),
                ),
              },
              child: Image.asset(
                'assets/images/icon-close.png',
                scale: 11,
              ),
            ),
          ),
          // SecondaryButton(context)
        ],
      ),
    );
  }
}
