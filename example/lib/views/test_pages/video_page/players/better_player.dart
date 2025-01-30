import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:splay_tv_player/splay_tv_player.dart';

class LocalBetterPlayer extends StatefulWidget {
  const LocalBetterPlayer({super.key, required this.file});

  final File file;

  @override
  State<LocalBetterPlayer> createState() => _LocalBetterPlayerState();
}

class _LocalBetterPlayerState extends State<LocalBetterPlayer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
