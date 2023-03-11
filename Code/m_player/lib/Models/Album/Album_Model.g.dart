// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Album_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album_Model _$Album_ModelFromJson(Map<String, dynamic> json) => Album_Model(
      json['aid'] as String?,
      json['album_name'] as String?,
      json['album_image'] as String?,
      json['album_image_thumb'] as String?,
    );

Map<String, dynamic> _$Album_ModelToJson(Album_Model instance) =>
    <String, dynamic>{
      'aid': instance.aid,
      'album_name': instance.album_name,
      'album_image': instance.album_image,
      'album_image_thumb': instance.album_image_thumb,
    };
