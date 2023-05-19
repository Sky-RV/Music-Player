import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:m_player/Models/Playlist/Playlist_Model.dart';
import 'package:m_player/Models/Playlist_Base/Playlist_Base_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:m_player/Utils/MyColors.dart';

class PlayOnline extends StatefulWidget {

  final Playlist_Model playlist_model;

  const PlayOnline({Key? key, required this.playlist_model}) : super(key: key);

  @override
  State<PlayOnline> createState() => _PlayOnlineState();
}

class _PlayOnlineState extends State<PlayOnline> {

  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  final Dio dio = Dio();

  late Rest_Client rest_client;
  late Future<Latest_Music_Model> getMusics;
  late Future<Playlist_Base_Model> getPlaylists;
  late final Music_Model musicModel;
  late Music_Model music_model;

  List<Music_Model> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;
  bool isPlaying = false;
  bool isShuffel = false;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getPlaylists = rest_client.getPlaylists();
    getMusics = rest_client.getMusicByPlaylists(widget.playlist_model.pid!);
    audioPlayer.currentIndexStream.listen((event) {
      if(event != null){
        updateCurrentMusicDetails(event);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  void changePlayerViewVisibility(){
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  ConcatenatingAudioSource createPlaylist(List<Music_Model> songs){
    List<AudioSource> src = [];
    for(var song in songs){
      src.add(AudioSource.uri(Uri.parse(song.mp3_url!)));
    }
    return ConcatenatingAudioSource(children: src);
  }

  void updateCurrentMusicDetails(int index){
    setState(() {
      if(songs.isEmpty){
        currentSongTitle = songs[index].mp3_title!;
        currentIndex = index;
      }
    });
  }

  void changeToSeconds(int sec){
    Duration d = Duration(seconds: sec);
    audioPlayer.seek(d);
  }

  void playSong(){
    try{
      audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(music_model.mp3_url!),
          tag: MediaItem(
            id: '${music_model.id}',
            title: '${music_model.mp3_title}',
            artUri: Uri.parse('https://example.com/albumart.jpg'),
          )
        )
      );
      audioPlayer.play();
      isPlaying = true;
      isShuffel = false;
    }
    on Exception{
      log("Can NOT parse music.");
    }
    audioPlayer.durationStream.listen((event) {
      setState(() {
        _duration = event!;
      });
    });
    
    audioPlayer.positionStream.listen((event) {
      setState(() {
        _position = event!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isPlaying){
      return Scaffold(
        appBar: AppBar(
          leading: BackButtonIcon(),
        ),
        
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, right: 20, left: 26),
            decoration: BoxDecoration(color: myColors.white),
            child: Column(
              children: <Widget>[
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  margin: const EdgeInsets.only(bottom: 30),
                  child: QueryArtworkWidget(
                    id: int.parse(songs![currentIndex].id!),
                    type: ArtworkType.AUDIO,
                    // type: ArtworkType.PLAYLIST,
                    artworkBorder: BorderRadius.circular(200),
                  ),
                ),
                
                Text(
                  songs[currentIndex].mp3_title!,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                
                SizedBox(height: 10,),

                Text(
                  songs[currentIndex].mp3_title.toString() == "<unknown>" ? "Unknown Artist" : songs[currentIndex].mp3_title.toString(),
                  // overflow: TextOverflow.fade,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20,),

                Row(
                  children: [
                    Text(_position.toString().split(".")[0]),
                    Expanded(
                      child: Slider(
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        min: Duration(microseconds: 0).inSeconds.toDouble(),
                        activeColor: myColors.yellow,
                        inactiveColor: myColors.yellow.withOpacity(0.5),
                        onChanged: (value){
                          setState(() {
                            changeToSeconds(value.toInt());
                            value = value;
                          });
                        },
                      ),
                    ),
                    Text(_duration.toString().split(".")[0]),
                  ],
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: (){
                          if(audioPlayer.hasPrevious){
                            audioPlayer.seekToPrevious();
                            print("skip previous if condition");
                          }
                          print("skip previous");
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.skip_previous,
                            color: myColors.darkGreen,
                            size: 40,
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      child: InkWell(
                        onTap: (){
                          if(audioPlayer.playing){
                            audioPlayer.pause();
                          }
                          else{
                            if(audioPlayer.currentIndex != null){
                              audioPlayer.play();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          child: StreamBuilder<bool>(
                            stream: audioPlayer.playingStream,
                            builder: (context, snapshot){
                              bool? playingState = snapshot.data;
                              if(playingState != null && playingState){
                                return Icon(Icons.pause, size: 40, color: myColors.darkGreen,);
                              }
                              return Icon(Icons.play_arrow, size: 40, color: myColors.darkGreen,);
                            },
                          ),
                        ),
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: myColors.darkGreen,
                        size: 40,
                      ),
                      onPressed: (){
                        if(audioPlayer.hasNext){
                          audioPlayer.seekToNext();
                          print("skip previous if condition");
                        }
                      },
                    ),
                  ],
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: (){
                          //_changePlayerViewVisibility();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.list_rounded, color: myColors.darkGreen,),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: (){
                          audioPlayer.loopMode == LoopMode.one ? audioPlayer.setLoopMode(LoopMode.all) : audioPlayer.setLoopMode(LoopMode.one);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: StreamBuilder<LoopMode>(
                            stream: audioPlayer.loopModeStream,
                            builder: (context, snapchat){
                              final loopMode = snapchat.data;
                              if(LoopMode.one == loopMode){
                                return Icon(Icons.repeat_one, color: myColors.yellow,);
                              }
                              return Icon(Icons.repeat, color: myColors.darkGreen,);
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            if(isShuffel){
                              audioPlayer.setShuffleModeEnabled(true);
                            }
                            else{
                              audioPlayer.setShuffleModeEnabled(false);
                            }
                            isShuffel = !isShuffel;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                              Icons.shuffle,
                              color: isShuffel ? myColors.yellow : myColors.darkGreen
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Container(
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        'انتخاب پلی لیست : ',
                                        style: TextStyle(color: myColors.darkGreen),
                                      ),
                                    ),
                                    color: myColors.yellow.withOpacity(0.7),
                                  ),
                                  content: setupAlertDialoadContainer(context, songs[currentIndex].id, getPlaylists),
                                );
                              }
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                              Icons.add,
                              color: myColors.darkGreen
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonIcon(),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search, color: myColors.darkGreen,),
          )
        ],
      ),

      body: FutureBuilder<Latest_Music_Model>(
        future: getMusics,
        builder: (context, item){
          if(item.data!.musics!.isEmpty){
            return const Center(child: Text("موزیکی یافت نشد."),);
          }
          if(item.data!.musics! == null){
            return const Center(child: CircularProgressIndicator(),);
          }
          songs.clear();
          songs = item.data!.musics!;

          return ListView.builder(
            itemCount: item.data!.musics!.length,
            itemBuilder: (context, index){
              return Container(
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
                child: ListTile(
                  leading: CachedNetworkImage(
                    width: 64,
                    height: 64,
                    imageUrl: "${item.data!.musics![index].mp3_thumbnail_b}",
                  ),
                  title: Text(item.data!.musics![index].mp3_title.toString()),
                  subtitle: Text(item.data!.musics![index].mp3_artist.toString()),
                  onTap: () async {
                    changePlayerViewVisibility();
                    await audioPlayer.setAudioSource(createPlaylist(item.data!.musics!), initialIndex: index);
                    await audioPlayer.play();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Widget setupAlertDialoadContainer(context , audioId, getPlaylists) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: MediaQuery.of(context).size.height / 2, // Change as per your requirement
        width: MediaQuery.of(context).size.width, // Change as per your requirement
        child: FutureBuilder<Playlist_Base_Model>(
          future: getPlaylists,
          builder: (context, item){
            if(item.data!.playlists! == null){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(item.data!.playlists!.isEmpty){
              return const Center(child: Text("پلی لیست وجود ندارد."),);
            }
            return ListView.builder(
              itemCount: item.data!.playlists!.length,
              itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: myColors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            offset: Offset(5,5),
                            color: Colors.black12
                        )
                      ]
                  ),
                  child: ListTile(
                    leading: QueryArtworkWidget(
                      id: int.parse(item.data!.playlists![index].pid!),
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(Icons.featured_play_list),
                    ),
                    title: Text(item.data!.playlists![index].playlist_name!),
                    onTap: () async {
                      String playlistId = item.data!.playlists![index].pid!;
                      print("playlist " + playlistId.toString());
                      print("song id "+ audioId.toString());
                      await OnAudioQuery.platform.addToPlaylist(int.parse(playlistId), audioId);
                      sleep(Duration(seconds:2));
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
        ),
        // child: ListView.builder(
        //
        //   shrinkWrap: true,
        //   itemCount: 15,
        //   itemBuilder: (BuildContext context, int index) {
        //     return ListTile(
        //       title: Card(child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text('List Item $index'),
        //       )),
        //     );
        //   },
        // ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          onPressed: (){
            Navigator.pop(context);
          },child: Text("لغو"),),
      )
    ],
  );
}