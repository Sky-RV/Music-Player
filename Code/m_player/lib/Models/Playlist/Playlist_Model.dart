import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Playlist_Model.g.dart';

@JsonSerializable()
class Playlist_Model{

  String? pid;
  String? playlist_name;
  String? playlist_image;
  String? playlist_image_thumb;

  Playlist_Model(this.pid, this.playlist_name, this.playlist_image,
      this.playlist_image_thumb);

  factory Playlist_Model.fromJson(Map<String, dynamic> json) => _$Playlist_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Playlist_ModelToJson(this);

}