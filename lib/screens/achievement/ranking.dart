// ignore_for_file: sized_box_for_whitespace

import 'dart:typed_data';

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

// import 'package:Fuligo/screens/tours.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  RankingState createState() => RankingState();
}

class RankingState extends State<Ranking> {
  void initState() {
    super.initState();
    getData();
  }

  bool loading = true;
  List<Map> _users = [];
  List imageList = [];

  Future<void> getData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users.get().then((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        for (var user in querySnapshot.docs) {
          final prefs = await SharedPreferences.getInstance();
          int achievementNum = 0;
          String name = "Anonymous User";
          Map _userdata = user.data() as Map<String, dynamic>;
          String avatar = "";

          if (_userdata.containsKey("avatar")) {
            print("is avatar");
            var refId = user.get("avatar");

            await refId.get().then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                avatar = documentSnapshot["app_img"];
              }
            });
          } else {
            String defaultavatar = prefs.getString('defaultAvatar') ?? "";
            avatar = defaultavatar;
          }

          if (_userdata.containsKey("achievement")) {
            achievementNum = _userdata["achievement"].length;
          }

          if (_userdata.containsKey("name")) {
            name = _userdata["name"]["first"].toString() +
                " " +
                _userdata["name"]["last"].toString();
          }

          _users.add({
            "avatar": avatar,
            "name": name,
            "num": achievementNum,
            "uid": _userdata["uid"]
          });
        }

        loading = false;

        setState(() {});
      } else {}
    });
  }

  Future<String> getDownImageUrl(location) async {
    Reference ref = FirebaseStorage.instance.ref().child(location);
    String url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> usersRanking = [];
    var mq = MediaQuery.of(context).size;

    _users.sort((a, b) => b["num"].compareTo(a["num"]));

    UserModel _userInfo = AuthProvider.of(context).userModel;
    if (_users.isNotEmpty) {
      for (var i = 0; i < _users.length; i++) {
        var item = _users[i];
        usersRanking.add(
          Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: _userInfo.uid != item["uid"]
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: bgDecorationColor.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset:
                            const Offset(1, 0), // changes position of shadow
                      ),
                    ],
                    color: bgDecorationColor,
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [gradientFrom1, bgColor]),
                    borderRadius: BorderRadius.circular(20.0),
                  )
                : BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: bgDecorationColor.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset:
                            const Offset(1, 0), // changes position of shadow
                      ),
                    ],
                    color: bgDecorationColor,
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [gradientFrom, bgColor]),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              // leading: CircleImage(context, imageList[i], 80, 80, "ranking"),
              leading: Container(
                child: InkWell(
                  onTap: () {},
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: item["avatar"],
                  ),
                ),
              ),
              title: Text(
                item["name"],
                style: TextStyle(
                    color: _userInfo.uid != item["uid"]
                        ? Colors.white38
                        : whiteColor,
                    fontSize: 16),
              ),
              // trailing: CircleImage(context, item["avatar"], 80, 80, "ranking"),
              trailing: Stack(
                children: [
                  Image.asset(
                    "assets/images/icon-medal.png",
                    color: _userInfo.uid != item["uid"]
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white,
                    colorBlendMode: BlendMode.modulate,
                    scale: 0.1,
                  ),
                  Positioned(
                    top: 27,
                    left: 18,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                          color: _userInfo.uid != item["uid"]
                              ? Colors.white38
                              : Colors.white,
                          fontSize: 20),
                    ),
                  )
                ],
              ),

              subtitle: Text(
                item["num"].toString() +
                    '  ${LocalText.achievements_menu[_userInfo.app_lang]}',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
              onTap: () => {
                // Navigator.pushNamed(context, RouteName.Startour),
              },
            ),
          ),
        );
      }
    } else {
      usersRanking.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: mq.height * 0.2,
          ),
          Text(
            "No User data",
            style: TextStyle(fontSize: 30, color: Colors.white30),
          ),
        ],
      ));
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
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                  PageHeader(
                    context,
                    LocalText.ranking_title[_userInfo.app_lang].toString(),
                    LocalText.ranking_description[_userInfo.app_lang]
                        .toString(),
                  ),
                  !loading
                      ? Container(
                          // decoration: BoxDecoration(color: whiteColor),
                          height: mq.height - 210,
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                          child: Scrollbar(
                            child: ListView(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              children: usersRanking,
                            ),
                          ),
                        )
                      : Container(
                          child: SizedBox(
                            height: mq.height * 0.4,
                            child: kRingWidget(context),
                          ),
                        )
                ],
              ),
            ),
            SecondaryButton(context)
          ],
        ),
      ),
    );
  }
}
