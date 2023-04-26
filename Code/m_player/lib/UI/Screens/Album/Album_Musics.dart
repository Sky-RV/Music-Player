import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m_player/Models/Album/Album_Model.dart';
import 'package:m_player/Models/Album_Base/Album_Base_Model.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/Utils/MyColors.dart';

class Album_Musics_Screen extends StatefulWidget {

  final Album_Model album;
  const Album_Musics_Screen({Key? key, required this.album}) : super(key: key);

  @override
  State<Album_Musics_Screen> createState() => _Album_MusicsState();
}

class _Album_MusicsState extends State<Album_Musics_Screen> {

  final dio = Dio();
  late Rest_Client rest_client;
  late Future<Latest_Music_Model> getMusics;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getMusics = rest_client.getMusicsByAlbum(widget.album.aid!);
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
        title: Text('${widget.album.album_name}', style: TextStyle(color: myColors.darkGreen)),
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => MusicsCategoryScreen(category: snapshot.data!.musics![index],))
                        // );
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
