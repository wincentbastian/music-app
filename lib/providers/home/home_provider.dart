import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_app/api/home_request.dart';
import 'package:music_app/models/artist/get_artist_list_error_model.dart';
import 'package:music_app/models/artist/get_artist_list_success_model.dart';

/// A provider class responsible for managing the state and handling API requests for artist search.
enum HomeResultState {
  initial,
  loading,
  success,
  error,
  noConnection,
  tokenExpired
}

class HomeProvider with ChangeNotifier {
  HomeRequest homeRequest = HomeRequest();

  /// The model representing the list of artists retrieved from the API.
  late GetArtistListSuccessModel _artistListSuccessModel;

  /// The current state of the artist search process.
  HomeResultState _state = HomeResultState.initial;

  /// The message related to the artist search process, e.g., an error message.
  String _message = "";

  /// The current state of the artist search process.
  HomeResultState get state => _state;

  /// The message related to the artist search process, e.g., an error message.
  String get message => _message;

  /// The model representing the list of artists retrieved from the API.
  GetArtistListSuccessModel get artistList => _artistListSuccessModel;

  /// Sets the state to initial, which is the default state when starting the artist search process.
  void setInitial() {
    _state = HomeResultState.initial;
    notifyListeners();
  }

  /// Searches for artists based on the provided artistName.
  ///
  /// This method sends an API request to search for artists with the given artistName.
  /// If the request is successful, the artist list will be saved to the _artistListSuccessModel.
  /// If there is no internet connection, the state will be set to noConnection.
  /// If the token used for authentication has expired, the state will be set to tokenExpired.
  /// If an error occurs during the artist search process, the state will be set to error.
  void searchArtist(String artistName) async {
    try {
      _state = HomeResultState.loading;
      notifyListeners();

      // Perform the artist search API request.
      GetArtistListSuccessModel artistData =
          await HomeRequest().getSearchArtist(artistName);
      _artistListSuccessModel = artistData;
      _state = HomeResultState.success;
      notifyListeners();
    } on SocketException catch (_) {
      // If there is no internet connection, set the state to noConnection and notify listeners.
      _message = "Check your internet connection";
      _state = HomeResultState.noConnection;
      notifyListeners();
    } catch (e) {
      // Handle errors during the artist search process.
      if (e is GetArtistListErrorModel) {
        if (e.error.status == 401) {
          // If the token has expired, set the state to tokenExpired and notify listeners.
          _message = "Please open app again";
          _state = HomeResultState.tokenExpired;
          notifyListeners();
        } else {
          // If there is an error response from the API, set the state to error and notify listeners.
          _message = e.error.message;
          _state = HomeResultState.error;
          notifyListeners();
        }
      } else {
        // If an unknown error occurs, set the state to error and notify listeners.
        _message = e.toString();
        _state = HomeResultState.error;
        notifyListeners();
      }
    }
  }
}
