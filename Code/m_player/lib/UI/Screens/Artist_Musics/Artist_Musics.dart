import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Models/Artist/Artist_Model.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/UI/Screens/Artist_Musics/Play_Artist_Music.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:m_player/Utils/MyColors.dart';

class Artists_Music extends StatefulWidget {
  const Artists_Music({Key? key, required this.artist_model, required this.artist_name}) : super(key: key);

  final Artist_Model artist_model;
  final String artist_name;

  @override
  State<Artists_Music> createState() => _Artists_MusicState();
}

class _Artists_MusicState extends State<Artists_Music> {
  final dio = Dio();
  late Rest_Client rest_client;
  late Future<Latest_Music_Model> getMusics;
  late Music_Model currentMusic;

  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Music_Model> songs = [];
  String currentTitle = '';
  int currentIndex = 0;
  bool isPlaying = false;
  bool currantStatePlay = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getMusics = rest_client.getMusicsByAlbum(widget.artist_name);
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

  ConcatenatingAudioSource createPlaylist(List<Music_Model> songs){
    List<AudioSource> sources = [];
    for (var song in songs){
      sources.add(AudioSource.uri(Uri.parse(song.mp3_url!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlaySongDetails(int index){
    setState(() {
      if(songs.isNotEmpty){
        currentTitle = songs[index].mp3_title!;
        currentIndex = index;
      }
    });
  }

  loadMusic() async {
    await _audioPlayer.setUrl(currentMusic.mp3_url!);
  }

  void changeToSeconds(int sec){
    Duration duration = Duration(seconds: sec);
    _audioPlayer.seek(duration);
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
        title: Text('${widget.artist_model.artist_name}', style: TextStyle(color: myColors.darkGreen)),
        backgroundColor: myColors.white,
        centerTitle: true,
      ),

      extendBody: true,

      backgroundColor: myColors.white,

      body: Stack(
        children: [
          Container(
            child: FutureBuilder<Latest_Music_Model>(
              future: getMusics,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data!.musics!.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          leading: CachedNetworkImage(
                            width: 64,
                            height: 64,
                            imageUrl: "${snapshot.data!.musics![index].mp3_thumbnail_b}",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                          title: Text(snapshot.data!.musics![index].mp3_title.toString()),
                          subtitle: Text(snapshot.data!.musics![index].mp3_artist.toString()),
                          onTap: (){
                            setState(() {
                              isPlaying = true;
                              currantStatePlay = true;
                              currentMusic = snapshot.data!.musics![index];
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    Play_Album_Music(
                                      music_model: snapshot.data!.musics![index],
                                      audioPlayer: _audioPlayer,
                                      list: snapshot.data!.musics!,
                                      //FutureList: getMusics,
                                    ))
                            );
                            print("Future : ");
                            print(rest_client.getMusicsByAlbum(widget.artist_model.id!));
                            print("Album : ");
                            print(index);
                          },
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
        ],
      ),

      // body: Container(
      //   child: Stack(
      //     children: [
      //       Container(
      //         child: FutureBuilder<Latest_Music_Model>(
      //           future: getMusics,
      //           builder: (context, snapshot){
      //             if(snapshot.hasData){
      //               return Container(
      //                 child: ListView.builder(
      //                   itemCount: snapshot.data!.musics!.length,
      //                   itemBuilder: (context, index){
      //                     return ListTile(
      //                       leading: CachedNetworkImage(
      //                         width: 64,
      //                         height: 64,
      //                         imageUrl: "${snapshot.data!.musics![index].mp3_thumbnail_b}",
      //                         imageBuilder: (context, imageProvider) => Container(
      //                           decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(10),
      //                               image: DecorationImage(
      //                                   image: imageProvider,
      //                                   fit: BoxFit.cover
      //                               )
      //                           ),
      //                         ),
      //                       ),
      //                       title: Text(snapshot.data!.musics![index].mp3_title.toString()),
      //                       subtitle: Text(snapshot.data!.musics![index].mp3_artist.toString()),
      //                       onTap: (){
      //                         setState(() {
      //                           isPlaying = true;
      //                           currantStatePlay = true;
      //                           currentMusic = snapshot.data!.musics![index];
      //                           _audioHandler.play();
      //                         });
      //                         // Navigator.push(
      //                         //     context,
      //                         //     MaterialPageRoute(builder: (context) => PlayAlbumMusics(
      //                         //       music_model: snapshot.data!.musics![index],
      //                         //       audioPlayer: _audioPlayer,
      //                         //       list: snapshot.data!.musics!,
      //                         //       //FutureList: getMusics,
      //                         //     ))
      //                         // );
      //                         print("Future : ");
      //                         print(rest_client.getMusicsByAlbum(widget.album.aid!));
      //                         print("Album : ");
      //                         print(index);
      //                       },
      //                     );
      //                   },
      //                 ),
      //               );
      //             }
      //             else if (snapshot.hasError){
      //               return Center(
      //                 child: Text("Error accured. Please check your connection."),
      //               );
      //             }
      //             else{
      //               return Center(
      //                 child: CircularProgressIndicator(),
      //               );
      //             }
      //           },
      //         ),
      //       ),
      //
      //       if (isPlaying == true)
      //         Container(
      //           margin: EdgeInsets.all(8),
      //           child: Miniplayer(
      //
      //             maxHeight: MediaQuery.of(context).size.height,
      //             minHeight: 70,
      //             builder: (height, percentage){
      //               loadMusic();
      //               if(height == 70){
      //                 return Container(
      //                   decoration: BoxDecoration(
      //                       color: myColors.white.withOpacity(0.5),
      //                       borderRadius: BorderRadius.circular(15)
      //                   ),
      //                   child: Container(
      //                     margin: EdgeInsets.only(left: 10),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             CachedNetworkImage(
      //                               imageUrl: '${currentMusic.mp3_thumbnail_s}',
      //                               height: 50,
      //                               width: 50,
      //                             ),
      //                             SizedBox(width: 8,),
      //                             Text(
      //                               '${currentMusic.mp3_title}',
      //                               style: TextStyle(
      //                                   color: Colors.black,
      //                                 fontSize: 18
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //
      //                         Row(
      //                           children: [
      //                             // IconButton(
      //                             //   onPressed: () {
      //                             //     setState(() {
      //                             //       try {
      //                             //         if (_audioPlayer.hasNext) {
      //                             //           print("before seek next");
      //                             //           _audioPlayer.seekToNext();
      //                             //           print("skip next if condition");
      //                             //         }
      //                             //         print("skip next");
      //                             //       } catch (e) {
      //                             //         print("Error seeking to next song: $e");
      //                             //       }
      //                             //     });
      //                             //   },
      //                             //   icon: Icon(Icons.skip_previous, color: myColors.darkGreen,),
      //                             // ),
      //                             IconButton(
      //                               onPressed: () async {
      //                                 setState(() {
      //                                   currantStatePlay = !currantStatePlay;
      //                                 });
      //                                 if(currantStatePlay == false){
      //                                   await _audioPlayer.play();
      //                                   await _audioHandler.play();
      //                                 }
      //                                 else{
      //                                   await _audioPlayer.pause();
      //                                   await _audioHandler.pause();
      //                                 }
      //                               },
      //                               icon: Icon(currantStatePlay == false ? Icons.pause : Icons.play_arrow, color: myColors.darkGreen, size: 36,),
      //                             ),
      //                             // IconButton(
      //                             //   onPressed: (){
      //                             //     if(_audioPlayer.hasPrevious){
      //                             //       _audioPlayer.seekToPrevious();
      //                             //       print("skip previous if condition");
      //                             //     }
      //                             //     print("skip previous");
      //                             //   },
      //                             //   icon: Icon(Icons.skip_next, color: myColors.darkGreen,),
      //                             // ),
      //                             SizedBox(width: 10,)
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               }
      //               else{
      //                 // return Container(
      //                 //     width: double.infinity,
      //                 //     padding: EdgeInsets.all(16),
      //                 //     child: Column(
      //                 //       crossAxisAlignment: CrossAxisAlignment.start,
      //                 //       children: [
      //                 //         SizedBox(height: 30,),
      //                 //         Center(
      //                 //           child: Column(
      //                 //             children: [
      //                 //               Center(
      //                 //                 // child: const ArtWorkWidget(),
      //                 //                 child: QueryArtworkWidget(
      //                 //                   id: int.parse(currentMusic.id.toString()),
      //                 //                   type: ArtworkType.AUDIO,
      //                 //                   artworkHeight: 200.0,
      //                 //                   artworkWidth: 200.0,
      //                 //                   artworkFit: BoxFit.cover,
      //                 //                   nullArtworkWidget: Icon(Icons.music_note, color: myColors.darkGreen, size: 200,),
      //                 //                 ),
      //                 //               ),
      //                 //               SizedBox(height: 30,),
      //                 //               Text(
      //                 //                 currentMusic.mp3_title.toString(),
      //                 //                 // overflow: TextOverflow.fade,
      //                 //                 maxLines: 1,
      //                 //                 textAlign: TextAlign.center,
      //                 //                 style: TextStyle(
      //                 //                   fontWeight: FontWeight.bold,
      //                 //                   fontSize: 30,
      //                 //                 ),
      //                 //               ),
      //                 //               SizedBox(height: 30,),
      //                 //
      //                 //               Text(
      //                 //                 currentMusic.mp3_artist.toString() == "<unknown>" ? "Unknown Artist" : currentMusic.mp3_artist.toString(),
      //                 //                 // overflow: TextOverflow.fade,
      //                 //                 maxLines: 1,
      //                 //                 textAlign: TextAlign.center,
      //                 //                 style: TextStyle(
      //                 //                   fontWeight: FontWeight.bold,
      //                 //                   fontSize: 20,
      //                 //                 ),
      //                 //               ),
      //                 //               SizedBox(height: 30,),
      //                 //               Row(
      //                 //                 children: [
      //                 //                   Text(_position.toString().split(".")[0]),
      //                 //                   Expanded(
      //                 //                     child: Slider(
      //                 //                       value: _position.inSeconds.toDouble(),
      //                 //                       max: _duration.inSeconds.toDouble(),
      //                 //                       min: Duration(microseconds: 0).inSeconds.toDouble(),
      //                 //                       activeColor: myColors.yellow,
      //                 //                       inactiveColor: myColors.yellow.withOpacity(0.5),
      //                 //                       onChanged: (value){
      //                 //                         setState(() {
      //                 //                           changeToSeconds(value.toInt());
      //                 //                           value = value;
      //                 //                         });
      //                 //                       },
      //                 //                     ),
      //                 //                   ),
      //                 //                   Text(_duration.toString().split(".")[0]),
      //                 //                 ],
      //                 //               ),
      //                 //               SizedBox(height: 30,),
      //                 //               Row(
      //                 //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 //                 children: [
      //                 //                   Flexible(
      //                 //                     child: InkWell(
      //                 //                       onTap: (){
      //                 //                         if(_audioPlayer.hasPrevious){
      //                 //                           _audioPlayer.seekToPrevious();
      //                 //                           print("skip previous if condition");
      //                 //                         }
      //                 //                         print("skip previous");
      //                 //                       },
      //                 //                       child: Container(
      //                 //                         padding: EdgeInsets.all(10),
      //                 //                         child: Icon(
      //                 //                           Icons.skip_previous,
      //                 //                           color: myColors.darkGreen,
      //                 //                           size: 40,
      //                 //                         ),
      //                 //                       ),
      //                 //                     ),
      //                 //                   ),
      //                 //                   IconButton(
      //                 //                     onPressed: () {
      //                 //                       setState(() {
      //                 //                         if(isPlaying){
      //                 //                           _audioPlayer.pause();
      //                 //                         }
      //                 //                         else {
      //                 //                           _audioPlayer.play();
      //                 //                         }
      //                 //                         isPlaying = !isPlaying;
      //                 //                       });
      //                 //                     },
      //                 //                     icon: Icon(
      //                 //                       isPlaying ? Icons.pause : Icons.play_arrow,
      //                 //                       color: myColors.darkGreen, size: 40,
      //                 //                     ),
      //                 //                   ),
      //                 //                   IconButton(
      //                 //                     icon: Icon(
      //                 //                       Icons.skip_next,
      //                 //                       color: myColors.darkGreen,
      //                 //                       size: 40,
      //                 //                     ),
      //                 //                     onPressed: (){
      //                 //                       setState(() {
      //                 //                         try {
      //                 //                           if (_audioPlayer.hasNext) {
      //                 //                             print("before seek next");
      //                 //                             _audioPlayer.seekToNext();
      //                 //                             print("skip next if condition");
      //                 //                           }
      //                 //                           print("skip next");
      //                 //                         } catch (e) {
      //                 //                           print("Error seeking to next song: $e");
      //                 //                         }
      //                 //                         print(_audioPlayer.hasNext);
      //                 //                         print(_audioPlayer.hasPrevious);
      //                 //                         print(_audioPlayer.currentIndex);
      //                 //                       });
      //                 //                     },
      //                 //                   ),
      //                 //                 ],
      //                 //               ),
      //                 //
      //                 //               SizedBox(height: 30,),
      //                 //
      //                 //               Row(
      //                 //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 //                 mainAxisSize: MainAxisSize.max,
      //                 //                 children: [
      //                 //                   Flexible(
      //                 //                     child: InkWell(
      //                 //                       onTap: (){
      //                 //                         //_changePlayerViewVisibility();
      //                 //                         Navigator.pop(context);
      //                 //                       },
      //                 //                       child: Container(
      //                 //                         padding: EdgeInsets.all(10),
      //                 //                         child: Icon(Icons.list_rounded, color: myColors.darkGreen,),
      //                 //                       ),
      //                 //                     ),
      //                 //                   ),
      //                 //                   Flexible(
      //                 //                     child: InkWell(
      //                 //                       onTap: (){
      //                 //                         _audioPlayer.loopMode == LoopMode.one ? _audioPlayer.setLoopMode(LoopMode.all) : _audioPlayer.setLoopMode(LoopMode.one);
      //                 //                       },
      //                 //                       child: Container(
      //                 //                         padding: EdgeInsets.all(10),
      //                 //                         child: StreamBuilder<LoopMode>(
      //                 //                           stream: _audioPlayer.loopModeStream,
      //                 //                           builder: (context, snapchat){
      //                 //                             final loopMode = snapchat.data;
      //                 //                             if(LoopMode.one == loopMode){
      //                 //                               return Icon(Icons.repeat_one, color: myColors.yellow,);
      //                 //                             }
      //                 //                             return Icon(Icons.repeat, color: myColors.darkGreen,);
      //                 //                           },
      //                 //                         ),
      //                 //                       ),
      //                 //                     ),
      //                 //                   ),
      //                 //                   Flexible(
      //                 //                     child: InkWell(
      //                 //                       onTap: (){
      //                 //                         setState(() {
      //                 //                           if(_isShuffel){
      //                 //                             _audioPlayer.setShuffleModeEnabled(true);
      //                 //                           }
      //                 //                           else{
      //                 //                             _audioPlayer.setShuffleModeEnabled(false);
      //                 //                           }
      //                 //                           _isShuffel = !_isShuffel;
      //                 //                         });
      //                 //                       },
      //                 //                       child: Container(
      //                 //                         padding: EdgeInsets.all(10),
      //                 //                         child: Icon(
      //                 //                             Icons.shuffle,
      //                 //                             color: _isShuffel? myColors.yellow : myColors.darkGreen
      //                 //                         ),
      //                 //                       ),
      //                 //                     ),
      //                 //                   ),
      //                 //                 ],
      //                 //               )
      //                 //
      //                 //             ],
      //                 //           ),
      //                 //         ),
      //                 //       ],
      //                 //     ),
      //                 //   );
      //                 return Container(
      //                   decoration: BoxDecoration(
      //                       color: myColors.white.withOpacity(0.5),
      //                       borderRadius: BorderRadius.circular(15)
      //                   ),
      //                   child: Container(
      //                       child: CachedNetworkImage(
      //                         imageUrl: "${currentMusic.mp3_thumbnail_b}",
      //                         imageBuilder: (context, imageProvider) => Container(
      //                           margin: EdgeInsets.all(8),
      //                           decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(15.0),
      //                             image: DecorationImage(
      //                               image: imageProvider,
      //                               fit: BoxFit.cover,
      //                             ),
      //                           ),
      //                           child: ClipRRect(
      //                             child: BackdropFilter(
      //                               filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
      //                               child: Container(
      //                                 alignment: Alignment.center,
      //                                 color: Colors.grey.withOpacity(0.1),
      //                                 child: Container(
      //                                   child: Column(
      //                                     mainAxisAlignment: MainAxisAlignment.center,
      //                                     crossAxisAlignment: CrossAxisAlignment.center,
      //                                     children: [
      //                                       CachedNetworkImage(
      //                                         width: 264,
      //                                         height: 264,
      //                                         imageUrl: "${currentMusic.mp3_thumbnail_b}",
      //                                         imageBuilder: (context, imageProvider) => Container(
      //                                           margin: EdgeInsets.all(8),
      //                                           decoration: BoxDecoration(
      //                                             borderRadius: BorderRadius.circular(15.0),
      //                                             image: DecorationImage(
      //                                               image: imageProvider,
      //                                               fit: BoxFit.cover,
      //                                             ),
      //                                           ),
      //
      //                                         ),
      //                                         placeholder: (context, url) => CircularProgressIndicator(),
      //                                         errorWidget: (context, url, error) => Icon(Icons.error),
      //                                       ),
      //
      //                                       SizedBox(height: 16,),
      //
      //                                       Text(
      //                                         '${currentMusic.mp3_title}',
      //                                         style: TextStyle(
      //                                             color: Colors.black,
      //                                             fontWeight: FontWeight.bold,
      //                                             fontSize: 18
      //                                         ),
      //                                       ),
      //
      //                                       Text(
      //                                         '${currentMusic.mp3_artist}',
      //                                         style: TextStyle(
      //                                             color: Colors.black,
      //                                             fontSize: 16
      //                                         ),
      //                                       ),
      //
      //                                       SizedBox(height: 16,),
      //
      //                                       Row(
      //                                         mainAxisAlignment: MainAxisAlignment.center,
      //                                         crossAxisAlignment: CrossAxisAlignment.center,
      //                                         children: [
      //                                           IconButton(
      //                                             onPressed: (){
      //                                               if(_audioPlayer.hasPrevious){
      //                                                 _audioPlayer.seekToPrevious();
      //                                                 print("skip previous if condition");
      //                                               }
      //                                               print("skip previous");
      //                                             },
      //                                             icon: Icon(Icons.skip_previous, color: myColors.darkGreen, size: 48, ),
      //                                           ),
      //                                           SizedBox(width: 30,),
      //                                           IconButton(
      //                                             onPressed: () async {
      //                                               setState(() {
      //                                                 currantStatePlay = !currantStatePlay;
      //                                               });
      //                                               if(currantStatePlay == false){
      //                                                 await _audioPlayer.play();
      //                                               }
      //                                               else{
      //                                                 await _audioPlayer.pause();
      //                                               }
      //                                             },
      //                                             icon: Icon(currantStatePlay == true ? Icons.play_arrow : Icons.pause, color: myColors.darkGreen, size: 48,),
      //                                           ),
      //                                           SizedBox(width: 30,),
      //                                           IconButton(
      //                                             // onPressed: () async {
      //                                             //   await player.seekToNext();
      //                                             // },
      //                                             onPressed: (){
      //                                               if(_audioPlayer.hasNext){
      //                                                 _audioPlayer.seekToNext();
      //                                                 print("skip previous if condition");
      //                                               }
      //                                             },
      //                                             icon: Icon(Icons.skip_next, color: myColors.darkGreen, size: 48,),
      //                                           ),
      //                                         ],
      //                                       ),
      //                                       SizedBox(height: 20,),
      //                                       Row(
      //                                         children: [
      //                                           Text(_position.toString().split(".")[0]),
      //                                           Expanded(
      //                                             child: Slider(
      //                                               value: _position.inSeconds.toDouble(),
      //                                               max: _duration.inSeconds.toDouble(),
      //                                               min: Duration(microseconds: 0).inSeconds.toDouble(),
      //                                               activeColor: myColors.yellow,
      //                                               inactiveColor: myColors.yellow.withOpacity(0.5),
      //                                               onChanged: (value){
      //                                                 setState(() {
      //                                                   changeToSeconds(value.toInt());
      //                                                   value = value;
      //                                                 });
      //                                               },
      //                                             ),
      //                                           ),
      //                                           Text(_duration.toString().split(".")[0]),
      //                                         ],
      //                                       ),
      //                                       Flexible(
      //                                         child: InkWell(
      //                                           onTap: (){
      //                                             _audioPlayer.loopMode == LoopMode.one ? _audioPlayer.setLoopMode(LoopMode.all) : _audioPlayer.setLoopMode(LoopMode.one);
      //                                           },
      //                                           child: Container(
      //                                             padding: EdgeInsets.all(10),
      //                                             child: StreamBuilder<LoopMode>(
      //                                               stream: _audioPlayer.loopModeStream,
      //                                               builder: (context, snapchat){
      //                                                 final loopMode = snapchat.data;
      //                                                 if(LoopMode.one == loopMode){
      //                                                   return Icon(Icons.repeat_one, color: myColors.yellow,);
      //                                                 }
      //                                                 return Icon(Icons.repeat, color: myColors.darkGreen,);
      //                                               },
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       )
      //                   ),
      //                 );
      //               }
      //             },
      //           ),
      //         )
      //     ],
      //   ),
      // ),
    );
  }
}
