import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Category_Model.g.dart';

@JsonSerializable()
class Category_Model{

  String? cid;
  String? category_name;
  String? category_image;
  String? category_image_thumb;


  Category_Model(this.cid, this.category_name, this.category_image,
      this.category_image_thumb);

  factory Category_Model.fromJson(Map<String, dynamic> json) => _$Category_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Category_ModelToJson(this);

}