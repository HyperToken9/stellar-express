

import 'dart:math';

import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';

class Cargo extends SpriteComponent with HasGameRef<StarRoutes>{

  String cargoSize;
  bool isInUserShip;
  double offsetAngle = pi / 2;

  Cargo({required this.cargoSize, required this.isInUserShip}) {
    setCargoSize(cargoSize);
    priority = 1;
  }

  @override
  Future<void> onLoad() async {
    // priority = 0;
    sprite = await Sprite.load(Assets.cargo);
    anchor = Anchor.center;
  }

  void setCargoSize(String cargoSize){
    print("Cargo size: $cargoSize");
    if (cargoSize == "Small") {
      size = Vector2(142, 300);
    } else if (cargoSize == "Medium") {
      size = Vector2(261, 550);
    } else if (cargoSize == "Large") {
      size = Vector2(379, 800);
    } else if (cargoSize == "Very Large") {
      size = Vector2(592, 1250);
    }
  }


  @override
  void update(double dt) {
    super.update(dt);

    if (isInUserShip) {
      // Calculate the position below the userShip considering its angle
      double offAngle = game.userShip.angle - offsetAngle;
      Vector2 offset = Vector2(0, size.y / 3.3)..rotate(offAngle);

      // Update the position and angle
      angle = game.userShip.angle;
      position = game.userShip.position - offset;
      // if (offsetAngle != 0){
      //   position = game.userShip.position - offset;
      // }

    } else{
      position = Vector2(scaledSize.x*2, 0);
    }

  }

  @override
  double get angle => super.angle + offsetAngle;

  @override
  set angle(double newAngle) {
    super.angle = newAngle - offsetAngle;
  }


}