import 'package:json_annotation/json_annotation.dart';
import'package:m_player/Models/Album/Album_Model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Album_Base_Model.g.dart';

@JsonSerializable()
class Album_Base_Model{

  @JsonKey(name: "ONLINE_MP3")
  List<Album_Model>? albums;

  Album_Base_Model(this.albums);

  factory Album_Base_Model.fromJson(Map<String, dynamic> json) => _$Album_Base_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Album_Base_ModelToJson(this);
}