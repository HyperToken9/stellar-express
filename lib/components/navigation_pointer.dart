
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:star_routes/game/config.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';

class NavigationPointer extends SpriteComponent with HasGameRef<StarRoutes> {

  late TextComponent distanceText;
  Vector2? targetLocation;
  late double radiusX = 50;
  late double radiusY = 50;
  final double reachThreshold = 300;
  final double speedThreshold = 30;
  String destinationName = "";

  @override
  Future<void> onLoad() async {
    priority = 5;
    sprite = await game.loadSprite(Assets.navigationPointer);
    size = Vector2(50, 50);
    anchor = Anchor.center;
    opacity = 0;

    radiusX = gameRef.size.x * 3 / 8;
    radiusY = gameRef.size.y * 3 / 8;

    distanceText = TextComponent(
        text: "",
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFC6C6C7),
            fontFamily: 'SpaceMono',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        position: Vector2(0, 0),
        anchor: Anchor.center);
    // print("Distance Size: ${distanceText.size}");
    add(distanceText);
  }

  String formattedDistance(){

    double realDistance = targetLocation!.distanceTo(game.userShip.position);

    double scaledDistance = realDistance / (100 * Config.spaceScaleFactor);

    double scaledDistanceRounded = (scaledDistance * 10).round() / 10;

    return "${scaledDistanceRounded} AU";
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (targetLocation == null) {
      return;
    }

    final numerator = targetLocation!.x - game.userShip.position.x;
    final denominator = -targetLocation!.y + game.userShip.position.y;

    angle = atan2(numerator, denominator);
    position = game.size / 2 + Vector2(sin(angle) * radiusX, -cos(angle) * radiusY);


    distanceText.text = formattedDistance();

    distanceText.anchor = Anchor.center;
    distanceText.position = Vector2(distanceText.absoluteScaledSize.x * 0.5,
                                    distanceText.absoluteScaledSize.y * 2);
    // Keep the text horizontal
    distanceText.angle = -angle;

    if (game.userShip.inOrbit &&
        game.userShip.orbitCenter.distanceTo(targetLocation!) < 100){
      game.displayMessage("Reached $destinationName");
      setNavigationTarget(null, "");
      return;
    }

    if (targetLocation!.distanceTo(game.userShip.position) < reachThreshold){
      // print("Destination is clsoe");
      // print("Speed Threshold: $speedThreshold User Speed: ${game.userShip.linearVelocity.length}");
      if (game.userShip.linearVelocity.length < speedThreshold) {
        game.displayMessage("Reached $destinationName");
        setNavigationTarget(null, "");
        // print("User reached destination");
        return;
      }


      //TODO: Make a overlay to display user reached destination
    }


  }


  void setNavigationTarget(Vector2? target, String destinationName){

    if (target == null ){
      opacity = 0;
      targetLocation = null;
      distanceText.removeFromParent();
    }
    else{
      targetLocation = target;
      opacity = 1;
      add(distanceText);
    }

  }

  bool isNavigating(){
    return targetLocation != null;
  }

}