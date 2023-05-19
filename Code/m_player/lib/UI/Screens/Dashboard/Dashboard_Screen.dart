import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:m_player/UI/Device/mainDevice.dart';
import 'package:m_player/UI/Drawer/About_Us.dart';
import 'package:m_player/UI/Drawer/Help.dart';
import 'package:m_player/UI/Playlist/Playlists.dart';
import 'package:m_player/UI/Screens/Category/Category_Screen.dart';
import 'package:m_player/UI/Screens/Device/Device_Screen_New.dart';
import 'package:m_player/UI/Screens/Device/Device_Screen_Old.dart';
import 'package:m_player/UI/Screens/Home/Home_Screen.dart';
import 'package:m_player/UI/Web%20Music/WebMusics.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:m_player/Utils/MyTitles.dart';
import 'package:m_player/Utils/my_flutter_app_icons.dart';
import 'package:flutter/cupertino.dart';


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
    Playlists(),
    WebMusics(),
    Device_Screen_New(),
    // DeviceScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(myTitles.appNameEN ,style: TextStyle(color: myColors.darkGreen)),
        backgroundColor: myColors.white,
        centerTitle: true,
          iconTheme: IconThemeData(color: myColors.darkGreen)
      ),

      extendBody: true,

      backgroundColor: myColors.white,

      body: bodyScreens.elementAt(_currentIndex),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 25),
          children: <Widget>[
            // DrawerHeader(
            //   child: Text('Drawer Header'),
            //   decoration: BoxDecoration(
            //     color: myColors.yellow,
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                ListTile(
                  title: Text("راهنمایی"),
                  leading: Icon(Icons.help, color: myColors.darkGreen,),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Help())
                    );
                  },
                ),

                ListTile(
                  title: Text("درباره ما"),
                  leading: Icon(Icons.error, color: myColors.darkGreen,),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUs())
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),

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
            title: "خانه"
          ),

          FloatingNavbarItem(
              icon: Icons.category,
              title: "دسته بندی"
          ),

          FloatingNavbarItem(
              icon: Icons.playlist_play_rounded,
              title: "پلی لیست ها"
          ),

          FloatingNavbarItem(
            icon: Icons.language,
            title: 'وب سایت ها'
          ),

          FloatingNavbarItem(
              icon: Icons.my_library_music,
              title: "دستگاه"
          )
        ],
      ),
    );
  }
}
