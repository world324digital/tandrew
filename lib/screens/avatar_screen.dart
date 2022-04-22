// ignore_for_file: sized_box_for_whitespace

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/screens/menu_screen.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/widgets/circleimage.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({Key? key}) : super(key: key);

  @override
  AvatarScreenState createState() => AvatarScreenState();
}

class AvatarScreenState extends State<AvatarScreen> {
  @override
  List<Map> avatars = [];

  bool loading = true;
  void initState() {
    getAvatars();
    super.initState();
  }

  Future<void> getAvatars() async {
    QuerySnapshot orderSnapshot =
        await FirebaseFirestore.instance.collection('avatar').get();

    Map temp;
    if (orderSnapshot.docs.isNotEmpty) {
      for (var item in orderSnapshot.docs) {
        temp = {
          "id": item.id,
          "app_img": item["app_img"],
          "isDefault": item["isDefault"],
        };
        avatars.add(temp);
      }

      loading = false;
    }
    setState(() {
      avatars = avatars;
      loading = loading;
    });
  }

  Widget build(BuildContext context) {
    UserModel _userInfo = AuthProvider.of(context).userModel;
    List<Widget> avatarList = [];
    for (var i = 0; i < avatars.length; i++) {
      var item = avatars[i];
      if (_userInfo.avatar == item["app_img"]) {
        avatarList.add(
            AvatarMenu(context, item["app_img"], item["id"], 200, 200, true));
      } else {
        avatarList.add(
            AvatarMenu(context, item["app_img"], item["id"], 200, 200, false));
      }
    }

    var mq = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: bgColor,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientFrom, bgColor]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 0, left: 0),
              // width: 400,
              // height: mq.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  PageHeader(
                    context,
                    "Avatar",
                    "Choose your avatar",
                  ),
                  !loading && avatars.isNotEmpty
                      ? Container(
                          width: mq.width,
                          height: mq.height * 0.7,
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: GridView.count(
                              padding: const EdgeInsets.all(60),
                              crossAxisCount: 2,
                              children: avatarList),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: mq.height * 0.3),
                          child: kRingWidget(context),
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
