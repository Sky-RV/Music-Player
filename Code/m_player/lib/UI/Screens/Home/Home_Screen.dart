import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m_player/Models/Album_Base_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/Models/Latest_Music_Model.dart';
import 'package:m_player/Utils/MyColors.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getLatestMusics = rest_client.getLatestMusics();
    getAlbums = rest_client.getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: myColors.white,

      body: Container(
        child: Column(
          children: [
            FutureBuilder<Latest_Music_Model>(
              future: getLatestMusics,
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Container(
                   // width: MediaQuery.of(context).size.width, // New Music text would be in the center
                   // height: MediaQuery.of(context).size.height,
                    child: Column(
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

                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   itemCount: snapshot.data!.musics!.length,
                        //   scrollDirection: Axis.horizontal,
                        //   itemBuilder: (context, index){
                        //     return Container(
                        //       width: 164,
                        //       height: 164,
                        //       child: Card(
                        //
                        //       ),
                        //     );
                        //   },
                        // ),

                        Container(
                          height: 180,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.musics!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                              return CachedNetworkImage(
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
                                                "${snapshot.data!.musics![index].mp3_artist}",
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
                              );
                              // return CachedNetworkImage(
                              //   width: 164,
                              //   height: 164,
                              //   imageUrl: "${snapshot.data!.musics![index].mp3_thumbnail_b}",
                              //   imageBuilder: (context, imageProvider) => Container(
                              //     margin: EdgeInsets.all(8),
                              //     decoration: BoxDecoration(
                              //       image: DecorationImage(
                              //           image: imageProvider,
                              //          // colorFilter:
                              //           //ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                              //       )
                              //       ),
                              //     child: Stack(
                              //       children: [
                              //         Positioned(
                              //           child: Container(
                              //             decoration: BoxDecoration(
                              //               gradient: LinearGradient(
                              //                  colors: [
                              //                    Colors.amber,
                              //                    myColors.yellow,
                              //                    Colors.amberAccent
                              //                  ]
                              //               ),
                              //             ),
                              //             child: Center(
                              //               child: Text(
                              //                 '${snapshot.data!.musics![index].mp3_title}',
                              //                 style: TextStyle(fontSize: 16),
                              //               ),
                              //             ),
                              //           ),
                              //           bottom: 5,
                              //           right: 0,
                              //           left: 0,
                              //         )
                              //       ],
                              //     )
                              //   ),
                              //   placeholder: (context, url) => CircularProgressIndicator(),
                              //   errorWidget: (context, url, error) => Icon(Icons.error),
                              // );
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
                              return CachedNetworkImage(
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
            )
          ],
        ),
      ),
    );
  }
}
