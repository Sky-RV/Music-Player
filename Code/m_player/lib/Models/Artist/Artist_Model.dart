import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Artist_Model.g.dart';

@JsonSerializable()
class Artist_Model{

  String? id;
  String? artist_name;
  String? artist_image;
  String? artist_image_thumb;

  Artist_Model(
      this.id, this.artist_name, this.artist_image, this.artist_image_thumb);

  factory Artist_Model.fromJson(Map<String, dynamic> json) => _$Artist_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Artist_ModelToJson(this);
}