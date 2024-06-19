
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:star_routes/components/cargo.dart';

import 'package:star_routes/effects/orbit_effects.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/data/mission_data.dart';

class CargoShip extends PositionComponent with HasGameRef<StarRoutes> {

  // Vector2 spawnPosition;
  /* Kill Sprite */
  DateTime endTime = DateTime.now().add(const Duration(seconds: 30));


  /*Orbital Parameters*/
  bool applyPhysics = true;
  bool isInOrbit = false;
  double angleInOrbit = 0;
  double targetShipAngle = 0;
  Vector2 orbitCenter = Vector2(0, 0);
  double orbitRadius = 300;
  double targetOrbitRadius = 0;
  double angleInOrbitOffset = 0;
  bool toOrbit;
  Function onDeliveryComplete;

  MissionData missionData;

  CargoShip({required this.missionData, required this.toOrbit, required this.onDeliveryComplete}) : super();

  @override
  Future<void> onLoad() async {
    // sprite = await Sprite.load(Assets.cargoShip);
    size = Vector2(560, 184);
    anchor = Anchor.center;
    add(Cargo(cargoSize: missionData.cargoTypeSizeData.cargoSize, isInUserShip: false));
    if (toOrbit){
      position = gameRef.userShip.orbitCenter;
      priority = 1;

      double effectDuration = 10;

      double pathScaleBy = game.userShip.orbitRadius;

      double estimateShipAngle = game.userShip.angleInOrbit
                        + game.userShip.orbitalAngularVelocity * effectDuration;

      double rotateBy = estimateShipAngle % (2 * pi) + 180 * degrees2Radians;



      final List<Effect> orbitEffect =
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


      addAll(orbitEffect);
    }else{
      position = gameRef.userShip.position;
      orbitCenter = gameRef.userShip.orbitCenter;
      orbitRadius = gameRef.userShip.orbitRadius;
      angle = gameRef.userShip.angle - pi /2;
      priority = 4;
    }


  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!applyPhysics){
      return;
    }

    // if (DateTime.now().isAfter(endTime)){
    //   removeFromParent();
    // }

    if (toOrbit){
      if (!isInOrbit){
        return;
      }

      if ((angleInOrbit - gameRef.userShip.angleInOrbit) % (2 * pi) < 0.1){
        // print("Reached Destination");
        onDeliveryComplete();
        removeFromParent();
      }

      angleInOrbit += (game.userShip.orbitalAngularVelocity * 1.5) * dt;

      position = orbitCenter + Vector2(cos(angleInOrbit), sin(angleInOrbit)) * orbitRadius;

      orbitRadius += (targetOrbitRadius - orbitRadius) * 0.01 ;
    }else{
      angleInOrbitOffset -= 0.003;
      angleInOrbit = gameRef.userShip.angleInOrbit + angleInOrbitOffset;
      position = orbitCenter + Vector2(cos(angleInOrbit), sin(angleInOrbit)) * orbitRadius;

      if (angleInOrbitOffset.abs() > 10 * degrees2Radians){
        print("Commencing Deorbit");

        final List<Effect> deOrbitingEffect = OrbitEffects()
              .deOrbitEffect(10, orbitRadius, angleInOrbit,
                (){
                  print("Is this is on complete effect");
                  onDeliveryComplete();
                  removeFromParent();
                }, this);

        addAll(deOrbitingEffect);
        applyPhysics = false;

      }

    }
    targetShipAngle = angleInOrbit + pi /2 + degrees2Radians * 12;
    double deltaAngle = (targetShipAngle - angle) % (2 * pi);
    if (deltaAngle > pi) {
      deltaAngle -= 2 * pi;
    } else if (deltaAngle < -pi) {
      deltaAngle += 2 * pi;
    }
    angle += deltaAngle * 0.05;

  }




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