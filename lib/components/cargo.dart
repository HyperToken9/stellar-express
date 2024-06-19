

import 'package:flame/components.dart';

import 'package:star_routes/game/assets.dart';

class Cargo extends SpriteComponent{

  String cargoSize;

  Cargo({required this.cargoSize}) {
    if (cargoSize == "Small") {
      size = Vector2(300, 142);
    } else if (cargoSize == "Medium") {
      size = Vector2(100, 100);
    } else if (cargoSize == "Large") {
      size = Vector2(150, 150);
    } else if (cargoSize == "Very Large") {
      size = Vector2(200, 200);
    }
  }
  @override
  Future<void> onLoad() async {

    sprite = await Sprite.load(Assets.cargo);
    anchor = Anchor.center;

  }

}