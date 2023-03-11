// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Artist_Base_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist_Base_Model _$Artist_Base_ModelFromJson(Map<String, dynamic> json) =>
    Artist_Base_Model(
      (json['ONLINE_MP3'] as List<dynamic>?)
          ?.map((e) => Artist_Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Artist_Base_ModelToJson(Artist_Base_Model instance) =>
    <String, dynamic>{
      'ONLINE_MP3': instance.artist,
    };
