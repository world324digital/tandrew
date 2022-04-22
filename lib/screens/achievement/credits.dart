// ignore_for_file: sized_box_for_whitespace

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/repositories/user_repository.dart';
import 'package:Fuligo/utils/font_style.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';

import 'package:Fuligo/widgets/subtxt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Credits extends StatefulWidget {
  List<Map> achieveLists;
  Credits({Key? key, required this.achieveLists}) : super(key: key);

  @override
  CreditsState createState() => CreditsState();
}

class CreditsState extends State<Credits> {
  void initState() {
    super.initState();
    List<Map> archList = widget.achieveLists;

    getCreditsData(archList);
  }

  int availabelCredits = 0;
  int usedCredits = 0;
  int deductedPrice = 0;
  bool loading = true;
  List<Map> creditsLists = [];

  Future<int> getCreditsData(List<Map> archList) async {
    List orderlist = [];
    List deductedlist = [];
    UserModel _userInfo = AuthProvider.of(context).userModel;
    // final prefs = await SharedPreferences.getInstance();
    // String lang = prefs.getString('lang') ?? "";
    QuerySnapshot orderSnapshot =
        await FirebaseFirestore.instance.collection('order').get();

    orderSnapshot.docs
        .map(
          // vVBdd7pUdjZY537PX6pT8FNCrA52 is _userInfo.userId
          (doc) => {
            if (doc.get('userId') == _userInfo.uid &&
                doc.get('deductedPrice') > 0)
              {
                deductedPrice = doc.get('deductedPrice'),
                usedCredits += deductedPrice,
                orderlist.add(doc.get('city')),
                deductedlist.add(doc.get('deductedPrice')),
              }
          },
        )
        .toList();
    if (archList.isNotEmpty) {
      for (var item in archList) {
        if (item["isDone"] == true) {
          String name = item["name"];
          // String image = documentSnapshot.get('image')[0];
          String datetime = item["updatedAt"].toString();
          Map test = {
            "name": name,
            "updatedAt": datetime,
            "credits": item["credits"],
            "flag": "arch",
          };
          creditsLists.add(test);
        }
      }
    }
    if (orderlist.isNotEmpty) {
      // for (var referId in orderlist) {
      for (var i = 0; i < orderlist.length; i++) {
        var referId = orderlist[i];
        // Get data from DocumentReference in firebase flutter
        referId.get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            print('Document exists on the database');

            String name = documentSnapshot.get('name')[_userInfo.app_lang];

            String datetime = DateFormat('dd-MM-yyyy')
                .format(documentSnapshot.get('updatedAt').toDate());

            Map test = {
              "name": name,
              "updatedAt": datetime,
              "credits": deductedlist[i],
              "flag": "order",
            };

            creditsLists.add(test);
            creditsLists
                .sort((a, b) => a["updatedAt"].compareTo(b["updatedAt"]));

            loading = false;
            setState(() {});
          }
        });
      }
    }
    loading = false;

    /// get available credits
    final result = await UserRepository.getUserByID(_userInfo.uid);
    if (result["credits"] == null) {
      availabelCredits = 0;
    } else {
      availabelCredits = result["credits"];
    }

    setState(() {});
    return availabelCredits;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    UserModel _userInfo = AuthProvider.of(context).userModel;

    List<Widget> creditData = [];

    for (var item in creditsLists) {
      String date = item["updatedAt"].toString();
      creditData.add(
        Container(
          margin: EdgeInsets.only(bottom: 20),
          // decoration: BoxDecoration(
          //   color: bgColor,
          //   gradient: const LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [gradientFrom, bgColor]),
          //   borderRadius: BorderRadius.circular(15.0),
          // ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,

                offset: const Offset(1, 0), // changes position of shadow
              ),
            ],
            color: bgColor,
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradientFrom, bgColor]),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            leading: item["flag"] == "order"
                ? Image.asset("assets/images/icon-booking.png")
                : Image.asset("assets/images/icon-achievement.png"),
            title: Text(item["name"], style: font_14_white_70),
            subtitle: Text(
              item["flag"] == "order"
                  ? date + " | -" + item["credits"].toString() + " CHF"
                  : date + " | " + item["credits"].toString() + " CHF",
              style: font_14_grey,
            ),
            onTap: () => {
              // Navigator.pushNamed(context, RouteName.Startour),
              print("object"),
            },
          ),
        ),
      );
    }
    return Container(
      decoration: bgDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text('TEST'),
        // ),
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
                    LocalText.credit[_userInfo.app_lang].toString(),
                    LocalText.credit_description[_userInfo.app_lang].toString(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: SubTxt(
                              context,
                              LocalText.available[_userInfo.app_lang]
                                  .toString(),
                              " CHF " + availabelCredits.toString()),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: SubTxt(
                              context,
                              LocalText.used[_userInfo.app_lang].toString(),
                              " CHF " + usedCredits.toString()),
                        ),
                      ],
                    ),
                  ),
                  !loading
                      ? creditData.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(children: creditData))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: mq.height * 0.1,
                                ),
                                Text(
                                  "No order data",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white30),
                                ),
                              ],
                            )
                      : Container(
                          margin: EdgeInsets.only(top: mq.height * 0.1),
                          child: kRingWidget(context),
                        )
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.clear,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
