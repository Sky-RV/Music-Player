import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:m_player/Utils/MyColors.dart';

class PlayMusics_Online extends StatefulWidget {

  final Music_Model music_model;
  final AudioPlayer audioPlayer;
  final List<Music_Model> list;

  const PlayMusics_Online({Key? key,
    required this.music_model,
    required this.audioPlayer,
    required this.list,
  }) : super(key: key);

  @override
  State<PlayMusics_Online> createState() => _PlayMusics_OnlineState();
}

class _PlayMusics_OnlineState extends State<PlayMusics_Online> {

  bool _isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isShuffel = false;
  bool _isRepeat = false;
  bool currantStatePlay = false;
  int currentIndex = 0;
  String currentSongTitle = '';

  List<Music_Model> mylist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
    widget.audioPlayer.currentIndexStream.listen((index) {
      if(index != null){
        _updateCurrentPlayingSongDetails(index);
        print("update bla nla vla");
        for(var item in mylist){
          print(item);
        }
      }
    });
  }

  void _updateCurrentPlayingSongDetails(int index){
    setState(() {
      if(mylist.isNotEmpty){
        currentSongTitle = mylist[index].mp3_title!;
        currentIndex = index;
        print("in the update func.");
      }
    });
  }

  loadMusic() async{
    await widget.audioPlayer.setUrl(widget.music_model.mp3_url!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.audioPlayer.dispose();
    super.dispose();
  }

  void playSong(){
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.music_model.mp3_url!),
          tag: MediaItem(
            id: '${widget.music_model.id}',
            displayDescription: '${widget.music_model.mp3_description}',
            album: '${widget.music_model.category_name}',
            title: '${widget.music_model.mp3_title}',
            artUri: Uri.parse('https://example.com/albumart.jpg'),
          ),
        ),
      );
      widget.audioPlayer.setAudioSource(createPlaylist(widget.list));
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

  ConcatenatingAudioSource createPlaylist(List<Music_Model> songs){
    List<AudioSource> sources = [];
    for (var song in songs){
      sources.add(AudioSource.uri(Uri.parse(song.mp3_url!)));
    }
    return ConcatenatingAudioSource(children: sources);
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
              SizedBox(height: 30,),
              Center(
                child: Column(
                  children: [
                    Center(
                      // child: const ArtWorkWidget(),
                      child: QueryArtworkWidget(
                        id: int.parse(widget.music_model.id.toString()),
                        type: ArtworkType.AUDIO,
                        artworkHeight: 200.0,
                        artworkWidth: 200.0,
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Icon(Icons.music_note, color: myColors.darkGreen, size: 200,),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text(
                      widget.music_model.mp3_title.toString(),
                      // mylist[currentIndex].mp3_title.toString(),
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
                      widget.music_model.mp3_artist.toString() == "<unknown>" ? "Unknown Artist" : widget.music_model.mp3_artist.toString(),
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
                              print(widget.audioPlayer.hasNext);
                              print(widget.audioPlayer.hasPrevious);
                              print(widget.audioPlayer.currentIndex);
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 30,),

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
