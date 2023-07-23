import 'dart:convert';

class GetSongListErrorModel {
  Error error;

  GetSongListErrorModel({
    required this.error,
  });

  factory GetSongListErrorModel.fromRawJson(String str) =>
      GetSongListErrorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSongListErrorModel.fromJson(Map<String, dynamic> json) =>
      GetSongListErrorModel(
        error: Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error.toJson(),
      };
}

class Error {
  int status;
  String message;

  Error({
    required this.status,
    required this.message,
  });

  factory Error.fromRawJson(String str) => Error.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
