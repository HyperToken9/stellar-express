

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:star_routes/game/star_routes.dart';

class LoadingScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "loading";

  const LoadingScreen({super.key, required this.game});

  @override
  State<LoadingScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Load an image
            Image.asset('assets/images/user_interface/title.png'),

            SpinKitFadingCircle(
              color: Colors.blue.shade200,
              size: 100,
            )

          ],
        ),
      ),
    );
  }
}
