import 'dart:convert';
import 'dart:io';

import 'package:music_app/models/auth/auth_error_model.dart';
import 'package:music_app/models/auth/auth_success_model.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/utils/constant.dart';

/// A class responsible for making HTTP requests related to authentication.
class AuthRequst {
  /// Retrieves the authentication token from Spotify using the client credentials flow.
  ///
  /// The method returns an [AuthSuccessModel] containing the authentication token
  /// if the request is successful or throws an [AuthErrorModel] if an error occurs.
  ///
  /// The authentication token is fetched from the Spotify API by sending a POST
  /// request to the "https://accounts.spotify.com/api/token" endpoint.
  /// The request is made with the client ID and client secret encoded in the headers.
  ///
  /// Throws a [SocketException] if the request times out or there is no internet connection.
  Future<AuthSuccessModel> getToken() async {
    // Define the URL to request the authentication token from Spotify
    Uri url = Uri.parse("https://accounts.spotify.com/api/token");

    var header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization':
          "Basic ${base64Encode(utf8.encode('${Constant.clientId}:${Constant.clientSecret}'))}"
    };

    // Define the request body with the grant_type required for cleint credentials flow
    Map<String, String> body = {'grant_type': 'client_credentials'};

    // Encode the request body to be sent as form data
    String encodedBody = body.keys.map((key) {
      return "${Uri.encodeComponent(key)}=${Uri.encodeComponent(body[key]!)}";
    }).join('&');

    // Send the POST request to fetch the authentication token
    var response = await http
        .post(url, headers: header, body: encodedBody)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      // Handle timeout and throw a SocketException when no internet connection
      throw const SocketException(
          "No internet connection, press music icon after you have connection again");
    });

    if (response.statusCode == 200) {
      // If the response status code is 200, parse and return the AuthSuccessModel
      return AuthSuccessModel.fromJson(jsonDecode(response.body));
    } else {
      // If the response status code is not 200, parse and throw the AuthErrorModel
      throw AuthErrorModel.fromJson(jsonDecode(response.body));
    }
  }
}
