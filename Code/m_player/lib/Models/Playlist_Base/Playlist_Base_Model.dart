import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:m_player/Models/Playlist/Playlist_Model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Playlist_Base_Model.g.dart';

@JsonSerializable()
class Playlist_Base_Model{

  @JsonKey(name: "ONLINE_MP3")
  List<Playlist_Model>? playlists;

  Playlist_Base_Model(this.playlists);

  factory Playlist_Base_Model.fromJson(Map<String, dynamic> json) => _$Playlist_Base_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Playlist_Base_ModelToJson(this);
}