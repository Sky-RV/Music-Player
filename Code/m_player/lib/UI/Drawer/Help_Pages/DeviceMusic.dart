import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:m_player/Utils/MyColors.dart';

class DeviceMusicHelp extends StatefulWidget {
  const DeviceMusicHelp({Key? key}) : super(key: key);

  @override
  State<DeviceMusicHelp> createState() => _DeviceMusicHelpState();
}

class _DeviceMusicHelpState extends State<DeviceMusicHelp> {
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
            'assets/images/Device/1.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Device/2.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Device/3.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Device/4.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Device/5.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Device/6.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
