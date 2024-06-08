

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/screens/main_menu_screen.dart';

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
    return Container();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // print("InterCepting THe interceptor");
    widget.game.overlays.add(MainMenuScreen.id);
    widget.game.pauseEngine();
    return true;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


}
