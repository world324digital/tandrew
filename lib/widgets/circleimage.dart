import 'dart:typed_data';

import 'package:Fuligo/screens/avatar_screen.dart';
import 'package:Fuligo/screens/video/audio.dart';
import 'package:Fuligo/screens/video/info.dart';
import 'package:Fuligo/screens/video/video.dart';
import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/utils/common_functions.dart';
import 'package:Fuligo/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: non_constant_identifier_names
Widget CircleImage(
        context, String url, double height, double width, String str) =>
    Container(
      height: height,
      width: width,
      margin: (str != "ranking") ? EdgeInsets.all(20) : EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
          switch (str) {
            case "avatar":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AvatarScreen(),
                ),
              );
              break;
            case "tour":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Info(
                    infodata: {},
                  ),
                ),
              );
              break;
            case "avatars":
              showConfirm(context, "avatar", url, "");
          }
        },
        child: ClipOval(
          child: Image.network(
            url,
            height: height,
            width: width,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: kLoadingFadingWidget(context),
              );
            },
          ),
        ),
      ),
    );
// ignore: non_constant_identifier_names
Widget AvatarMenu(context, String url, String id, double height, double width,
        bool is_me) =>
    Stack(
      children: [
        Container(
          height: height,
          width: width,
          margin: EdgeInsets.all(20),
          child: InkWell(
            onTap: () {
              showConfirm(context, "avatar", url, id);
            },
            child: ClipOval(
              child: Container(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: url,
                ),
              ),

              // child: Image.network(
              //   url,
              //   height: height,
              //   width: width,
              //   loadingBuilder: (BuildContext context, Widget child,
              //       ImageChunkEvent? loadingProgress) {
              //     if (loadingProgress == null) {
              //       return child;
              //     }
              //     return Center(
              //       child: kLoadingFadingWidget(context),
              //     );
              //   },
              // ),
            ),
          ),
        ),
        is_me
            ? Positioned(
                top: 25,
                right: 35,
                child: Icon(
                  Icons.check_circle,
                  color: whiteColor,
                  size: 16.0,
                ),
              )
            : Text(""),
      ],
    );

// Future<void> getMedia(context, id) async {
//   var collection = FirebaseFirestore.instance.collection('pointOfInterest');
//   var mediadata = await collection.doc(id).get();
//   if (mediadata.exists) {
//     List videoUrl = [];
//     try {
//       videoUrl = mediadata.get("video");
//     } catch (e) {
//       videoUrl = [];
//     }
//     if (videoUrl.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Video(
//             id: id,
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Audio(
//             id: id,
//           ),
//         ),
//       );
//     }
//   }
// }

// ignore: non_constant_identifier_names
Widget CircleVideoMapImage(context, String id, Uint8List image) => Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          print("video");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Video(
                id: id,
              ),
            ),
          );
        },
        child: ClipOval(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: whiteColor),
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: MemoryImage(image, scale: 0.5),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
// ignore: non_constant_identifier_names
Widget CircleAudioMapImage(context, String id, Uint8List image) => Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          print("audio");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Audio(id: id),
            ),
          );
        },
        child: Container(
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: whiteColor),
                borderRadius: BorderRadius.circular(50),
                image: new DecorationImage(
                  image: MemoryImage(image, scale: 0.5),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );

// ignore: non_constant_identifier_names
// Widget CircleVideoImage(context, Map item, Uint8List image) => Container(
//       margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Video(id: item["id"]),
//             ),
//           );
//         },
//         child: Container(
//           child: ClipOval(
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 1, color: whiteColor),
//                 borderRadius: BorderRadius.circular(50),
//                 image: new DecorationImage(
//                   image: MemoryImage(image, scale: 0.5),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
// ignore: non_constant_identifier_names
// Widget CircleAudioImage(context, Map item, Uint8List image) => Container(
//       margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Audio(id: item["id"]),
//             ),
//           );
//         },
//         child: Container(
//           child: ClipOval(
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 1, color: whiteColor),
//                 borderRadius: BorderRadius.circular(50),
//                 image: new DecorationImage(
//                   image: MemoryImage(image, scale: 0.5),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               // decoration: BoxDecoration(
//               //   border: Border.all(width: 3, color: whiteColor),
//               //   borderRadius: BorderRadius.circular(50),
//               // ),
//               // child: Image.network(
//               //   item["image"][0],
//               //   width: 100,
//               //   height: 100,
//               //   fit: BoxFit.fill,
//               //   loadingBuilder: (BuildContext context, Widget child,
//               //       ImageChunkEvent? loadingProgress) {
//               //     if (loadingProgress == null) {
//               //       return child;
//               //     }
//               //     return Center(
//               //       child: kLoadingFadingWidget(context),
//               //     );
//               //   },
//               // ),
//             ),
//           ),
//         ),
//       ),
//     );
