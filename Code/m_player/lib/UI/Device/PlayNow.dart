import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayNow extends StatefulWidget {
  const PlayNow({Key? key, required this.songModel, required this.audioPlayer}) : super(key: key);

  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<PlayNow> createState() => _PlayNowState();
}

class _PlayNowState extends State<PlayNow> {

  bool _isPlaying = false;

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
              Uri.parse(widget.songModel.uri!)
          )
      );
      widget.audioPlayer.play();
      _isPlaying = true;
    }
    on Exception{
      log("Can not parse song.");
    }
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
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 30,),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      child: Icon(Icons.music_note, size: 80,),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.skip_previous, color: myColors.darkGreen, size: 40,),
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
                          onPressed: (){},
                          icon: Icon(Icons.skip_next, color: myColors.darkGreen, size: 40,),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Text("0:0"),
                        Expanded(
                          child: Slider(
                            value: 0.0,
                            onChanged: (value){},
                          ),
                        ),
                        Text("0:0"),
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
}
