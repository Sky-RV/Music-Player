// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Latest_Music_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Latest_Music_Model _$Latest_Music_ModelFromJson(Map<String, dynamic> json) =>
    Latest_Music_Model(
      (json['ONLINE_MP3'] as List<dynamic>?)
          ?.map((e) => Music_Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Latest_Music_ModelToJson(Latest_Music_Model instance) =>
    <String, dynamic>{
      'ONLINE_MP3': instance.musics,
    };
