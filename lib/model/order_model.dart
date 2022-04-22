import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OrderModel {
  String name;
  String orderId;
  String image;
  DateTime datetime = DateTime.now();
  // List<Reference>? archievement;

  OrderModel({
    this.orderId = '',
    this.name = "",
    this.image = "",
    DateTime? dateTime,
    // this.archievement,
  });

  OrderModel.fromJson(Map json)
      : orderId = (json['orderId'] != null) ? json['orderId'] : "",
        name = (json['name'] != null) ? json['name'] : "",
        image = (json['image'] != null) ? json['image'] : "",
        datetime = (json['datetime'] != null) ? json['datetime'] : "";

  Map<String, dynamic> toJson() {
    return {
      "orderId": (name == null) ? "" : orderId,
      "name": (name == null) ? "" : name,
      "image": (image == null) ? "" : image,
      "datetime": (datetime == null) ? "" : datetime,
      // "archievement": (archievement == null) ? [] : convertList(archievement!),
    };
  }

  List convertList(List<Reference> list) {
    return list.map((item) {
      return {
        item,
      };
    }).toList();
  }
}
