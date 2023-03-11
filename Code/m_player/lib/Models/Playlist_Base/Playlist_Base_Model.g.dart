// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Playlist_Base_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist_Base_Model _$Playlist_Base_ModelFromJson(Map<String, dynamic> json) =>
    Playlist_Base_Model(
      (json['ONLINE_MP3'] as List<dynamic>?)
          ?.map((e) => Playlist_Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Playlist_Base_ModelToJson(
        Playlist_Base_Model instance) =>
    <String, dynamic>{
      'ONLINE_MP3': instance.playlists,
    };
