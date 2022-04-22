// ignore_for_file: sized_box_for_whitespace, prefer_final_fields

import 'package:Fuligo/screens/achievement/credits.dart';
import 'package:Fuligo/screens/achievement/ranking.dart';
import 'package:Fuligo/utils/localtext.dart';
import 'package:intl/intl.dart';

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/repositories/user_repository.dart';
import 'package:Fuligo/screens/achievement/achievement_detail.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';

import 'package:Fuligo/widgets/subtxt.dart';
import 'package:Fuligo/widgets/fuligo_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:Fuligo/screens/tours.dart';

class Achievements extends StatefulWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  ArchivmentsState createState() => ArchivmentsState();
}

class ArchivmentsState extends State<Achievements> {
  List allData = [];
  bool loading = true;
  late num user_credit;
  late num user_achieve;
  List<QueryDocumentSnapshot> docLists = [];
  List userAchievements = [];
  List<Widget> widgets = [];
  List<Map> achieveLists = [];

  @override
  void initState() {
    super.initState();
    user_credit = 0;
    user_achieve = 0;
    getData();
  }

  Future<bool> getData() async {
    UserModel _userInfo = AuthProvider.of(context).userModel;
    CollectionReference achievements =
        FirebaseFirestore.instance.collection('achievement');
    // final prefs = await SharedPreferences.getInstance();
    // String lang = prefs.getString('lang') ?? "en_GB";

    final result = await UserRepository.getUserByID(_userInfo.uid);

    userAchievements =
        result['achievement']; // get achievement in User collection

    achievements.get().then((QuerySnapshot querySnapshot) {
      docLists = querySnapshot.docs;
      if (docLists.isNotEmpty) {
        for (var element in docLists) {
          String updatedAt =
              DateFormat('dd-MM-yyyy').format((element['updatedAt'].toDate()));

          if (userAchievements.toString().contains(element.reference.id)) {
            user_credit += element["credits"];
            user_achieve++;

            Map temp = {
              "isDone": true,
              "active": element['active'],
              "name": element['name'][_userInfo.app_lang],
              "description": element['description'][_userInfo.app_lang],
              "credits": element['credits'],
              "updatedAt": updatedAt
            };
            achieveLists.add(temp);
          } else {
            Map temp = {
              "isDone": false,
              "active": element['active'],
              "name": element['name'][_userInfo.app_lang],
              "description": element['description'][_userInfo.app_lang],
              "credits": element['credits'],
              "updatedAt": updatedAt
            };
            achieveLists.add(temp);
          }
          loading = false;
        }
      } else {
        loading = false;
      }
      //get achievement in Achievement collection

      setState(() {});
    });

    return loading;
  }

  List<Widget> getArchivementsItem(List<Map> newList) {
    List<Widget> cardlist = [];
    for (var i = 0; i < newList.length; i++) {
      if (newList[i]['isDone']) {
        cardlist.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AchievementsDetail(data: newList[i]),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: FuligoCard(
                  context, newList[i]["name"].toString(), whiteColor),
            ),
          ),
        );
      } else {
        cardlist.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => AchievementsDetail(data: newList[i]),
                  builder: (context) => AchievementsDetail(data: newList[i]),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child:
                  FuligoCard(context, newList[i]["name"].toString(), greyColor),
            ),
          ),
        );
      }
    }
    return cardlist;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    UserModel _userInfo = AuthProvider.of(context).userModel;

    return Builder(builder: (context) {
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
                      height: mq.height * 0.17,
                    ),
                    PageHeader(
                      context,
                      LocalText.achievements_menu[_userInfo.app_lang]
                          .toString(),
                      LocalText.achievements_description[_userInfo.app_lang]
                          .toString(),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Ranking(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 55),
                                  child: SubTxt(
                                      context,
                                      LocalText
                                          .achievements_menu[_userInfo.app_lang]
                                          .toString(),
                                      '$user_achieve of ${docLists.length}'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Credits(achieveLists: achieveLists),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 55),
                                  child: SubTxt(
                                      context,
                                      LocalText.credit[_userInfo.app_lang]
                                          .toString(),
                                      '$user_credit CHF'),
                                ),
                              )
                            ],
                          ),
                        ),
                        !loading
                            ? achieveLists.isNotEmpty
                                ? Container(
                                    width: mq.width,
                                    height: mq.height * 0.5,
                                    // decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     borderRadius:
                                    //         BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: GridView.count(
                                      padding: const EdgeInsets.all(0),
                                      crossAxisCount: 2,
                                      children:
                                          getArchivementsItem(achieveLists),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: mq.height * 0.2,
                                      ),
                                      Text(
                                        "No order data",
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white30),
                                      ),
                                    ],
                                  )
                            : Container(
                                child: SizedBox(
                                  height: mq.height * 0.3,
                                  child: kRingWidget(context),
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
              SecondaryButton(context),
            ],
          ),
        ),
      );
    });
  }
}
