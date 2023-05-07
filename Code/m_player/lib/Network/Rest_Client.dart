import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:m_player/Models/Album_Base/Album_Base_Model.dart';
import 'package:m_player/Models/Artist_Base/Artist_Base_Model.dart';
import 'package:m_player/Models/Category_Base/Category_Base_Model.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:m_player/Models/Playlist_Base/Playlist_Base_Model.dart';
import 'package:retrofit/http.dart';

part 'Rest_Client.g.dart';

@RestApi(baseUrl: 'http://mobilemasters.ir/apps/radiojavan/')
abstract class Rest_Client{

  factory Rest_Client(Dio dio, {String baseUrl}) = _Rest_Client;

  @GET('api.php?latest')
  Future<Latest_Music_Model> getLatestMusics();

  @GET('api.php?album_list')
  Future<Album_Base_Model> getAlbums();

  @GET('api.php?playlist')
  Future<Playlist_Base_Model> getPlaylists();

  @GET('api.php?recent_artist_list')
  Future<Artist_Base_Model> getRecentArtists();

  @GET('api.php?cat_list')
  Future<Category_Base_Model> getCategories();

  @GET('api.php')
  Future<Latest_Music_Model> getMusicsByCategory(@Query("cat_id") String id);

  @GET('api.php')
  Future<Latest_Music_Model> getMusicsByAlbum(@Query("aid") String id);

  @GET('api.php')
  Future<Latest_Music_Model> getMusicByPlaylists(@Query("pid") String id);

  @GET('api.php')
  Future<Latest_Music_Model> getMusicByArtists(@Query("mp3_artist") String name);

}