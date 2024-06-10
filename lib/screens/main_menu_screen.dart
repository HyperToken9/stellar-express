
import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/screens/blank_screen.dart';
import 'package:star_routes/screens/hangar_screen.dart';


class MainMenuScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "mainMenu";

  const MainMenuScreen({super.key, required this.game});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
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
                  onPressed: () {
                    print("Play Game");
                    widget.game.resumeEngine();
                    widget.game.overlays.remove(MainMenuScreen.id);
                    widget.game.overlays.add(BlankScreen.id);
                  },
                  child: Image.asset('assets/images/user_interface/play_button.png'),
                ),
                TextButton(
                  onPressed: () {
                    widget.game.overlays.add(HangarScreen.id);
                  },
                  child: Image.asset('assets/images/user_interface/hangar_button.png'),
                ),
                TextButton(
                  onPressed: () {
                    print("Options");
                  },
                  child: Image.asset('assets/images/user_interface/options_button.png'),
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
