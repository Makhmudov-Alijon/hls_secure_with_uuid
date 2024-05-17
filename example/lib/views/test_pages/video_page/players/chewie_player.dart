// import 'dart:async';
// import 'dart:io';

// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class LocalChewiePlayer extends StatefulWidget {
//   const LocalChewiePlayer({super.key, required this.file});

//   final File file;

//   @override
//   State<LocalChewiePlayer> createState() => _LocalChewiePlayerState();
// }

// class _LocalChewiePlayerState extends State<LocalChewiePlayer> {
//   ChewieController? chewieVideoController;
//   late VideoPlayerController videoController;

//   Future<void> initializePlayer() async {
//     videoController = VideoPlayerController.file(
//       widget.file,
//     );
//     await videoController.initialize();
//     setState(() {
//       chewieVideoController = ChewieController(
//         videoPlayerController: videoController,
//         autoInitialize: true,
//         autoPlay: true,
//       );
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     initializePlayer();
//   }

//   @override
//   void dispose() {
//     videoController.dispose();
//     chewieVideoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return chewieVideoController == null
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : Chewie(
//             controller: chewieVideoController!,
//           );
//   }
// }
