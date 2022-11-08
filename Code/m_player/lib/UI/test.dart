import 'package:flutter/material.dart';
import 'package:m_player/UI/Bottom_Navigation/Downloads_Page.dart';
import 'package:m_player/UI/Bottom_Navigation/Home_Page.dart';
import 'package:m_player/UI/Bottom_Navigation/Playlist_Page.dart';
import 'package:m_player/UI/Bottom_Navigation/Search_Page.dart';
import 'package:m_player/UI/Bottom_Navigation/Settings_Page.dart';

class BottomNav7 extends StatefulWidget {

  const BottomNav7({Key? key}) : super(key: key);
  @override
  _BottomNav7State createState() => _BottomNav7State();
}

class _BottomNav7State extends State<BottomNav7> {
  late int _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getPage(_currentPage),
      bottomNavigationBar: AnimatedBottomNav(
          currentIndex: _currentPage,
          onChange: (index) {
            setState(() {
              _currentPage = index;
            });
          }),
    );
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return Home_Page();
      case 1:
        return Search_Page();
      case 2:
        return Playlist_Page();
      case 3:
        return Downloads_Page();
      case 4:
        return Settings_Page();
    }
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;
  const AnimatedBottomNav(
      {Key? key, required this.currentIndex, required this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          // Home
          Expanded(
            child: InkWell(
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: Icons.home,
                title: "Home",
                isActive: currentIndex == 0,
              ),
            ),
          ),

          // Search
          Expanded(
            child: InkWell(
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: Icons.search,
                title: "Search",
                isActive: currentIndex == 1,
              ),
            ),
          ),

          // Playlist
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.playlist_play_rounded,
                title: "PlayLists",
                isActive: currentIndex == 2,
              ),
            ),
          ),

          // Downloads
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.download,
                title: "Downloads",
                isActive: currentIndex == 2,
              ),
            ),
          ),

          // Settings
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.settings,
                title: "Settings",
                isActive: currentIndex == 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final String title;
  const BottomNavItem(
      {Key? key,
        this.isActive = false,
        required this.icon,
        this.activeColor,
        this.inactiveColor,
        required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        transitionBuilder: (child, animation) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    duration: const Duration(milliseconds: 500),
    reverseDuration: const Duration(milliseconds: 200),
    child: isActive
    ? Container(
    color: Colors.white,
    padding: const EdgeInsets.all(8.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Text(
    title,
    style: TextStyle(
    fontWeight: FontWeight.bold,color: activeColor ?? Theme.of(context).primaryColor,
    ),
    ),
      const SizedBox(height: 5.0),
      Container(
        width: 5.0,
        height: 5.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: activeColor ?? Theme.of(context).primaryColor,
        ),
      ),
    ],
    ),
    )
        : Icon(
      icon,
      color: inactiveColor ?? Colors.grey,
    ),
    );
  }
}