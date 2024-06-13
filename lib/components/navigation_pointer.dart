
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';

class NavigationPointer extends SpriteComponent with HasGameRef<StarRoutes> {

  Vector2? targetLocation;
  late double radiusX = 50;
  late double radiusY = 50;
  final double reachThreshold = 300;
  final double speedThreshold = 30;
  @override
  Future<void> onLoad() async {

    sprite = await game.loadSprite(Assets.navigationPointer);
    size = Vector2(50, 50);
    anchor = Anchor.center;
    opacity = 0;

    radiusX = gameRef.size.x * 3 / 8;
    radiusY = gameRef.size.y * 3 / 8;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (targetLocation != null) {
      final numerator = targetLocation!.x - game.userShip.position.x;
      final denominator = -targetLocation!.y + game.userShip.position.y;

      angle = atan2(numerator, denominator);

      position = game.size / 2 + Vector2(sin(angle) * radiusX, -cos(angle) * radiusY);

      if (game.userShip.inOrbit &&
          game.userShip.orbitCenter.distanceTo(targetLocation!) < 100){
        setNavigationTarget(null);
        print("User reached destination");
        return;
      }

      if (targetLocation!.distanceTo(game.userShip.position) < reachThreshold){
        // print("Destination is clsoe");
        // print("Speed Threshold: $speedThreshold User Speed: ${game.userShip.linearVelocity.length}");
        if (game.userShip.linearVelocity.length < speedThreshold) {
          setNavigationTarget(null);
          print("User reached destination");
          return;
        }


        //TODO: Make a overlay to display user reached destination
        //TODO: Distance Indicator
      }
    }



  }

  void setNavigationTarget(Vector2? target){

    if (target == null ){
      opacity = 0;
      targetLocation = null;
    }
    else{
      targetLocation = target;
      opacity = 1;
    }

  }

  bool isNavigating(){
    return targetLocation != null;
  }

}