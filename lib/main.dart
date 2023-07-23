import 'package:flutter/material.dart';
import 'package:music_app/providers/auth/auth_provider.dart';
import 'package:music_app/providers/home/home_provider.dart';
import 'package:music_app/providers/song/song_provider.dart';
import 'package:music_app/screens/home/home_screen.dart';
import 'package:music_app/screens/splash_screen.dart/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await initialization(null);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(
          create: (_) => SongProvider()..initAudioPlayerListeners())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Music App",
      initialRoute: "/splash-screen",
      routes: {
        "/splash-screen": (context) => const SplashScreen(),
        "/home-screen": (context) => const HomeScreen()
      },
    );
  }
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3));
}
