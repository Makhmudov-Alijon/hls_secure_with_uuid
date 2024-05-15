import 'dart:io';

import 'package:flutter/material.dart';
import 'package:theoplayer/theoplayer.dart';

class LocalTheoPlayer extends StatefulWidget {
  const LocalTheoPlayer({
    super.key,
    required this.file,
  });

  final File file;

  @override
  State<LocalTheoPlayer> createState() => _LocalTheoPlayerState();
}

class _LocalTheoPlayerState extends State<LocalTheoPlayer> {
  late THEOplayer player;

  bool isPrepared = false;

  @override
  void initState() {
    player = THEOplayer(
      theoPlayerConfig: THEOplayerConfig(),
      onCreate: () {
        player.setSource(
          SourceDescription(
            sources: [
              TypedSource(
                src: 'file:///${widget.file.path}',
              ),
            ],
          ),
        );
        setState(() {
          isPrepared = true;
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isPrepared
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : player.getView();
  }
}
