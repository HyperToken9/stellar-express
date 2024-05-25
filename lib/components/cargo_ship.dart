
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';

class CargoShip extends SpriteComponent with HasGameRef<StarRoutes> {

  // Vector2 spawnPosition;

  CargoShip() : super();

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(Assets.cargoShip);
    size = Vector2(50, 50);
    anchor = Anchor.center;
    position = gameRef.userShip.orbitCenter;
    priority = 10;
    // angle = -pi;
    // print("Cargo Ship Parent: ${parent}");
    final path = Path();
    path.cubicTo(0, 0, 2.499, -58, 18.999, -95.5); // First Bézier curve
    path.cubicTo(35.499, -133, 66.658, -202.609, 84.658, -162.109); // Second Bézier curve
    path.cubicTo(98.672, -130.578, 80.464, -35.943, 71.713, 4.425); // Third Bézier curve
    path.cubicTo(69.031, 16.794, 64.405, 28.616, 58.297, 39.7); // Fourth Bézier curve
    path.lineTo(39.104, 74.532); // Line
    path.cubicTo(14.846, 118.556, -30.7678, 146.375, -80.8566, 150.575); // Fifth Bézier curve
    path.cubicTo(-84.3525, 150.868, -87.9046, 151.176, -91.5007, 151.5); // Sixth Bézier curve
    path.cubicTo(-141.5007, 156, -107.0014, 104.5, -84.5012, 79.5); // Seventh Bézier curve
    path.cubicTo(-62.001, 54.5, -1.5, 1, -1.5, 1); // Eighth Bézier curve

    add(
      MoveAlongPathEffect(
        path,
        EffectController(
            duration: 10,
            // speed: 2,
            curve: Curves.easeInOutCubic,

        ),
        onComplete: () {
          removeFromParent();
        },
        oriented: true,
      )
    );


    //TODO: Create a scale effect

  }

  // @override

}