import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Device_Screen_New extends StatefulWidget {
  const Device_Screen_New({Key? key}) : super(key: key);

  @override
  State<Device_Screen_New> createState() => _Device_Screen_NewState();
}

class _Device_Screen_NewState extends State<Device_Screen_New> {

  // final OnAudioQuery _audioQuery = OnAudioQuery();
  // final AudioPlayer _audioPlayer = AudioPlayer();
  //
  // @override
  // void initState() {
  //   super.initState();
  //   requestStoragePermission();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder<List<SongModel>>(
  //       // default values
  //       future: _audioQuery.querySongs(
  //         sortType: null,
  //         orderType: OrderType.ASC_OR_SMALLER,
  //         uriType: UriType.EXTERNAL,
  //         ignoreCase: true,
  //       ),
  //       builder: (context, item){
  //         // loading content indicator
  //         if(item.data == null){
  //           return const Center(child: CircularProgressIndicator(),);
  //         }
  //         // no songs found
  //         if(item.data!.isNotEmpty){
  //           return const Center(child: Text("No Songs Found"),);
  //         }
  //         // showing the songs
  //         return ListView.builder(
  //           itemCount: item.data!.length,
  //           itemBuilder: (context, index){
  //             return ListTile(
  //               title: Text(item.data![index].title),
  //               subtitle: Text(item.data![index].displayName),
  //               trailing: const Icon(Icons.more_vert),
  //               leading: QueryArtworkWidget(
  //                 id: item.data![index].id,
  //                 type: ArtworkType.AUDIO,
  //                 nullArtworkWidget: Icon(Icons.music_note),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  // void requestStoragePermission() async {
  //   // only if the platform is not web. (web has no permission)
  //   if(!kIsWeb){
  //     bool permissionStatus = await _audioQuery.permissionsStatus();
  //     if(!permissionStatus)
  //       await _audioQuery.permissionsRequest();
  //   }
  //  // Permission.storage.request();
  //
  //   // ensured build methods is called
  //   setState(() {
  //
  //   });
  // }
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();
  late final SongModel songModel;

  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;
  bool isPlayerViewVisible = false;
  bool _isShuffel = false;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestStoragePermission();
    _player.currentIndexStream.listen((index) {
      if(index != null){
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _player.dispose();
    super.dispose();
  }

  void requestStoragePermission() async {
    // Permission.storage.request();
    // only if the platform is not web. (web has no permission)
    if(!kIsWeb){
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if(!permissionStatus)
        await _audioQuery.permissionsRequest();
    }
    // Permission.storage.request();

    // ensured build methods is called
    setState(() {

    });
  }

  void _changePlayerViewVisibility(){
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs){
    List<AudioSource> sources = [];
    for (var song in songs){
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }
  
  void toast(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      )
    );
  }
  
  void _updateCurrentPlayingSongDetails(int index){
    setState(() {
      if(songs.isNotEmpty){
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }

  void changeToSeconds(int sec){
    Duration duration = Duration(seconds: sec);
    _player.seek(duration);
  }

  void playSong(){
    try {
      _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(songModel.uri!),
          tag: MediaItem(
            id: '${songModel.id}',
            album: '${songModel.album}',
            title: '${songModel.displayNameWOExt}',
            artUri: Uri.parse('https://example.com/albumart.jpg'),
          ),
        ),
      );
      _player.play();
      isPlayerViewVisible = true;
      _isShuffel = false;
    }
    on Exception{
      log("Can not parse song.");
    }
    _player.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    _player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isPlayerViewVisible){
      return Scaffold(
        body:
        // SingleChildScrollView(
        //   child:
        // InkWell(
        //   onTap: _changePlayerViewVisibility,
        //   child: Container(
        //     padding: const EdgeInsets.all(10),
        //     child: Icon(Icons.arrow_back_ios_new, color: myColors.darkGreen,),
        //   ),
        // ),
          SafeArea(
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
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.only(bottom: 30),
                    child: QueryArtworkWidget(
                      id: songs[currentIndex].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(200.0),
                    ),
                  ),

                  Text(
                    songs[currentIndex].displayNameWOExt,
                    // overflow: TextOverflow.fade,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 10,),

                  Text(
                    songs[currentIndex].artist.toString() == "<unknown>" ? "Unknown Artist" : songs[currentIndex].artist.toString(),
                    // overflow: TextOverflow.fade,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20,),
                  //
                  // // slider, position and duration widgets
                  // // Column(
                  // //   children: [
                  // //     Container(
                  // //       padding: EdgeInsets.zero,
                  // //       margin: const EdgeInsets.only(bottom: 4.0),
                  // //       decoration: BoxDecoration(
                  // //         borderRadius: BorderRadius.circular(20.0),
                  // //       ),
                  // //       child: StreamBuilder<DurationState>(
                  // //         stream: _durationStateStream,
                  // //         builder: (context, snapshot){
                  // //           final durationState = snapshot.data;
                  // //           final progress = durationState?.position?? Duration.zero;
                  // //           final total = durationState?.total ?? Duration.zero;
                  // //
                  // //           return ProgressBar(
                  // //
                  // //           );
                  // //         },
                  // //       )
                  // //     )
                  // //   ],
                  // // )
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
                            if(_player.hasPrevious){
                              _player.seekToPrevious();
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
                      // IconButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       if(isPlayerViewVisible){
                      //         _player.pause();
                      //       }
                      //       else {
                      //         _player.play();
                      //       }
                      //       isPlayerViewVisible = !isPlayerViewVisible;
                      //     });
                      //   },
                      //   icon: Icon(
                      //     isPlayerViewVisible ? Icons.pause : Icons.play_arrow,
                      //     color: myColors.darkGreen, size: 40,
                      //   ),
                      // ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            if(_player.playing){
                              _player.pause();
                            }
                            else{
                              if(_player.currentIndex != null){
                                _player.play();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(top: 20, left: 20),
                            child: StreamBuilder<bool>(
                              stream: _player.playingStream,
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
                          if(_player.hasNext){
                            _player.seekToNext();
                            print("skip previous if condition");
                          }
                        },
                      ),
                      // Flexible(
                      //   child: InkWell(
                      //     onTap: (){
                      //       try {
                      //         if (widget.audioPlayer.hasNext) {
                      //           print("before seek next");
                      //           widget.audioPlayer.seekToNext();
                      //           print("skip next if condition");
                      //         }
                      //         print("skip next");
                      //       } catch (e) {
                      //         print("Error seeking to next song: $e");
                      //       }
                      //       print(widget.audioPlayer.playerState);
                      //       print(widget.audioPlayer.hasNext);
                      //       print(widget.audioPlayer.hasPrevious);
                      //       print(widget.audioPlayer.currentIndex);
                      //       print(widget.audioPlayer.audioSource.toString());
                      //
                      //     },
                      //     // onTap: (){
                      //     //   if(widget.audioPlayer.hasNext){
                      //     //     print("before seek next");
                      //     //     widget.audioPlayer.play();  // make sure player is playing
                      //     //     widget.audioPlayer.seekToNext();
                      //     //     print("skip next if condition");
                      //     //     //   print("before seek next");
                      //     //     //   widget.audioPlayer.seekToNext();
                      //     //     //   print("skip next if condition");
                      //     //     //   print(widget.audioPlayer.currentIndex);
                      //     //
                      //     //     // try {
                      //     //     //   widget.audioPlayer.seekToNext();
                      //     //     //   print("skip music");
                      //     //     // } catch (error) {
                      //     //     //   print('Skip next Error: $error');
                      //     //     // }
                      //     //
                      //     //   }
                      //     //   print("skip next");
                      //     // },
                      //     child: Container(
                      //       padding: EdgeInsets.all(10),
                      //       child: Icon(
                      //         Icons.skip_next,
                      //         color: myColors.darkGreen,
                      //         size: 40,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                            _player.loopMode == LoopMode.one ? _player.setLoopMode(LoopMode.all) : _player.setLoopMode(LoopMode.one);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: StreamBuilder<LoopMode>(
                              stream: _player.loopModeStream,
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
                              if(_isShuffel){
                                _player.setShuffleModeEnabled(true);
                              }
                              else{
                                _player.setShuffleModeEnabled(false);
                              }
                              _isShuffel = !_isShuffel;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                                Icons.shuffle,
                                color: _isShuffel? myColors.yellow : myColors.darkGreen
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
        //),
      );
    }
    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true
        ),
        builder: (context, item){
          if(item.data == null){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(item.data!.isEmpty){
            return const Center(child: Text("No Music Found"),);
          }
          songs.clear();
          songs = item.data!;
          return ListView.builder(
            itemCount: item.data!.length,
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
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(Icons.music_note),
                  ),
                  title: Text(item.data![index].title),
                  subtitle: Text("${item.data![index].artist}"),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () async {
                    _changePlayerViewVisibility();
                    // String? uri = item.data![index].uri;
                    // await _player.setAudioSource(
                    //   AudioSource.uri(Uri.parse(uri!))
                    // );
                    await _player.setAudioSource(createPlaylist(item.data!), initialIndex: index);
                    await _player.play();
                    toast(context, item.data![index].title.toString());
                  },
                ),
              );
            }
          );
        },
      ),

    );
  }

}

class DurationState {
  Duration position;
  Duration total;
  Duration buffered;
  DurationState({this.position = Duration.zero, this.total = Duration.zero, this.buffered = Duration.zero});
}