// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Album_Base_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album_Base_Model _$Album_Base_ModelFromJson(Map<String, dynamic> json) =>
    Album_Base_Model(
      (json['ONLINE_MP3'] as List<dynamic>?)
          ?.map((e) => Album_Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Album_Base_ModelToJson(Album_Base_Model instance) =>
    <String, dynamic>{
      'ONLINE_MP3': instance.albums,
    };
