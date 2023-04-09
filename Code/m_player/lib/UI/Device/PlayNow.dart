import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:m_player/Provider/Song_Model_Provider.dart';
// import 'package:m_player/Provider/Song_Model_Provider.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';


class PlayNow extends StatefulWidget {
  const PlayNow({Key? key, required this.songModel, required this.audioPlayer}) : super(key: key);

  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<PlayNow> createState() => _PlayNowState();
}

class _PlayNowState extends State<PlayNow> {

  bool _isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isShuffel = false;
  bool _isRepeat = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }

  void playSong(){
    try {
      widget.audioPlayer.setAudioSource(
          AudioSource.uri(
              Uri.parse(widget.songModel.uri!),
            tag: MediaItem(
              id: '${widget.songModel.id}',
              album: '${widget.songModel.album}',
              title: '${widget.songModel.displayNameWOExt}',
              artUri: Uri.parse('https://example.com/albumart.jpg'),
            ),
          ),
      );
      widget.audioPlayer.play();
      _isPlaying = true;
      _isShuffel = false;
      _isRepeat = false;
    }
    on Exception{
      log("Can not parse song.");
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IconButton(
              //   icon: Icon(Icons.arrow_back_ios),
              //   onPressed: (){
              //     Navigator.pop(context);
              //   },
              // ),
              SizedBox(height: 30,),
              Center(
                child: Column(
                  children: [
                    // CircleAvatar(
                    //   radius: 100,
                    //   child: Icon(Icons.music_note, size: 80,),
                    // ),
                    Center(
                      // child: const ArtWorkWidget(),
                      child: QueryArtworkWidget(
                          id: widget.songModel.id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 200.0,
                          artworkWidth: 200.0,
                          artworkFit: BoxFit.cover,
                          nullArtworkWidget: Icon(Icons.music_note, color: myColors.darkGreen, size: 200,),
                        ),
                    ),
                    SizedBox(height: 30,),
                    Text(
                      widget.songModel.displayNameWOExt,
                      // overflow: TextOverflow.fade,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 30,),

                    Text(
                      widget.songModel.artist.toString() == "<unknown>" ? "Unknown Artist" : widget.songModel.artist.toString(),
                      // overflow: TextOverflow.fade,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 30,),
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
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: (){
                              if(widget.audioPlayer.hasPrevious){
                                widget.audioPlayer.seekToPrevious();
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
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if(_isPlaying){
                                widget.audioPlayer.pause();
                              }
                              else {
                                widget.audioPlayer.play();
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: myColors.darkGreen, size: 40,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: myColors.darkGreen,
                            size: 40,
                          ),
                          onPressed: (){
                            setState(() {
                              try {
                                if (widget.audioPlayer.hasNext) {
                                  print("before seek next");
                                  widget.audioPlayer.seekToNext();
                                  print("skip next if condition");
                                }
                                print("skip next");
                              } catch (e) {
                                print("Error seeking to next song: $e");
                              }
                              print(widget.audioPlayer.playerState);
                              print(widget.audioPlayer.hasNext);
                              print(widget.audioPlayer.hasPrevious);
                              print(widget.audioPlayer.currentIndex);
                              print(widget.audioPlayer.audioSource.toString());
                            });
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
                              widget.audioPlayer.loopMode == LoopMode.one ? widget.audioPlayer.setLoopMode(LoopMode.all) : widget.audioPlayer.setLoopMode(LoopMode.one);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: StreamBuilder<LoopMode>(
                                stream: widget.audioPlayer.loopModeStream,
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
                                  widget.audioPlayer.setShuffleModeEnabled(true);
                                }
                                else{
                                  widget.audioPlayer.setShuffleModeEnabled(false);
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
            ],
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int sec){
    Duration duration = Duration(seconds: sec);
    widget.audioPlayer.seek(duration);
  }

}

// class ArtWorkWidget extends StatelessWidget {
//   const ArtWorkWidget({
//     Key? key,
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return QueryArtworkWidget(
//       id: context.watch<Song_Model_Provider>().id,
//       type: ArtworkType.AUDIO,
//       artworkHeight: 200.0,
//       artworkWidth: 200.0,
//       artworkFit: BoxFit.cover,
//       nullArtworkWidget: Icon(Icons.music_note, color: myColors.darkGreen, size: 150,),
//     );
//   }
// }