import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  @JsonKey(name: "username",includeIfNull: false)
  final String? username;//": "string",
  @JsonKey(name: "email",includeIfNull: false)
  final String? email;//": "string",
  @JsonKey(name: "name",includeIfNull: false)
  final String? name; //": "Kishore QA",
  @JsonKey(name: "job",includeIfNull: false)
  final String? job; //": "Technical Consultant",
  @JsonKey(name: "password",includeIfNull: false)
  final String password; //": "123456",
  @JsonKey(name: "id",includeIfNull: false)
  final String? id; //": "997",
  @JsonKey(name: "createdAt",includeIfNull: false)
  final String? createdAt;

  AuthModel({
     this.name,
     this.job,
    required this.password,
    this.id,
    this.createdAt,
    this.email,
    this.username
  }); //": "2025-11-18T05:00:03.448Z"

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}

@JsonSerializable()
class AuthResponse {

  @JsonKey(name: "token")
  final String? token;

  AuthResponse({
    required this.token,
  }); //": "QpwL5tke4Pnpja7X4"

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
