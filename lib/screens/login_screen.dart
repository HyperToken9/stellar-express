

import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/screen_components/button.dart';

class LoginScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "login";

  const LoginScreen({super.key, required this.game});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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


            Column(
              children: <Widget>[
                TextButton(
                  onPressed: (){

                  },
                  child: Image.asset('assets/images/user_interface/login_with_play_games.png'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {

                  },
                  child: Image.asset('assets/images/user_interface/login_with_game_center.png'),
                ),
                const SizedBox(height: 50),
              ],
            )

          ],
        ),
      ),
    );
  }
}