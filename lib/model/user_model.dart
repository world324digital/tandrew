import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/retry.dart';

class UserModel {
  String uid;
  Map username = {};

  String avatar;
  String email;
  String app_lang;
  // List<Reference>? archievement;

  UserModel({
    this.uid = "",
    required this.username,
    this.avatar = "",
    this.email = "",
    this.app_lang = "en_GB",
    // this.archievement,
  });

  UserModel.fromJson(Map json)
      : uid = (json['uid'] != null) ? json['uid'] : "",
        username = (json['name'] != null)
            ? json['name']
            : {"first": "Anonymous", "last": "User"},
        avatar = (json['avatar'] != null) ? json['avatar'] : "",
        email = (json['email'] != null) ? json['email'] : "",
        app_lang = (json['app_lang'] != null) ? json['app_lang'] : "en_GB";

  // Map<String, dynamic> toJson() {
  //   return {
  //     "uid": (uid == null) ? "" : uid,
  //     "name": (username == null)
  //         ? {"first": "Anonymous", "last": "User"}
  //         : username,
  //     "avatar": (avatar == null) ? "" : avatar,
  //     "email": (email == null) ? "" : email,
  //     // "archievement": (archievement == null) ? [] : convertList(archievement!),
  //   };
  // }

  List convertList(List<Reference> list) {
    return list.map((item) {
      return {
        item,
      };
    }).toList();
  }

  void getAvatarUrl(DocumentReference ref) async {
    ref.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        //get image url from firebase storage
        Reference ref =
            FirebaseStorage.instance.ref().child(documentSnapshot.get('img'));

        String url = await ref.getDownloadURL();

        print("imgdefaulturl");
        print(url);
        return url;
      }
    });
  }
}
