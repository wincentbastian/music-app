import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_app/api/auth_request.dart';
import 'package:music_app/models/auth/auth_error_model.dart';
import 'package:music_app/models/auth/auth_success_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An enum representing different states of the authentication process.
enum AuthResultState {
  initial,
  loading,
  success,
  error,
  noConnection,
}

/// A provider class responsible for managing the authentication state and token retrieval.
class AuthProvider with ChangeNotifier {
  AuthRequst authRequst = AuthRequst();

  AuthResultState _state = AuthResultState.initial;
  String _message = "";

  /// The current state of the authentication process.
  AuthResultState get state => _state;

  /// The message related to the authentication process, e.g., an error message.
  String get message => _message;

  /// Sets the authentication state to initial.
  void setInitial() {
    _state = AuthResultState.initial;
    notifyListeners();
  }

  /// Checks for an existing authentication token and retrieves a new token if needed.
  ///
  /// If a token is found in shared preferences and is still valid, the state will be set to success.
  /// If no token is found or the existing token is expired, a new token will be retrieved.
  /// If the token retrieval is successful, the state will be set to success, and the new token will be saved to shared preferences.
  /// If there is no internet connection, the state will be set to noConnection.
  /// If an error occurs during the authentication process, the state will be set to error.
  void checkToken() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Set the state to success to show the loading indicator when checking for the token
      _state = AuthResultState.loading;
      notifyListeners();

      // Get and save token in shared preferences
      AuthSuccessModel tokenActive = await AuthRequst().getToken();
      sharedPreferences.setString("token", tokenActive.accessToken);

      _message = "Welcome Back";
      _state = AuthResultState.success;
      notifyListeners();
    } on SocketException catch (_) {
      // If there is no internet connection, set the state to noConnection and notify listeners.
      _state = AuthResultState.noConnection;
      notifyListeners();
    } catch (e) {
      if (e is AuthErrorModel) {
        // If an error occurs during the authentication process, handle the error and set the state to error.
        _message = e.error;
      } else {
        _message = e.toString();
      }
      _state = AuthResultState.error;
      notifyListeners();
    }
  }
}
