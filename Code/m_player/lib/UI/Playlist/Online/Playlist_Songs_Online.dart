import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:m_player/Models/Playlist/Playlist_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/UI/Playlist/Online/PlayMusics_Online.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:m_player/Utils/MyColors.dart';

class PlaylistSongsOnline extends StatefulWidget {

  final Playlist_Model playlist;
  const PlaylistSongsOnline({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistSongsOnline> createState() => _PlaylistSongsOnlineState();
}

class _PlaylistSongsOnlineState extends State<PlaylistSongsOnline> {

  final dio = Dio();
  late Rest_Client rest_client;
  late Future<Latest_Music_Model> getMusics;

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String currentTitle = '';
  int currentIndex = 0;
  bool isPlaying = false;

  List<Music_Model> myMusicListPass = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getMusics = rest_client.getMusicsByAlbum(widget.playlist.pid!);
    requestPermission();
    _audioPlayer.currentIndexStream.listen((index) {
      if(index != null){
        _updateCurrentPlaySongDetails(index);
      }
    });
    AudioServiceBackground.setState(playing: true);
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

  ConcatenatingAudioSource createPlaylist(List<Music_Model> songs){
    List<AudioSource> sources = [];
    for (var song in songs){
      sources.add(AudioSource.uri(Uri.parse(song.mp3_url!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlaySongDetails(int index){
    setState(() {
      if(myMusicListPass.isNotEmpty){
        currentTitle = myMusicListPass[index].mp3_title.toString();
        currentIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: myColors.darkGreen,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('${widget.playlist.playlist_name}', style: TextStyle(color: myColors.darkGreen)),
        backgroundColor: myColors.white,
        centerTitle: true,
      ),

      extendBody: true,

      backgroundColor: myColors.white,

      body: Container(
        child: FutureBuilder<Latest_Music_Model>(
          future: getMusics,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.musics!.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      // leading: QueryArtworkWidget(
                      //   id: int.parse(snapshot.data!.musics![index].id.toString()),
                      //   type: ArtworkType.AUDIO,
                      //   nullArtworkWidget: Icon(Icons.music_note),
                      // ),
                      leading: CachedNetworkImage(
                        width: 64,
                        height: 64,
                        imageUrl: "${snapshot.data!.musics![index].mp3_thumbnail_b}",
                      ),
                      title: Text(snapshot.data!.musics![index].mp3_title.toString()),
                      subtitle: Text(snapshot.data!.musics![index].mp3_artist.toString()),
                      onTap: (){
                        for(int i=0; i<snapshot.data!.musics!.length; i++){
                          myMusicListPass.add(snapshot.data!.musics![i]);
                        }
                        print("My list : ");
                        for(int i=0; i<snapshot.data!.musics!.length; i++){
                          print(myMusicListPass[i].mp3_title);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                PlayMusics_Online(
                                  // category: widget.category,
                                  audioPlayer: _audioPlayer,
                                  list: myMusicListPass,
                                  music_model: snapshot.data!.musics![index],
                                )
                            )
                        );
                        print(snapshot.data!.musics![index]);
                        print(index);
                        print(snapshot.data!.musics);
                        print(snapshot.data!);
                        print(myMusicListPass);
                      },
                    );
                  },
                ),
              );
            }
            else if (snapshot.hasError){
              return Center(
                child: Text("ارور! لطفا اتصال به اینترنت خود را چک کنید."),
              );
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
