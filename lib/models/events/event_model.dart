import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';   

@JsonSerializable()
class EventsModel {
  @JsonKey(name: "createdAt", includeIfNull: false)
  final int? createdAt; //":"2025-11-18T18:13:55.473Z",
  @JsonKey(name: "name", includeIfNull: false)
  final String? name; //":"Frankie Hamill",
  @JsonKey(name: "avatar", includeIfNull: false)
  final String? avatar; //":"https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/male/512/8.jpg",
  @JsonKey(name: "description", includeIfNull: false)
  final String? description; //":"445",
  @JsonKey(name: "id", includeIfNull: false)
  final String? id;

  EventsModel({
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.description,
    required this.id,
  }); //":"1"

  factory EventsModel.fromJson(Map<String, dynamic> json) =>
      _$EventsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventsModelToJson(this);
}
