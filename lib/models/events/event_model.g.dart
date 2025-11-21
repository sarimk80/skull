// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsModel _$EventsModelFromJson(Map<String, dynamic> json) => EventsModel(
  createdAt: (json['createdAt'] as num?)?.toInt(),
  name: json['name'] as String?,
  avatar: json['avatar'] as String?,
  description: json['description'] as String?,
  id: json['id'] as String?,
);

Map<String, dynamic> _$EventsModelToJson(EventsModel instance) =>
    <String, dynamic>{
      'createdAt': ?instance.createdAt,
      'name': ?instance.name,
      'avatar': ?instance.avatar,
      'description': ?instance.description,
      'id': ?instance.id,
    };
