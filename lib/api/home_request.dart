import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:music_app/api/token_manager.dart';
import 'package:music_app/models/artist/get_artist_list_error_model.dart';
import 'package:music_app/models/artist/get_artist_list_success_model.dart';
import 'package:music_app/utils/constant.dart';

/// A class responsible for making HTTP requests related to artist search.
class HomeRequest {
  /// Fetches a list of artists based on the given [artistName].
  ///
  /// The method returns a [GetArtistListSuccessModel] if the request is successful
  /// or throws a [GetArtistListErrorModel] if an error occurs.
  ///
  /// The [artistName] is the search term used to find artists.
  /// Returns a list of artists with details if found.
  ///
  /// Throws a [SocketException] if the request times out.
  Future<GetArtistListSuccessModel> getSearchArtist(String artistName) async {
    // Get the token required for authorization
    String token = await TokenManager().getToken();

    // Construct the URL for the artist search API endpoint
    Uri url = Uri.parse("${Constant.baseUrl}search?q=$artistName&type=artist");

    // Prepare the request headers
    var header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };

    // Send a GET request to the API with the given URL and headers.
    var response = await http
        .get(url, headers: header)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      // Handle timeout and throw a SocketException when no internet connection
      throw const SocketException("No connection");
    });

    if (response.statusCode == 200) {
      // If the response is successful (status code 200),
      // parse the JSON data and return the GetArtistListSuccessModel.
      return GetArtistListSuccessModel.fromJson(jsonDecode(response.body));
    } else {
      // If an error occurs, parse the error JSON data and throw the GetArtistListErrorModel.
      throw GetArtistListErrorModel.fromJson(jsonDecode(response.body));
    }
  }
}
