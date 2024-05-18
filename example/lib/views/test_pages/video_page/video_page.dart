import 'dart:io';

import 'package:download_manager_example/views/test_pages/video_page/players/better_player.dart';
import 'package:download_manager_example/views/test_pages/video_page/players/media_kit_player.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({
    super.key,
    required this.master,
  });

  final File master;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Widget player;

  var currentTab = 0;

  @override
  void initState() {
    player = LocalMediaKitPlayer(
      file: widget.master,
    );
    super.initState();
  }

  void onSelectBar(int index) {
    setState(
      () {
        currentTab = index;
        switch (index) {
          case 0:
            if (player is! LocalMediaKitPlayer) {
              player = LocalMediaKitPlayer(
                file: widget.master,
              );
            }
            break;
          case 1:
            // if (player is! LocalChewiePlayer) {
            //   player = LocalChewiePlayer(
            //     file: widget.master,
            //   );
            // }
            break;
          case 2:
            if (player is! LocalBetterPlayer) {
              player = LocalBetterPlayer(
                file: widget.master,
              );
            }
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: player,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: onSelectBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.looks_one_sharp,
            ),
            label: 'Media Kit',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.looks_two_sharp,
          //   ),
          //   label: 'Chewie',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.looks_3_sharp,
            ),
            label: 'Better Player',
          ),
        ],
      ),
    );
  }
}
