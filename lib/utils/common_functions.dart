import 'dart:convert';

import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/screens/menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getTitle(pageName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String headerList = prefs.getString('headerlist').toString();
  var header = jsonDecode(headerList)![pageName];
  var title = header['title'];
  var subtitle = header['subtitle'];
  List<String> a = [title, subtitle];

  return a;
}

Future<void> showConfirm(
    BuildContext context, String str, String url, String id) async {
  showDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title:
          str == "tracking" ? Text("Enable tracking?") : Text("Change avatar?"),
      content: Text("Are you really?"),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Cancel"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            // Navigator.pop(context);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MenuScreen(),
            //   ),
            // );
          },
        ),
        BasicDialogAction(
          title: Text("Confirm"),
          onPressed: () {
            str == "tracking" ? tracking() : changeAvatar(context, url, id);
          },
        ),
      ],
    ),
  );
}

changeAvatar(BuildContext context, String url, String doc_id) {
  Navigator.of(context, rootNavigator: true).pop('dialog');
  UserModel _userInfo = AuthProvider.of(context).userModel;
  _userInfo.avatar = url;

  AuthProvider.of(context).setUserModel(_userInfo);
  // Navigator.of(context).pop();
  try {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('avatar').doc(doc_id);
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userInfo.uid)
        .set({'avatar': ref}, SetOptions(merge: true));
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuScreen(),
      ),
    );

    SmartDialog.showToast("change success");
  } catch (e) {
    SmartDialog.showToast("failed");
  }

  // SmartDialog.dismiss();
}

tracking() {
  print("click evnet");
}
