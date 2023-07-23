Music App

This is a simple music app built using Flutter, which allows users to search for artists and view their top songs. Users can play and pause songs and also seek to a specific position in the audio playback. The app uses the Spotify API to fetch artist and song data.

Features
- Search for artists
- View top songs of an artist
- Play and pause songs
- Seek to a specific position in the audio playback
- Error handling for no internet connection and expired authentication token

Dependencies
- http: For making HTTP requests to the Spotify API.
- audioplayers: For audio playback functionality.
- shared_preferences: For storing and retrieving the authentication token.

Getting Started
1. Clone the repository and open it in your preferred code editor.
2. Make sure you have Flutter and Dart installed on your machine.
3. Run flutter pub get to install the dependencies.
4. Run the app on an emulator or physical device using flutter run.

How to Use
1. Upon launching the app, you will see a search bar where you can enter an artist's name.
2. Type the artist's name and tap the search button.
3. The app will fetch and display the top songs of the artist.
4. Tap on a song to play it. The song will start playing, and the play button will change to a pause button.
5. You can pause the song by tapping the pause button.
6. To seek to a specific position in the song, drag the slider to the desired position.

Author
Wincent Bastian
