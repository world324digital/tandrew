import 'package:firebase_storage/firebase_storage.dart';

class InterestModel {
  String name;
  String description;
  String image;

  // List<Reference>? archievement;

  InterestModel({
    this.description = '',
    this.name = "",
    this.image = "",

    // this.archievement,
  });

  InterestModel.fromJson(Map json)
      : description = (json['description'] != null) ? json['description'] : "",
        name = (json['name'] != null) ? json['name'] : "",
        image = (json['image'] != null) ? json['image'] : "";

  Map<String, dynamic> toJson() {
    return {
      "description": (name == null) ? "" : description,
      "name": (name == null) ? "" : name,
      "image": (image == null) ? "" : image,

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
