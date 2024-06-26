
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
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

  void onSell(SpaceShipData shipData) {
    print("Selling Ship");
    widget.game.playerData.sellShip(
      shipData,
      widget.game.displayMessage,
    );
    widget.game.saveGame();


    setState(() {

    });
  }

  void onBuy(SpaceShipData shipData) {
    // widget.game.buyShip(shipData);
    widget.game.playerData.buyShip(
        shipData,
        widget.game.displayMessage,
        widget.game.userShip
    );
    widget.game.saveGame();

    setState(() {

    });

  }

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
            child: Container(
              margin: const EdgeInsets.only(right: 210.0),
              // constraints: ,
              // color: const Color(0x4500FF00),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
                          minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: (){
                            widget.game.overlays.remove(HangarScreen.id);
                            widget.game.overlays.add(MainMenuScreen.id);
                            widget.game.pauseEngine();
                          },
                        child: Image.asset(
                          "assets/images/user_interface/back_button_icon.png",
                          scale: 1,
                          fit: BoxFit.contain,
                        )

                    ),
                    // const SizedBox(width: 10),
                    Text(
                      'Hangar'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Audiowide',
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (int index) {

                widget.game.adjustCameraZoom(
                    objectSize: widget.game.showRoomShips[index].size,
                    screenPercentage: widget.game.showRoomShips[index].spaceShipData.zoomPercentage * 2);

                widget.game.camera.moveTo(
                    widget.game.showRoomShips[index].position + Vector2(0, 30),
                    speed: 2000);

              },
              children: <Widget>[
                ...SpaceShipData.spaceShips.map((shipData) {
                  return HangarSlide(
                    shipData: shipData,
                    shipState: widget.game.playerData.spaceShipStates[shipData.shipClassName]!,
                    onSell: onSell,
                    onBuy: onBuy,
                  );
                }),
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
    print("Hangar Screen Initialized");
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


}
