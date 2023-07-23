import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/providers/auth/auth_provider.dart';
import 'package:music_app/utils/helper.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkToken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: ((context, provider, _) {
        if (provider.state == AuthResultState.initial ||
            provider.state == AuthResultState.loading) {
          showToast("Loading...");
          return buildSplashScreenBody(MediaQuery.of(context).size.height);
        } else if (provider.state == AuthResultState.success) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pushReplacementNamed(context, "/home-screen");
          });
        } else if (provider.state == AuthResultState.noConnection) {
          showToast(provider.message);
        } else if (provider.state == AuthResultState.error) {
          showToast(
              "An error occurred with the server, please try again later");
        }
        return buildSplashScreenBody(MediaQuery.of(context).size.height);
      })),
    );
  }

  Padding buildSplashScreenBody(double height) {
    return Padding(
      padding: const EdgeInsets.all(60),
      child: Center(
        child: Image.asset('assets/images/music-icon.png'),
      ),
    );
  }
}
