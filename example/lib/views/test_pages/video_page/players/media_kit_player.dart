import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class LocalMediaKitPlayer extends StatefulWidget {
  const LocalMediaKitPlayer({
    super.key,
    required this.file,
  });

  final File file;

  @override
  State<LocalMediaKitPlayer> createState() => _LocalMediaKitPlayerState();
}

class _LocalMediaKitPlayerState extends State<LocalMediaKitPlayer> {
  late final Player player;

  late final VideoController videoController;

  @override
  void initState() {
    player = Player();
    videoController = VideoController(
      player,
      configuration: const VideoControllerConfiguration(),
    );
    player.open(Media('file://${widget.file.path}'));
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: videoController,
    );
  }
}
