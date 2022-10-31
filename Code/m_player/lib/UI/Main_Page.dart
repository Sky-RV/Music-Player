import 'package:flutter/material.dart';
import 'package:m_player/Tools/Utils.dart';
import 'package:m_player/UI/Downloads_Page.dart';
import 'package:m_player/UI/Home_Page.dart';
import 'package:m_player/UI/Playlist_Page.dart';
import 'package:m_player/UI/Search_Page.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {

  int _currentIndex = 0;

  final Pages = [
    const Home_Page(),
    const Search_Page(),
    const Playlist_Page(),
    const Downloads_Page(),
    const Search_Page()
  ];

  void _updateIndex(int value){
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      ///////////////////////// APP BAR /////////////////////////

      appBar: AppBar(
        backgroundColor: myColors.white,
        title: Text(
          "M Player",
          style: TextStyle(
            color: myColors.darkGreen
          ),
        ),
      ),

      ///////////////////////// BODY /////////////////////////

      body: Pages[_currentIndex],

      ///////////////////////// BACKGROUND /////////////////////////

      backgroundColor: myColors.white,

      ///////////////////////// BOTTOM NAVIGATION BAT /////////////////////////

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: myColors.white,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        selectedItemColor: myColors.green,
        unselectedItemColor: Colors.black26,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home)
          ),

          BottomNavigationBarItem(
              label: "Search",
              icon: Icon(Icons.search)
          ),

          BottomNavigationBarItem(
              label: "Playlist",
              icon: Icon(Icons.playlist_play_rounded)
          ),

          BottomNavigationBarItem(
              label: "Download",
              icon: Icon(Icons.download)
          ),

          BottomNavigationBarItem(
              label: "Setting",
              icon: Icon(Icons.settings)
          )
        ],
      ),


    );
  }
}
