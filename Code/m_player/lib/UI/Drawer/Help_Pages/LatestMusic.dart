import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:m_player/Utils/MyColors.dart';


class LatestMusicHelp extends StatefulWidget {
  const LatestMusicHelp({Key? key}) : super(key: key);

  @override
  State<LatestMusicHelp> createState() => _LatestMusicHelpState();
}

class _LatestMusicHelpState extends State<LatestMusicHelp> {
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
            'assets/images/LatestMusic/1.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/LatestMusic/2.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/LatestMusic/3.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
