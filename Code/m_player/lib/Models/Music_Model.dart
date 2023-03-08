import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Music_Model.g.dart';

@JsonSerializable()
class Music_Model {
  String? id;
  String? cat_id;
  String? mp3_title;
  String? mp3_url;
  String? mp3_thumbnail_b;
  String? mp3_thumbnail_s;
  String? mp3_duration;
  String? mp3_artist;
  String? mp3_description;
  String? cid;
  String? category_name;
  String? category_image;
  String? category_image_thumb;

  Music_Model(
      this.id,
      this.cat_id,
      this.mp3_title,
      this.mp3_url,
      this.mp3_thumbnail_b,
      this.mp3_thumbnail_s,
      this.mp3_duration,
      this.mp3_artist,
      this.mp3_description,
      this.cid,
      this.category_name,
      this.category_image,
      this.category_image_thumb);

  factory Music_Model.fromJson(Map<String, dynamic> json) => _$Music_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Music_ModelToJson(this);
}