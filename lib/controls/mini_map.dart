

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:star_routes/data/world_data.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/tappable_region.dart';

import 'package:star_routes/data/planet_data.dart';


class MiniMap extends PositionComponent with HasGameRef<StarRoutes>{

  late ui.Image miniMap;
  Paint instrumentBrush = Paint()..color = const Color(0xBBFFFFFF);
  Paint objectBrush = Paint()..color = const Color(0xC0FFFFFF);
  late Path miniMapMask;

  @override
  Future<void> onLoad() async {

    Vector2 margin = Vector2(15, 35);

    // Load the mini map image
    miniMap = await gameRef.images.load(Assets.miniMap);
    // miniMap.size = Vector2(175, 175);
    size = Vector2(175, 175);
    position = margin;
    anchor = Anchor.topLeft;
    // priority = 5;

    miniMapMask = Path()..addOval(Rect.fromLTWH(0, 0, size.x, size.y));


    TappableRegion tappable = TappableRegion(
      position: position - margin,
      size: size,
      onTap: () {
        print("Tapped MiniMap");
        gameRef.overlays.add('miniMap');
        gameRef.pauseEngine();

      },
      onRelease: () {},
      buttonEnabled: () => true,
    );

    add(tappable);

  }

  List<Vector3> objectsInView(){

    List<Vector3> result = [];

    /* Pixel to Distance Ratio */
    double miniMapDistanceScale = 0.1;
    double miniMapSizeScale = 0.08;

    for (PlanetData data in WorldData.planets){

      double distanceToShip = gameRef.userShip.position.distanceTo(data.location);

      double minimumDistance = distanceToShip - data.radius;

      if (minimumDistance * miniMapDistanceScale > size.x / 2){
        continue;
      }

      Vector2 relativePosition = (data.location
                                - gameRef.userShip.position) * miniMapDistanceScale;

      result.add(Vector3(relativePosition.x, relativePosition.y,
                         data.radius * miniMapSizeScale));

    }

    return result;
  }





  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Translucent yellow on the mini map
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = const Color(0x88FFFF00));

    /* Resize Image Base Image */
    final srcRect = Rect.fromLTWH(0, 0, miniMap.width.toDouble(), miniMap.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.x, size.y);

    /* Masking Mini Map */
    // canvas.clipPath(miniMapMask);

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


  }

}