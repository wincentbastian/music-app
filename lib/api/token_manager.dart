import 'package:shared_preferences/shared_preferences.dart';

/// A class responsible for managing the authentication token using shared preferences.
class TokenManager {
  /// Retrieves the authentication token from shared preferences.
  ///
  /// The method returns the authentication token as a String if it exists, or null if it's not found.
  ///
  /// Returns the authentication token from shared preferences if available, otherwise returns null.
  Future<String> getToken() async {
    // Get the shared preferences instance.
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Retrieve the authentication token from shared preferences using the "token" key.
    // If the token does not exist, the getString method will return null.
    return sharedPreferences.getString("token")!;
  }
}
