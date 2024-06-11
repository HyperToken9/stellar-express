
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:star_routes/components/ship.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/screens/main_menu_screen.dart';
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
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 45.0, 0.0, 0.0),

              // (horizontal: 22.0, vertical: 32.0),
            child: Text(
              'Hangar'.toUpperCase(),
              style: const TextStyle(
                fontSize: 30.0,
                fontFamily: 'Audiowide',
                color: Colors.white,
                letterSpacing: -2,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (int index) {
                print("Position: ${widget.game.showRoomShips[index].position}");

                for (Ship data in widget.game.showRoomShips) {
                  // print("Ship: ${data.spaceShipData.shipClassName} Position: ${data.position}");
                  print("V: ${data.linearVelocity}");
                }
                widget.game.adjustCameraZoom(
                    objectSize: widget.game.showRoomShips[index].size,
                    screenPercentage: 70);

                widget.game.camera.moveTo(
                    widget.game.showRoomShips[index].position + Vector2(0, 30),
                    speed: 2000);

              },
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
    widget.game.overlays.add(MainMenuScreen.id);
    widget.game.pauseEngine();
    return true;
  }

  @override
  void initState() {
    super.initState();
    widget.game.resumeEngine();
    BackButtonInterceptor.add(myInterceptor);
    widget.game.setupHanger();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


}
