// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Playlist_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist_Model _$Playlist_ModelFromJson(Map<String, dynamic> json) =>
    Playlist_Model(
      json['pid'] as String?,
      json['playlist_name'] as String?,
      json['playlist_image'] as String?,
      json['playlist_image_thumb'] as String?,
    );

Map<String, dynamic> _$Playlist_ModelToJson(Playlist_Model instance) =>
    <String, dynamic>{
      'pid': instance.pid,
      'playlist_name': instance.playlist_name,
      'playlist_image': instance.playlist_image,
      'playlist_image_thumb': instance.playlist_image_thumb,
    };
