import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_app/providers/auth/auth_provider.dart';
import 'package:music_app/providers/home/home_provider.dart';
import 'package:music_app/providers/song/song_provider.dart';
import 'package:provider/provider.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM);
}

void resetState(BuildContext context) {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  authProvider.setInitial();
  HomeProvider homeProvider = Provider.of<HomeProvider>(context, listen: false);
  homeProvider.setInitial();
  SongProvider songProvider = Provider.of<SongProvider>(context, listen: false);
  songProvider.setInitial();
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}
