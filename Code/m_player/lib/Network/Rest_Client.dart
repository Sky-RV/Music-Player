import 'package:dio/dio.dart';
import 'package:m_player/Models/Album_Base/Album_Base_Model.dart';
import 'package:m_player/Models/Latest_Music/Latest_Music_Model.dart';
import 'package:retrofit/http.dart';

part 'Rest_Client.g.dart';

@RestApi(baseUrl: 'http://mobilemasters.ir/apps/radiojavan/')
abstract class Rest_Client{

  factory Rest_Client(Dio dio, {String baseUrl}) = _Rest_Client;

  @GET('api.php?latest')
  Future<Latest_Music_Model> getLatestMusics();

  @GET('api.php?album_list')
  Future<Album_Base_Model> getAlbums();

}