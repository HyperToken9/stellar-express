
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/extensions.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';

class CargoShip extends SpriteComponent with HasGameRef<StarRoutes> {

  // Vector2 spawnPosition;
  /* Kill Sprite */
  DateTime endTime = DateTime.now().add(const Duration(seconds: 30));

  /*Orbital Parameters*/
  bool isInOrbit = false;
  double angleInOrbit = 0;
  double targetShipAngle = 0;
  Vector2 orbitCenter = Vector2(0, 0);
  double orbitRadius = 300;
  double targetOrbitRadius = 0;

  CargoShip() : super();

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(Assets.cargoShip);
    size = Vector2(560, 184);
    anchor = Anchor.center;
    position = gameRef.userShip.orbitCenter;
    priority = 4;



    // print(scalingMatrix.storage);

    Path path = makeFinalSegment();

    double pathScaleBy = 5;
    double rotation = game.userShip.angleInOrbit - pi / 1.6;
    size = size / 3;


    Matrix4 scalingMatrix = Matrix4.identity()..scale(pathScaleBy);
    Matrix4 rotationMatrix = Matrix4.identity()..rotateZ(rotation);
    Matrix4 transformationMatrix = scalingMatrix.multiplied(rotationMatrix);

    /*Scale Size of Path */
    path = path.transform(transformationMatrix.storage);
    double effectDuration = 4;



    final moveAlongPathEffect = MoveAlongPathEffect(
      path,
      EffectController(
        duration: effectDuration,
        // speed: 2,
        curve: Curves.easeInOut,
      ),
      onComplete: () {
        isInOrbit = true;
        orbitCenter = game.userShip.orbitCenter;
        Vector2 delta = orbitCenter - position;
        angleInOrbit = atan2(delta.y, delta.x) + pi;
        targetOrbitRadius = game.userShip.orbitRadius;
        orbitRadius = orbitCenter.distanceTo(position);
      },
      oriented: true,
    );

    addAll(
        [
          // scaleUpEffect,
          moveAlongPathEffect,
          // scaleDownEffect,
          // displayOrderEffect
        ]
    );

  }

  void update(double dt) {
    super.update(dt);

    if (DateTime.now().isAfter(endTime)){
      removeFromParent();
    }

    if (!isInOrbit){
      return;
    }

    if ((angleInOrbit - gameRef.userShip.angleInOrbit) % (2 * pi) < 0.1){
      print("Reached Destination");
      removeFromParent();
    }

    angleInOrbit += 0.009;
    targetShipAngle = angleInOrbit + pi /2;

    position = orbitCenter + Vector2(cos(angleInOrbit), sin(angleInOrbit)) * orbitRadius;
    double deltaAngle = (targetShipAngle - angle) % (2 * pi);
    if (deltaAngle > pi) {
      deltaAngle -= 2 * pi;
    } else if (deltaAngle < -pi) {
      deltaAngle += 2 * pi;
    }
    angle += deltaAngle * 0.05;

    orbitRadius += (targetOrbitRadius - orbitRadius) * 0.01 ;


  }

  Path makeIntermediateSegment()
  {
    Path path = Path();
    path.cubicTo(0, 0, 2.499, -58, 18.999, -95.5); // First Bézier curve
    path.cubicTo(35.499, -133, 66.658, -202.609, 84.658, -162.109); // Second Bézier curve
    path.cubicTo(98.672, -130.578, 80.464, -35.943, 71.713, 4.425); // Third Bézier curve
    path.cubicTo(69.031, 16.794, 64.405, 28.616, 58.297, 39.7); // Fourth Bézier curve
    path.lineTo(39.104, 74.532); // Line
    path.cubicTo(14.846, 118.556, -30.7678, 146.375, -80.8566, 150.575); // Fifth Bézier curve
    path.cubicTo(-84.3525, 150.868, -87.9046, 151.176, -91.5007, 151.5); // Sixth Bézier curve
    path.cubicTo(-141.5007, 156, -107.0014, 104.5, -84.5012, 79.5); // Seventh Bézier curve
    path.cubicTo(-62.001, 54.5, -1.5, 1, -1.5, 1); // Eighth Bézier curve
    return path;
  }


  Path makeFinalSegment(){
    Path path = Path();
    path.moveTo(0, 0); // Move to the initial point
    path.cubicTo(0, 0, 2.499, -58, 19.499, -95.5);
    path.cubicTo(35.999, -133, 66.658, -202.609, 84.658, -162.109);
    path.cubicTo(98.573, -130.8008, 80.72, -37.278, 71.9, 3.561);
    path.cubicTo(69.101, 16.519, 64.18, 28.849, 57.639, 40.378);
    path.lineTo(41.962, 68.003);
    path.cubicTo(8.952, 126.173, -62.7768, 152.277, -106.922, 102.033);
    // path.cubicTo(-115.515, 92.252, -124.01, 81.126, -132.052, 68.5);
    // path.cubicTo(-159.291, 16.528, -152.1344, -47.536, -113.1234, -92.9966);
    // path.lineTo(-105.6218, -101.5458);
    // path.cubicTo(-48.9858, -166.0918, 51.3652, -166.5182, 108.548, -102.456);
    // path.lineTo(116.7, -93.323);
    // path.cubicTo(128.101, -80.5509, 137.044, -65.783, 143.079, -49.762);
    // path.cubicTo(154.923, -18.322, 154.979, 16.343, 143.237, 47.821);
    // path.lineTo(140.094, 56.248);
    // path.cubicTo(124.544, 99.407, 88.64, 132.169, 44.191, 144.258);
    // path.lineTo(38.345, 145.848);
    // path.cubicTo(-23.8592, 162.766, -89.6912, 135.974, -122.404, 80.429);
    // path.lineTo(-125.8955, 74.5);
    // path.cubicTo(-148.1287, 39.985, -153.7922, -2.653, -141.3438, -41.777);
    // path.lineTo(-140, -46);

    return path;
  }


  // @override

}


