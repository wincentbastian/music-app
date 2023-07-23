import 'dart:convert';

class AuthErrorModel {
  String error;
  String errorDescription;

  AuthErrorModel({
    required this.error,
    required this.errorDescription,
  });

  factory AuthErrorModel.fromRawJson(String str) =>
      AuthErrorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthErrorModel.fromJson(Map<String, dynamic> json) => AuthErrorModel(
        error: json["error"],
        errorDescription: json["error_description"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "error_description": errorDescription,
      };
}
