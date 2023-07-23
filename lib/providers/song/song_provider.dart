import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/api/song_request.dart';
import 'package:music_app/models/song/get_song_list_error_model.dart';
import '../../models/song/get_song_list_success_model.dart';

// Enum to represent the state of the song result
enum SongResultState {
  intial, // Initial state before any data is fetched
  loading, // Loading state while fetching data
  success, // Success state after data is successfully
  error, // Error state if an error occurs during data fetching
  noConnection, // No connection state if the user is offline
  tokenExpired, // Token expired state if the authentication token is expired
}

// Provider class for managing song data and audio player
class SongProvider with ChangeNotifier {
  // Instance of the SongRequest class to fetch song data
  SongRequest songRequest = SongRequest();

  // Instance of AudioPlayer for audio playback
  AudioPlayer audioPlayer = AudioPlayer();

  // Priate variables to hold song data, state, message, playback status, position, and duration
  late GetSongListSuccessModel _getSongListSuccessModel;
  SongResultState _state = SongResultState.intial;
  String _message = "";
  bool isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  GetSongListSuccessModel get songList => _getSongListSuccessModel;
  SongResultState get state => _state;
  String get message => _message;
  Duration get position => _position;
  Duration get duration => _duration;

  // Method to set the state to initial
  void setInitial() {
    _state = SongResultState.intial;
    notifyListeners();
  }

  // Private methods to update the duration and position
  void _setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  void _setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  // Method to play audio given an audio URL
  void playAudio(String audioUrl) async {
    try {
      // Play the audio using the AudioPlayer
      await audioPlayer.play(UrlSource(audioUrl));

      // Update the playback status and notify listeners
      isPlaying = true;
      notifyListeners();
    } on PlatformException catch (e) {
      // Handle the playform exception if an error occurs during playback
      _message = e.message.toString();
      _state = SongResultState.error;
      notifyListeners();
    }
  }

  // Method to pause audio playback
  void pauseAudio() async {
    // Pause the audio using the AudioPlayer
    await audioPlayer.pause();

    // Update the playback status and notify
    isPlaying = false;
    notifyListeners();
  }

  // Method to seek audio playback to a specific postion
  void seekAudio(Duration position) async {
    // Seek audio to the specified position using AudioPlayer
    await audioPlayer.seek(position);

    // Notify listener of the position change
    notifyListeners();
  }

  // Method to set the duration and position of the audio
  void setTime() async {
    // Reset the duration and position to zero and notify
    _duration = Duration.zero;
    _position = Duration.zero;
    notifyListeners();

    // Get the new duration from the audio player
    final newDuration = await audioPlayer.getDuration();

    // If the new duration is not null, update the duration and notify listeners
    if (newDuration != null) {
      _duration = newDuration;
      notifyListeners();
    }
  }

  // Method to initialize listeners for audio player events
  void initAudioPlayerListeners() {
    // Listen to the audio player for duration changes
    audioPlayer.onDurationChanged.listen((Duration duration) {
      _setDuration(duration);
    });

    // Listen to the audio player for position changes
    audioPlayer.onPositionChanged.listen((Duration position) {
      _setPosition(position);
    });

    // Listen to the audio player for completion events
    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      notifyListeners();
    });
  }

  // Method to fetch the song list for a specific artist
  void getSongList(String artistId) async {
    try {
      // Set the state to loading before fetching data
      _state = SongResultState.loading;
      notifyListeners();

      // Fetch the song list data using the SongRequest class
      GetSongListSuccessModel songListData =
          await SongRequest().getSongList(artistId);

      // Update the song list data and set the state to success
      _getSongListSuccessModel = songListData;
      _state = SongResultState.success;
      notifyListeners();
    } on SocketException catch (_) {
      // Handle the case where there is not internet connection
      _message = "Check your internet connection";
      _state = SongResultState.noConnection;
      notifyListeners();
    } catch (e) {
      // Handle other errors that may occur during data fetching
      if (e is GetSongListErrorModel) {
        if (e.error.status == 401) {
          _message = "Please open app again";
          _state = SongResultState.tokenExpired;
          notifyListeners();
        } else {
          _message = e.error.message;
          _state = SongResultState.error;
          notifyListeners();
        }
      } else {
        _message = e.toString();
        _state = SongResultState.error;
        notifyListeners();
      }
    }
  }
}
