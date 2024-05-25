import 'package:flutter/material.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/screen_components/hangar_slide.dart';

class HangarScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "hangar";

  const HangarScreen({super.key, required this.game});

  @override
  State<HangarScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<HangarScreen> {

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

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.game.overlays.remove('hangar');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 32.0, 0.0, 0.0),
              // (horizontal: 22.0, vertical: 32.0),
            child: Text(
              'Hangar'.toUpperCase(),
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'Audiowide',
                color: Colors.white,
                letterSpacing: -2,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: PageView(
              children: <Widget>[
                HangarSlide(
                  imagePath: 'assets/images/space_ships/small_courier.png',
                  shipName: 'Star Cruiser',
                  description: 'A fast and agile ship for quick missions.',
                ),
                HangarSlide(
                  imagePath: 'assets/images/space_ships/small_courier.png',
                  shipName: 'Battle Frigate',
                  description: 'A heavily armed ship for combat missions.',
                ),
                // HangarSlide(
                //   imagePath: 'assets/ship3.png',
                //   shipName: 'Cargo Hauler',
                //   description: 'A large ship for transporting goods.',
                // ),
                // Add more slides as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
