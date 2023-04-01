import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DeviceScreen(); //create state
  }
}

class _DeviceScreen extends State<DeviceScreen>{

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  void requestPermission(){
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true
        ),
        builder: (context, items){

          if(items.data == null){
            return Container(
              child: Center(child: CircularProgressIndicator(),),
            );
          }
          else if(items.data!.isEmpty){
            return Container(
              child: Center(child: Text("Nothing Found"),),
            );
          }
          return ListView.builder(
            itemCount: items.data!.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.music_note),
              title: Text(items.data![index].title),
              subtitle: Text("${items.data![index].artist}"),
              trailing: Icon(Icons.more_vert),
            ),
          );
        },
      ),

    );
  }
}