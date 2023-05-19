import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:m_player/Utils/MyColors.dart';

class PlaylistMusicHelp extends StatefulWidget {
  const PlaylistMusicHelp({Key? key}) : super(key: key);

  @override
  State<PlaylistMusicHelp> createState() => _PlaylistMusicHelpState();
}

class _PlaylistMusicHelpState extends State<PlaylistMusicHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageSlideshow(
        width: double.infinity,
        height: double.infinity,
        initialPage: 0,
        indicatorColor: myColors.yellow,
        autoPlayInterval: 3000,
        isLoop: true,
        children: [
          Image.asset(
            'assets/images/PlaylistOnline/1.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/2.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/3.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/4.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/5.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/6.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/7.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/8.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/PlaylistOnline/9.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
