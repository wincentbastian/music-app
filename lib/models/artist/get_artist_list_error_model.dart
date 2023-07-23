import 'dart:convert';

class GetArtistListErrorModel {
  Error error;

  GetArtistListErrorModel({
    required this.error,
  });

  factory GetArtistListErrorModel.fromRawJson(String str) =>
      GetArtistListErrorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetArtistListErrorModel.fromJson(Map<String, dynamic> json) =>
      GetArtistListErrorModel(
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
