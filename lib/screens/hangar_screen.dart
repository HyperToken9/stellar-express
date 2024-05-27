
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:star_routes/data/space_ship_data.dart';
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
              style: const TextStyle(
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
                ...SpaceShipData.spaceShips.map((shipData) {
                  return HangarSlide(
                    spriteName: shipData.spriteName,
                    shipName: shipData.shipClassName,
                    description: "shipData.description",
                  );
                }).toList(),
                // Add more slides as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.game.overlays.remove(HangarScreen.id);
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
