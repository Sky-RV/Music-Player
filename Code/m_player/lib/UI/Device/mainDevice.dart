import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:m_player/Provider/Song_Model_Provider.dart';
import 'package:m_player/UI/Screens/Device/Device_Screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  // runApp(
  //     ChangeNotifierProvider(
  //       create: (context) => Song_Model_Provider(),
  //       builder: (context, child){
  //         return MainDevice();
  //       },
  //     )
  // );
  runApp(DeviceScreen());
}

class MainDevice extends StatelessWidget {
  const MainDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeviceScreen(),
    );
  }
}
