import 'dart:io';

import 'package:flutter/material.dart';
import 'package:river_player/river_player.dart';

class LocalBetterPlayer extends StatefulWidget {
  const LocalBetterPlayer({super.key, required this.file});

  final File file;

  @override
  State<LocalBetterPlayer> createState() => _LocalBetterPlayerState();
}

class _LocalBetterPlayerState extends State<LocalBetterPlayer> {
  late BetterPlayerController betterPlayerController;

  @override
  void initState() {
    betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
      ),
      betterPlayerDataSource: BetterPlayerDataSource.file(widget.file.path),
    );
    super.initState();
  }

  @override
  void dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(
      controller: betterPlayerController,
    );
  }
}
