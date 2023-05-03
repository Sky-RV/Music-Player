import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:m_player/Models/Category/Category_Model.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:m_player/Models/Playlist_Base/Playlist_Base_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/UI/Screens/Music_Category/PlayCategoryMusic.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicsCategoryScreen extends StatefulWidget {

  final Category_Model category;
  const MusicsCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<MusicsCategoryScreen> createState() => _MusicsCategoryScreenState();
}

class _MusicsCategoryScreenState extends State<MusicsCategoryScreen> {

  final dio = Dio();
  late Rest_Client rest_client;
  late Future<Latest_Music_Model> getMusics;
  late Future<Playlist_Base_Model> getPlaylists;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late Music_Model currentMusic;

  List<Music_Model> myMusicListPass = [];

  List<Music_Model> musics = [];
  String currentTitle = '';
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getMusics = rest_client.getMusicsByCategory(widget.category.cid!);
    getPlaylists = rest_client.getPlaylists();
    requestPermission();
    _audioPlayer.currentIndexStream.listen((index) {
      if(index != null){
        _updateCurrentPlaySongDetails(index);
      }
    });
    createPlaylist(musics);
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.dispose();
  }

  void requestPermission(){
    Permission.storage.request();
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
      if(musics.isNotEmpty){
        currentTitle = musics[index].mp3_title!;
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
        title: Text('${widget.category.category_name}', style: TextStyle(color: myColors.darkGreen)),
        backgroundColor: myColors.white,
        centerTitle: true,
      ),

      extendBody: true,

      backgroundColor: myColors.white,

      body: Container(
        child: FutureBuilder<Latest_Music_Model>(
          future: getMusics,
          builder: (context, snapshot){
            if (snapshot.hasData){
              return Container(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.musics!.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        for(int i=0; i<snapshot.data!.musics!.length; i++){
                          myMusicListPass.add(snapshot.data!.musics![i]);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                PlayCategoryMusic(
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
                        print(musics);
                      },
                      child: CachedNetworkImage(
                        width: 164,
                        height: 164,
                        imageUrl: "${snapshot.data!.musics![index].mp3_thumbnail_b}",
                        imageBuilder: (context, imageProvider) => Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.yellow.shade50,
                                            myColors.yellow,
                                            Colors.yellow.shade50
                                          ]
                                      )
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${snapshot.data!.musics![index].mp3_title}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: myColors.darkGreen
                                      ),
                                    ),
                                  ),
                                ),
                                bottom: 5,
                                right: 0,
                                left: 0,
                              )
                            ],
                          ),
                        ),
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  },
                ),
              );
            }
            else if (snapshot.hasError){
              return Center(
                child: Text("Error accured. Please check your connection."),
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