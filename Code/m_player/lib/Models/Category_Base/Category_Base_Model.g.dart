// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Category_Base_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category_Base_Model _$Category_Base_ModelFromJson(Map<String, dynamic> json) =>
    Category_Base_Model(
      (json['ONLINE_MP3'] as List<dynamic>?)
          ?.map((e) => Category_Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Category_Base_ModelToJson(
        Category_Base_Model instance) =>
    <String, dynamic>{
      'ONLINE_MP3': instance.category,
    };
