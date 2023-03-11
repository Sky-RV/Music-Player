import 'package:json_annotation/json_annotation.dart';
import'package:m_player/Models/Album/Album_Model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:m_player/Models/Category/Category_Model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'Category_Base_Model.g.dart';

@JsonSerializable()
class Category_Base_Model{

  @JsonKey(name: "ONLINE_MP3")
  List<Category_Model>? category;

  Category_Base_Model(this.category);

  factory Category_Base_Model.fromJson(Map<String, dynamic> json) => _$Category_Base_ModelFromJson(json);
  Map<String, dynamic> toJson() => _$Category_Base_ModelToJson(this);
}