import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:m_player/Utils/MyColors.dart';

class OnlineWebsiteHelp extends StatefulWidget {
  const OnlineWebsiteHelp({Key? key}) : super(key: key);

  @override
  State<OnlineWebsiteHelp> createState() => _OnlineWebsiteHelpState();
}

class _OnlineWebsiteHelpState extends State<OnlineWebsiteHelp> {
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
            'assets/images/WebSite/1.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/WebSite/2.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/WebSite/3.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/WebSite/4.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/WebSite/5.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
