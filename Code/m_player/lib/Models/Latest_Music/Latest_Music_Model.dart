import 'package:json_annotation/json_annotation.dart';
import 'package:m_player/Models/Music/Music_Model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Latest_Music_Model.g.dart';

@JsonSerializable()
class Latest_Music_Model{

  @JsonKey(name: "ONLINE_MP3")
  List<Music_Model>? musics;

  Latest_Music_Model(this.musics);

  factory Latest_Music_Model.fromJson(Map<String, dynamic> json) => _$Latest_Music_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Latest_Music_ModelToJson(this);
}