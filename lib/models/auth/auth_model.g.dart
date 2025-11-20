// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
  name: json['name'] as String?,
  job: json['job'] as String?,
  password: json['password'] as String,
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  email: json['email'] as String?,
  username: json['username'] as String?,
);

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
  'username': ?instance.username,
  'email': ?instance.email,
  'name': ?instance.name,
  'job': ?instance.job,
  'password': instance.password,
  'id': ?instance.id,
  'createdAt': ?instance.createdAt,
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    AuthResponse(token: json['token'] as String?);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{'token': instance.token};
