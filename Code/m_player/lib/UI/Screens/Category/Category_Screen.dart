import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Models/Category_Base/Category_Base_Model.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:m_player/Network/Rest_Client.dart';
import 'package:m_player/UI/Screens/Device/Device_Screen_New.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:m_player/UI/Screens/Music_Category/Musics_Category_Screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final dio = Dio();
  late Rest_Client rest_client;
  late Future<Category_Base_Model> getCategories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rest_client = Rest_Client(dio);
    getCategories = rest_client.getCategories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: myColors.white,

      body: Container(
        child: FutureBuilder<Category_Base_Model>(
          future: getCategories,
          builder: (cotext, snapshot){
            if (snapshot.hasData){
              return Container(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.category!.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              MusicsCategoryScreen(
                                category: snapshot.data!.category![index],
                              )
                          )
                        );
                      },
                      child: CachedNetworkImage(
                        width: 164,
                        height: 164,
                        imageUrl: "${snapshot.data!.category![index].category_image}",
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
                                      "${snapshot.data!.category![index].category_name}",
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
                child: Text("ارور! لطفا اتصال به اینترنت خود را چک کنید."),
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
