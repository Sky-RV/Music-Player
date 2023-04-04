import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:m_player/UI/Device/mainDevice.dart';
import 'package:m_player/UI/Screens/Category/Category_Screen.dart';
import 'package:m_player/UI/Screens/Device/Device_Screen.dart';
import 'package:m_player/UI/Screens/Home/Home_Screen.dart';
import 'package:m_player/Utils/MyColors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int _currentIndex = 0;
  List<Widget> bodyScreens = [
    HomeScreen(),
    CategoryScreen(),
    MainDevice()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player", style: TextStyle(color: myColors.darkGreen)),
        backgroundColor: myColors.white,
        centerTitle: true,
      ),

      extendBody: true,

      backgroundColor: myColors.white,

      body: bodyScreens.elementAt(_currentIndex),

      bottomNavigationBar: FloatingNavbar(
        onTap: (value){
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        backgroundColor: myColors.white,
        selectedItemColor: myColors.green,
        selectedBackgroundColor: myColors.white,
        unselectedItemColor: Colors.black,
        items: [
          FloatingNavbarItem(
            icon: Icons.home,
            title: "Home"
          ),

          FloatingNavbarItem(
              icon: Icons.category,
              title: "Category"
          ),

          FloatingNavbarItem(
              icon: Icons.my_library_music,
              title: "Device"
          )
        ],
      ),
    );
  }
}
