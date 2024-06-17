
import 'dart:math';
import 'dart:ui';
import 'package:flame/extensions.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

import 'package:star_routes/effects/orbit_effects.dart';

import 'package:star_routes/game/config.dart';
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

    // Path path = makeFinalSegment();

    double pathScaleBy = game.userShip.orbitRadius;
    // print("Scale By: $pathScaleBy");
    // print("User Positoon ${game.userShip.position}");
    double rotateBy = game.userShip.angleInOrbit - pi / 1.6 - game.userShip.orbitRadius / 200;
    print("Uinsg 185");
    size = size;
    double effectDuration = 10;

    final List<Effect> moveAlongPathEffect =
      OrbitEffects().orbitEffect(
          effectDuration,
          pathScaleBy,
          rotateBy,
          () {
              isInOrbit = true;
              orbitCenter = game.userShip.orbitCenter;
              Vector2 delta = orbitCenter - position;
              angleInOrbit = atan2(delta.y, delta.x) + pi;
              targetOrbitRadius = game.userShip.orbitRadius;
              orbitRadius = orbitCenter.distanceTo(position);
          },
          this
      );

    /*MoveAlongPathEffect(
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
    );*/

    addAll(

          // scaleUpEffect,
          moveAlongPathEffect
          // scaleDownEffect,
          // displayOrderEffect

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