import 'package:flutter/material.dart';
import 'package:m_player/UI/Screens/Dashboard/Dashboard_Screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 3)).then((value){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false
      );
    });

    return Scaffold();
  }
}
