import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaySearch extends StatefulWidget {

  final List<SongModel> songs;
  final int currentIndex;
  final Duration position;
  final Duration duration;
  final AudioPlayer player;

  const PlaySearch({Key? key,
    required this.songs,
    required this.currentIndex,
    required this.position,
    required this.duration,
    required this.player}) : super(key: key);

  @override
  State<PlaySearch> createState() => _PlaySearchState();
}

class _PlaySearchState extends State<PlaySearch> {

  bool isShuffel = false;

  void changeToSeconds(int sec){
    Duration duration = Duration(seconds: sec);
    widget.player.seek(duration);
  }

  @override
  Widget build(BuildContext context) {

      return Stack(
        children: [
          SingleChildScrollView(
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
                      id: widget.songs[widget.currentIndex].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(200.0),
                    ),
                  ),

                  Text(
                    widget.songs[widget.currentIndex].displayNameWOExt,
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
                    widget.songs[widget.currentIndex].artist.toString() == "<unknown>" ?
                    "Unknown Artist" : widget.songs[widget.currentIndex].artist.toString(),
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
                      Text(widget.position.toString().split(".")[0]),
                      Expanded(
                        child: Slider(
                          value: widget.position.inSeconds.toDouble(),
                          max: widget.duration.inSeconds.toDouble(),
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
                      Text(widget.duration.toString().split(".")[0]),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            if(widget.player.hasPrevious){
                              widget.player.seekToPrevious();
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
                            if(widget.player.playing){
                              widget.player.pause();
                            }
                            else{
                              if(widget.player.currentIndex != null){
                                widget.player.play();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(top: 20, left: 20),
                            child: StreamBuilder<bool>(
                              stream: widget.player.playingStream,
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
                          if(widget.player.hasNext){
                            widget.player.seekToNext();
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
                            widget.player.loopMode == LoopMode.one ? widget.player.setLoopMode(LoopMode.all) : widget.player.setLoopMode(LoopMode.one);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: StreamBuilder<LoopMode>(
                              stream: widget.player.loopModeStream,
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
                                widget.player.setShuffleModeEnabled(true);
                              }
                              else{
                                widget.player.setShuffleModeEnabled(false);
                              }
                              isShuffel = !isShuffel;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                                Icons.shuffle,
                                color: isShuffel? myColors.yellow : myColors.darkGreen
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
                                          'Choose Playlist :',
                                          style: TextStyle(color: myColors.darkGreen),
                                        ),
                                      ),
                                      color: myColors.yellow.withOpacity(0.7),
                                    ),
                                    content: setupAlertDialoadContainer(context, widget.songs[widget.currentIndex].id),
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
          )
        ],
      );
  }
}

Widget setupAlertDialoadContainer(context , audioId) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: MediaQuery.of(context).size.height / 2, // Change as per your requirement
        width: MediaQuery.of(context).size.width, // Change as per your requirement
        child: FutureBuilder<List<PlaylistModel>>(
          future: OnAudioQuery.platform.queryPlaylists(
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
              return const Center(child: Text("No Playlist."),);
            }
            return ListView.builder(
              itemCount: item.data!.length,
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
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(Icons.featured_play_list),
                    ),
                    title: Text(item.data![index].playlist),
                    subtitle: Text("${item.data![index].numOfSongs}"),
                    onTap: () async {
                      int playlistId = item.data![index].id;
                      print("playlist " + playlistId.toString());
                      print("song id "+ audioId.toString());
                      await OnAudioQuery.platform.addToPlaylist(playlistId, audioId);
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
          },child: Text("Cancel"),),
      )
    ],
  );
}