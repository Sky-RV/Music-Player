import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:m_player/Utils/MyColors.dart';

class ArtistMusicHelp extends StatefulWidget {
  const ArtistMusicHelp({Key? key}) : super(key: key);

  @override
  State<ArtistMusicHelp> createState() => _ArtistMusicHelpState();
}

class _ArtistMusicHelpState extends State<ArtistMusicHelp> {
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
            'assets/images/Artist/1.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Artist/2.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Artist/3.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
