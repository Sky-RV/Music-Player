import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Album_Model.g.dart';

@JsonSerializable()
class Album_Model{

  String? aid;
  String? album_name;
  String? album_image;
  String? album_image_thumb;

  Album_Model(this.aid, this.album_name, this.album_image,
      this.album_image_thumb);

  factory Album_Model.fromJson(Map<String, dynamic> json) => _$Album_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Album_ModelToJson(this);

}