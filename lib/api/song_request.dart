import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:music_app/api/token_manager.dart';
import 'package:music_app/models/song/get_song_list_error_model.dart';
import 'package:music_app/models/song/get_song_list_success_model.dart';
import 'package:music_app/utils/constant.dart';

/// A class responsible for making HTTP requests related to fetching songs.
class SongRequest {
  /// Fetches a list of songs for a given artist ID.
  ///
  /// The method returns a [GetSongListSuccessModel] if the request is successful
  /// or throws a [GetSongListErrorModel] if an error occurs.
  ///
  /// The [artistId] is the ID of the artist for whom the top tracks need to be fetched.
  /// Returns a list of songs with details if found.
  ///
  /// Throws a [SocketException] if the request times out or there is no internet connection.
  Future<GetSongListSuccessModel> getSongList(String artistId) async {
    // Get the token required for authorization.
    String token = await TokenManager().getToken();

    // Construct the URL for fetching the top tracks of the artist in a specific country (Indonesia).
    Uri url =
        Uri.parse("${Constant.baseUrl}artists/$artistId/top-tracks?country=id");

// Prepare the request headers.
    var header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };

// Send a GET request to the API with the given URL and headers.
    var response = await http
        .get(url, headers: header)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      // Handle timeout and throw a SocketException when no internet connection.
      throw const SocketException("No connection");
    });

    if (response.statusCode == 200) {
      // If the response status code is 200, parse and return the GetSongListSuccessModel.
      return GetSongListSuccessModel.fromJson(jsonDecode(response.body));
    } else {
      // If the response status code is not 200, parse and throw the GetSongListErrorModel.
      throw GetSongListErrorModel.fromJson(jsonDecode(response.body));
    }
  }
}
