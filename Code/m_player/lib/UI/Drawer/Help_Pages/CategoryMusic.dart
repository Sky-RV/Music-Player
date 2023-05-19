import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:m_player/Utils/MyColors.dart';

class CategoryMusicHelp extends StatefulWidget {
  const CategoryMusicHelp({Key? key}) : super(key: key);

  @override
  State<CategoryMusicHelp> createState() => _CategoryMusicHelpState();
}

class _CategoryMusicHelpState extends State<CategoryMusicHelp> {
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
            'assets/images/Category/1.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Category/2.png',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Category/3.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
