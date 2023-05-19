import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:m_player/Utils/MyColors.dart';

class AlbumMusicHelp extends StatefulWidget {
  const AlbumMusicHelp({Key? key}) : super(key: key);

  @override
  State<AlbumMusicHelp> createState() => _AlbumMusicHelpState();
}

class _AlbumMusicHelpState extends State<AlbumMusicHelp> {
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
            'assets/images/Album/1.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Album/2.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Album/3.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
