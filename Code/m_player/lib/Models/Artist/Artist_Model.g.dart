// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Artist_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist_Model _$Artist_ModelFromJson(Map<String, dynamic> json) => Artist_Model(
      json['id'] as String?,
      json['artist_name'] as String?,
      json['artist_image'] as String?,
      json['artist_image_thumb'] as String?,
    );

Map<String, dynamic> _$Artist_ModelToJson(Artist_Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'artist_name': instance.artist_name,
      'artist_image': instance.artist_image,
      'artist_image_thumb': instance.artist_image_thumb,
    };
