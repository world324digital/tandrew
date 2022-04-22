// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class StackedVideoViewModel extends BaseViewModel {
//   // Input Properties
//   late VideoPlayerController videoPlayerController;
//   late bool showFull;
//   late double x; // X alignment of FittedBox
//   late double y; // Y alignment of FittedBox

//   // Local Properties
//   bool gotThumbnailSize = false;
//   double thumbnailWidth = 300;
//   double thumbnailHeight = 200;

//   /// Keys
//   GlobalKey thumbnailKey = GlobalObjectKey('video_thumbnail');

//   void initialize(String videoUrl, bool full, double inx, double iny) {
//     showFull = full;
//     x = inx;
//     y = iny;

//     videoPlayerController = VideoPlayerController.network(videoUrl);
//     videoPlayerController.initialize().then((value) {
//       videoPlayerController.setLooping(true);
//       notifyListeners();
//     });
//   }

//   void playVideo() {
//     videoPlayerController.play();
//     notifyListeners();
//   }

//   void pauseVideo() {
//     videoPlayerController.pause();
//     notifyListeners();
//   }

//   void getVideoSize() {
//     /// (4) Get the RenderBox from the GlobalObjectKey and extract it's size
//     RenderBox render =
//         thumbnailKey.currentContext.findRenderObject() as RenderBox;

//     thumbnailWidth = render.size.width;
//     thumbnailHeight = render.size.height;

//     gotThumbnailSize = true;

//     /// (5) Update the Views
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     videoPlayerController.dispose();
//     super.dispose();
//   }
// }
