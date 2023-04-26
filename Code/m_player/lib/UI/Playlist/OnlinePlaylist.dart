import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m_player/Models/Playlist/Playlist_Model.dart';
import 'package:m_player/Models/Playlist_Base/Playlist_Base_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/Utils/MyColors.dart';

class OnlinePlaylist extends StatefulWidget {
  const OnlinePlaylist({Key? key}) : super(key: key);

  @override
  State<OnlinePlaylist> createState() => _OnlinePlaylistState();
}

class _OnlinePlaylistState extends State<OnlinePlaylist> {

  final dio = Dio();
  late Rest_Client rest_client;
  late Future<Playlist_Base_Model> getPlaylists;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getPlaylists = rest_client.getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBody: true,

      backgroundColor: myColors.white,

      body: Container(
        child: FutureBuilder<Playlist_Base_Model>(
          future: getPlaylists,
          builder: (context, snapshot){
            if (snapshot.hasData){
              return Container(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.playlists!.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => MusicsCategoryScreen(category: snapshot.data!.musics![index],))
                        // );
                      },
                      child: CachedNetworkImage(
                        width: 164,
                        height: 164,
                        imageUrl: "${snapshot.data!.playlists![index].playlist_image}",
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
                                      "${snapshot.data!.playlists![index].playlist_name}",
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
