import 'dart:convert';

class AuthSuccessModel {
  String accessToken;
  String tokenType;
  int expiresIn;

  AuthSuccessModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthSuccessModel.fromRawJson(String str) =>
      AuthSuccessModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthSuccessModel.fromJson(Map<String, dynamic> json) =>
      AuthSuccessModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
      };
}
