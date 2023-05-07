import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Models/Music/Music_Model.dart';

class Play_Album_Music extends StatefulWidget {
  const Play_Album_Music({Key? key, required this.music_model, required this.audioPlayer, required this.list}) : super(key: key);

  final Music_Model music_model;
  final AudioPlayer audioPlayer;
  final List<Music_Model> list;

  @override
  State<Play_Album_Music> createState() => _Play_Album_MusicState();
}

class _Play_Album_MusicState extends State<Play_Album_Music> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
