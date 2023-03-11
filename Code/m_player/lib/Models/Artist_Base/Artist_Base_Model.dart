import 'package:json_annotation/json_annotation.dart';
import'package:m_player/Models/Album/Album_Model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:m_player/Models/Artist/Artist_Model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Artist_Base_Model.g.dart';

@JsonSerializable()
class Artist_Base_Model{

  @JsonKey(name: "ONLINE_MP3")
  List<Artist_Model>? artist;

  Artist_Base_Model(this.artist);

  factory Artist_Base_Model.fromJson(Map<String, dynamic> json) => _$Artist_Base_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Artist_Base_ModelToJson(this);
}