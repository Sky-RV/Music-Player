import 'package:flutter/material.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:m_player/Utils/MyTitles.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(myTitles.appNameEN, style: TextStyle(color: myColors.darkGreen),),
        backgroundColor: myColors.white,
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Text(myTitles.appNameEN + " v1.0", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              ),

              SizedBox(height: 150,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Text("طراحی و ساخته شده توسط یگانه غنی\nyeganehghani174@gmail.com", style:
                TextStyle(fontSize: 18),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
