

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/game/config.dart';

import 'package:star_routes/components/planet.dart';

import 'package:star_routes/screens/mini_map_screen.dart';
import 'package:star_routes/screens/blank_screen.dart';



class MiniMap extends PositionComponent with HasGameRef<StarRoutes>{

  late ui.Image miniMap;
  Paint instrumentBrush = Paint()..color = const Color(0xBBFFFFFF);
  Paint objectBrush = Paint()..color = const Color(0xC0FFFFFF);
  late Path miniMapMask;

  bool isEnabled = true;

  @override
  Future<void> onLoad() async {

    Vector2 margin = Vector2(15, 35);

    // Load the mini map image
    miniMap = await gameRef.images.load(Assets.miniMap);

    /* */

    size = Vector2(min(150, game.size.x - 160),
                   min(150, game.size.x - 160));
    position = margin;
    anchor = Anchor.topLeft;
    // priority = 5;

    miniMapMask = Path()..addOval(Rect.fromLTWH(0, 0, size.x, size.y));


    TappableRegion tappable = TappableRegion(
      position: position - margin,
      size: size,
      onTap: () {
        print("Tapped MiniMap");
        gameRef.overlays.add(MiniMapScreen.id);
        gameRef.overlays.remove(BlankScreen.id);
        // gameRef.pauseEngine();

      },
      onRelease: () {},
      buttonEnabled: () => isEnabled,
    );

    add(tappable);

  }

  List<Vector3> objectsInView(){

    List<Vector3> result = [];

    /* Pixel to Distance Ratio */
    double miniMapDistanceScale = 0.1 / Config.spaceScaleFactor;
    double miniMapSizeScale = 0.2 /  Config.radiusScaleFactor;

    for (Planet data in game.starWorld.planetComponents){

      double distanceToShip = gameRef.userShip.position.distanceTo(data.position);

      double minimumDistance = distanceToShip - data.size.x / 2;

      if (minimumDistance * miniMapDistanceScale > size.x / 2){
        continue;
      }

      Vector2 relativePosition = (data.position
                                - gameRef.userShip.position) * miniMapDistanceScale;

      result.add(Vector3(relativePosition.x, relativePosition.y,
                         data.size.x * miniMapSizeScale));

    }

    return result;
  }

  void setState(bool isMiniMapOpen){
    if (isMiniMapOpen){
      isEnabled = true;
    } else {
      isEnabled = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Translucent yellow on the mini map
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = const Color(0x88FFFF00));
    if (!isEnabled){
      return;
    }
    // print()
    /* Resize Image Base Image */
    final srcRect = Rect.fromLTWH(0, 0, miniMap.width.toDouble(), miniMap.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.x, size.y);

    /* Masking Mini Map */
    canvas.clipPath(miniMapMask);

    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(gameRef.userShip.angle);
    canvas.translate(-size.x / 2, -size.y / 2);
    canvas.drawImageRect(miniMap, srcRect, dstRect, instrumentBrush);


    /* Converting Coordinate Frame to Center */
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(-gameRef.userShip.angle);

    for (Vector3 object in objectsInView()){
      canvas.drawCircle(Offset(object.x, object.y ), object.z, objectBrush);
    }


    canvas.translate(-size.x / 2, -size.y / 2);

    /* Make it green */
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = const Color(0x88FF00FF));

  }

}