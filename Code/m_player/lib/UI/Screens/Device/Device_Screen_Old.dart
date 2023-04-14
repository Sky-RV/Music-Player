import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Provider/Song_Model_Provider.dart';
import 'package:m_player/UI/Device/PlayNow.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

class DeviceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DeviceScreen(); //create state
  }
}

class _DeviceScreen extends State<DeviceScreen>{

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> songs = [];
  String currentTitle = '';
  int currentIndex = 0;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    _audioPlayer.currentIndexStream.listen((index) {
      if(index != null){
        _updateCurrentPlaySongDetails(index);
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.dispose();
  }

  void requestPermission(){
    Permission.storage.request();
  }

  void _changePlayerViewVisibility(){
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  playSong(String? uri){
    try {
      _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(uri!))
      );
      _audioPlayer.play();
    } on Exception {
      log("Error parsing song");
    }
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs){
    List<AudioSource> sources = [];
    for (var song in songs){
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlaySongDetails(int index){
    setState(() {
      if(songs.isNotEmpty){
        currentTitle = songs[index].title;
        currentIndex = index;
      }
    });
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
          if(items.data!.isEmpty){
            return Container(
              child: Center(child: Text("Nothing Found"),),
            );
          }
          songs.clear();
          songs = items.data!;
          return ListView.builder(
            itemCount: items.data!.length,
            itemBuilder: (context, index){
              return Container(
                child: ListTile(
                  leading: QueryArtworkWidget(
                    id: items.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(Icons.music_note),
                  ),
                  title: Text(items.data![index].title),
                  subtitle: Text("${items.data![index].artist}"),
                  //  trailing: Icon(Icons.more_vert),
                  onTap:(){
                    //playSong(items.data![index].uri);
                    //context.read<Song_Model_Provider>().setId(items.data![index].id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayNow(songModel: items.data![index], audioPlayer: _audioPlayer,))
                    );
                  },
                ),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: myColors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const[
                      BoxShadow(
                          blurRadius: 4.0,
                          offset: Offset(-4, -4),
                          color: Colors.white24
                      ),
                      BoxShadow(
                          blurRadius: 4.0,
                          offset: Offset(4, 4),
                          color: Colors.black26
                      )
                    ]
                ),
              );
            }
          );
        },
      ),

    );
  }
}

class DurationState{
  Duration position, total;
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
}