/*
 Holy Testament to why I cant kee
 double rotation = pi / 4;
    Matrix4 scalingMatrix = Matrix4.identity()..scale(scale);
    Matrix4 rotationMatrix = Matrix4.identity()..rotateZ(rotation);
    Matrix4 transformationMatrix = scalingMatrix.multiplied(rotationMatrix);
    // print(scalingMatrix.storage);

    Path path = makeFinalSegment();

    /*Scale Size of Path */
    path = path.transform(transformationMatrix.storage);
    double effectDuration = 10;
    double scaleBy = 1.3;

    final displayOrderEffect = SequenceEffect(
      [
        ScaleEffect.by(
          Vector2.all(1),
          EffectController(duration: effectDuration / 3),
          onComplete: () {
            priority = 3;
          }
        ),
        ScaleEffect.by(
          Vector2.all(1),
          EffectController(duration: effectDuration / 3),
          onComplete: () {
            priority = 1;
          }
        ),
        ScaleEffect.by(
          Vector2.all(1),
          EffectController(duration: effectDuration / 3),
        ),

      ]
    );


    final scaleUpEffect = ScaleEffect.by(
      Vector2.all(scaleBy), // Scaling by a factor of 2
      EffectController(
          duration: effectDuration / 2,
          curve: Curves.easeIn
      ),
    );

    final scaleDownEffect = ScaleEffect.by(
      Vector2.all(1/scaleBy), // Scaling by a factor of 2
      EffectController(
          startDelay: effectDuration / 2,
          duration: effectDuration / 2,
          curve: Curves.easeOut
      ),
    );

    final moveAlongPathEffect = MoveAlongPathEffect(
      path,
      EffectController(
        duration: effectDuration,
        // speed: 2,
        curve: Curves.easeInOut,
      ),
      onComplete: () {
        removeFromParent();
      },
      oriented: true,
    );

    addAll(
      [scaleUpEffect, moveAlongPathEffect, scaleDownEffect, displayOrderEffect]
    );



*/