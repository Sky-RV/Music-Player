// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Category_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category_Model _$Category_ModelFromJson(Map<String, dynamic> json) =>
    Category_Model(
      json['cid'] as String?,
      json['category_name'] as String?,
      json['category_image'] as String?,
      json['category_image_thumb'] as String?,
    );

Map<String, dynamic> _$Category_ModelToJson(Category_Model instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'category_name': instance.category_name,
      'category_image': instance.category_image,
      'category_image_thumb': instance.category_image_thumb,
    };
