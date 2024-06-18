

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/screens/main_menu_screen.dart';

import 'package:star_routes/services/datastore.dart';

class BlankScreen extends StatefulWidget {

  static const String id = "blank";
  final StarRoutes game;

  const BlankScreen({super.key, required this.game});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 50,
      // height: 50,
      // color: Color(0x5500FF00),
    );
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // print("Back button intercepted");
    widget.game.overlays.add(MainMenuScreen.id);
    widget.game.overlays.remove(BlankScreen.id);

    /* Write the changes back to fire base */
    // dataStore.saveDataToFireBase(widget.game);
    print("Saving Player Data");

    return true;
  }

  @override
  void initState() {
    super.initState();
    widget.game.resumeEngine();
    widget.game.setupGame();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    print("DISPOSING BLANK SCREEN");
    widget.game.saveGame();
    widget.game.pauseEngine();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


}
