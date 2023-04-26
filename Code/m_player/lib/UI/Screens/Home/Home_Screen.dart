import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Models/Album_Base/Album_Base_Model.dart';
import 'package:m_player/Models/Artist_Base/Artist_Base_Model.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:m_player/Models/Playlist_Base/Playlist_Base_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/UI/Screens/Album/Album_Musics.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:miniplayer/miniplayer.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final dio = Dio();
  late Rest_Client rest_client;
  late Future<Latest_Music_Model> getLatestMusics;
  late Future<Album_Base_Model> getAlbums;
  late Future<Playlist_Base_Model> getPlaylists;
  late Future<Artist_Base_Model> getResentArtist;

  bool isPlay = false;

  late Music_Model currentMusic;

  bool currantStatePlay = false;

  final player = AudioPlayer();

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getLatestMusics = rest_client.getLatestMusics();
    getAlbums = rest_client.getAlbums();
    getPlaylists = rest_client.getPlaylists();
    getResentArtist = rest_client.getRecentArtists();
  }

  loadMusic() async {
    await player.setUrl(currentMusic.mp3_url!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: myColors.white,

      body: Stack(
        children: [

          Container(
            padding: EdgeInsets.only(bottom: 70),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<Playlist_Base_Model>(
                    future: getPlaylists,
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        List<Widget> imagesList = [];
                        for(int i=0; i<snapshot.data!.playlists!.length; i++){
                          imagesList.add(CachedNetworkImage(
                            imageUrl: '${snapshot.data!.playlists![i].playlist_image}',
                            width: double.infinity,
                            height: 200,
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: myColors.darkGreen),),
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            fit: BoxFit.cover,
                          ));
                        }
                        return Container(
                          height: 200,
                          child: ImageSlideshow(
                            width: double.infinity,
                            height: 200,
                            initialPage: 0,
                            indicatorColor: myColors.yellow,
                            indicatorBackgroundColor: myColors.white,
                            indicatorRadius: 3,
                            autoPlayInterval: 3000, // 3s
                            isLoop: true,
                            onPageChanged: (value) {
                              print('Page changed: $value');
                            },
                            children: imagesList,
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

                  FutureBuilder<Latest_Music_Model>(
                    future: getLatestMusics,
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        return Container(
                          // width: MediaQuery.of(context).size.width, // New Music text would be in the center
                          // height: MediaQuery.of(context).size.height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                child: Text(
                                  "New Musics",
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: myColors.green
                                  ),
                                ),
                              ),

                              Container(
                                height: 180,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.musics!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    return InkWell(
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
                                      onTap: (){
                                        setState(() {
                                          isPlay = true;
                                          currantStatePlay = true;
                                          currentMusic = snapshot.data!.musics![index];
                                        });
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
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

                  FutureBuilder<Album_Base_Model>(
                    future: getAlbums,
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                child: Text(
                                  "New Albums",
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: myColors.green
                                  ),
                                ),
                              ),

                              Container(
                                height: 160,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.albums!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push( //category: snapshot.data!.category![index],
                                            context,
                                            MaterialPageRoute(builder: (context) => Album_Musics_Screen(album: snapshot.data!.albums![index]))
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        width: 180,
                                        height: 160,
                                        imageUrl: "${snapshot.data!.albums![index].album_image}",
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
                                                      "${snapshot.data!.albums![index].album_name}",
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
                              )
                            ],
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

                  FutureBuilder<Artist_Base_Model>(
                    future: getResentArtist,
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: Text(
                                "Latest Artists",
                                style: TextStyle(
                                    fontSize: 26,
                                    color: myColors.green
                                ),
                              ),
                            ),
                            Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.artist!.length,
                                itemBuilder: (context, index){
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: CircleAvatar(
                                          radius: 60,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: "${snapshot.data!.artist![index].artist_image}",
                                              imageBuilder: (context, imageProvider) => Container(
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${snapshot.data!.artist![index].artist_name}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: myColors.darkGreen
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
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
                  )
                ],
              ),
            ),
          ),

          if (isPlay == true)
            Container(
            margin: EdgeInsets.only(bottom: 70),
            child: Miniplayer(

              maxHeight: MediaQuery.of(context).size.height,
              minHeight: 70,
              builder: (height, percentage){
                loadMusic();
                if(height == 70){
                  return Container(
                    decoration: BoxDecoration(
                        color: myColors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: '${currentMusic.mp3_thumbnail_s}',
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(width: 8,),
                              Text(
                                '${currentMusic.mp3_title}',
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await player.seekToNext();
                                  print("next");
                                },
                                icon: Icon(Icons.skip_previous, color: myColors.darkGreen,),
                              ),
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    currantStatePlay = !currantStatePlay;
                                  });
                                  if(currantStatePlay == false){
                                    await player.play();
                                  }
                                  else{
                                    await player.pause();
                                  }
                                },
                                icon: Icon(currantStatePlay == false ? Icons.pause : Icons.play_arrow, color: myColors.darkGreen,),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await player.seekToPrevious();
                                },
                                icon: Icon(Icons.skip_next, color: myColors.darkGreen,),
                              ),
                              SizedBox(width: 10,)
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
                else{
                  return Container(
                    decoration: BoxDecoration(
                        color: myColors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    // child: Container(
                    //     child: ImageFiltered(
                    //       imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    //       child: CachedNetworkImage(
                    //         width: 180,
                    //         height: 160,
                    //         imageUrl: "${currentMusic.mp3_thumbnail_b}",
                    //         imageBuilder: (context, imageProvider) => Container(
                    //           margin: EdgeInsets.all(8),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(15.0),
                    //             image: DecorationImage(
                    //               image: imageProvider,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //           // child: ClipRRect(
                    //           //   child: BackdropFilter(
                    //           //     filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    //           //     child: Container(
                    //           //       alignment: Alignment.center,
                    //           //       color: Colors.grey.withOpacity(0.1),
                    //           //       child: Text("Hi"),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //         ),
                    //       ),
                    //     ),
                    // ),
                    child: Container(
                        child: CachedNetworkImage(
                          imageUrl: "${currentMusic.mp3_thumbnail_b}",
                          imageBuilder: (context, imageProvider) => Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.grey.withOpacity(0.1),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          width: 264,
                                          height: 264,
                                          imageUrl: "${currentMusic.mp3_thumbnail_b}",
                                          imageBuilder: (context, imageProvider) => Container(
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),

                                          ),
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),

                                        SizedBox(height: 16,),

                                        Text(
                                          '${currentMusic.mp3_title}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                          ),
                                        ),

                                        Text(
                                          '${currentMusic.mp3_artist}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16
                                          ),
                                        ),

                                        SizedBox(height: 16,),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: (){
                                                if(player.hasPrevious){
                                                  player.seekToPrevious();
                                                  print("skip previous if condition");
                                                }
                                                print("skip previous");
                                              },
                                              icon: Icon(Icons.skip_previous, color: myColors.darkGreen, size: 48, ),
                                            ),
                                            SizedBox(width: 30,),
                                            IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  currantStatePlay = !currantStatePlay;
                                                });
                                                if(currantStatePlay == false){
                                                  await player.play();
                                                }
                                                else{
                                                  await player.pause();
                                                }
                                              },
                                              icon: Icon(currantStatePlay == true ? Icons.play_arrow : Icons.pause, color: myColors.darkGreen, size: 48,),
                                            ),
                                            SizedBox(width: 30,),
                                            IconButton(
                                              // onPressed: () async {
                                              //   await player.seekToNext();
                                              // },
                                              onPressed: (){
                                                if(player.hasNext){
                                                  player.seekToNext();
                                                  print("skip previous if condition");
                                                }
                                              },
                                              icon: Icon(Icons.skip_next, color: myColors.darkGreen, size: 48,),
                                            ),
                                          ],
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
                                        // IconButton(
                                        //   onPressed: () async {
                                        //     await player.shuffle();
                                        //   },
                                        //   icon: Icon(Icons.shuffle, color: myColors.darkGreen, size: 28,),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                  );
                }
              },
            ),
          )

        ],
      ),
    );
  }
  void changeToSeconds(int sec){
    Duration duration = Duration(seconds: sec);
    player.seek(duration);
  }
}
