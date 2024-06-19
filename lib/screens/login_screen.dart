

import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';
// import 'package:star_routes/screen_components/button.dart';

// import 'package:star_routes/services/authentication.dart';

import 'package:star_routes/screens/main_menu_screen.dart';
import 'package:star_routes/services/authentication.dart';


class LoginScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "login";

  const LoginScreen({super.key, required this.game});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  /* Authentication */
  final Authentication _authentication = Authentication();

  /* Validate Login Process */
  void processLogin(String id) {
    if (id == ""){
      print("Login Attempt failed");
      return;
    }
    /*
      TODO Replace with load data method call
    */


    widget.game.initializePlayerData(id);

    // widget.game.experienceBar.up
    widget.game.overlays.add(MainMenuScreen.id);
    widget.game.overlays.remove(LoginScreen.id);

  }

  void processSilentLogin() async {
    String id = await _authentication.getCurrentUser();
    processLogin(id);
  }



  @override
  Widget build(BuildContext context) {
    processSilentLogin();
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
                  onPressed: () async {
                    String id = await _authentication.signInWithGoogle();

                    processLogin(id);

                  },
                  child: Image.asset('assets/images/user_interface/login_with_google.png'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: (){
                    widget.game.auth.signInWithGooglePlayGames();
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