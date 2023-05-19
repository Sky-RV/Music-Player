import 'package:flutter/material.dart';
import 'package:m_player/UI/Drawer/Help_Pages/AlbumMusic.dart';
import 'package:m_player/UI/Drawer/Help_Pages/ArtistMusic.dart';
import 'package:m_player/UI/Drawer/Help_Pages/CategoryMusic.dart';
import 'package:m_player/UI/Drawer/Help_Pages/DeviceMusic.dart';
import 'package:m_player/UI/Drawer/Help_Pages/LatestMusic.dart';
import 'package:m_player/UI/Drawer/Help_Pages/OnlineWebsite.dart';
import 'package:m_player/UI/Drawer/Help_Pages/PlaylistMusic.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:m_player/Utils/MyTitles.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(myTitles.appNameEN, style: TextStyle(color: myColors.darkGreen),),
        backgroundColor: myColors.white,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("چگونه از بیت باکسر استفاده کنیم؟", style: TextStyle(fontSize: 18, color: myColors.darkGreen),),
                  SizedBox(width: 12,),
                  Icon(Icons.error_outline, color: myColors.green,),
                ],
              ),
            ),

            SizedBox(height: 36,),

            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    child: TextButton(
                      child: Text("اجرای آخرین موزیک ها"),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LatestMusicHelp())
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 8,),

                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    child: TextButton(
                      child: Text("اجرای آهنگ های آلبوم ها"),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AlbumMusicHelp())
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    child: TextButton(
                      child: Text("اجرای آهنگ های خوانندگان"),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ArtistMusicHelp())
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    child: TextButton(
                      child: Text("آجرای آهنگ های دسته یندی"),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CategoryMusicHelp())
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    child: TextButton(
                      child: Text("اجرای آهنگ های پلی لیست"),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlaylistMusicHelp())
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    child: TextButton(
                      child: Text("وب سایت های آنلاین پخش آهنگ"),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OnlineWebsiteHelp())
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    child: TextButton(
                      child: Text("اجرای آهنگ های حافظه دستگاه"),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DeviceMusicHelp())
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 64,),
                  Container(
                    child: Text("با تشکر از انتخابتون", style: TextStyle(fontSize: 16),),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
