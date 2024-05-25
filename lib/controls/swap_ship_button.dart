
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:star_routes/data/planet_data.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/game/assets.dart';

import 'package:star_routes/states/swap_ship_button.dart';

class SwapShipButton extends SpriteGroupComponent<SwapShipButtonStates> with HasGameRef<StarRoutes> {


  late PlanetData planetData;

  SwapShipButton() : super(priority: 1);

  @override
  Future<void> onLoad() async {

    // final enterOrbitButton = await Sprite.load(Assets.enterOrbitButton);
    // final exitOrbitButton = await Sprite.load(Assets.exitOrbitButton);
    final swapShipButton = await Sprite.load(Assets.swapShipButton);

    double dim = 50;
    Vector2 margin = Vector2(45, 220);
    size = Vector2(dim, dim);

    position = gameRef.size - margin;

    anchor = Anchor.bottomRight;

    current = SwapShipButtonStates.inactive;
    opacity = 0;

    sprites = {
      SwapShipButtonStates.idle: swapShipButton,
      SwapShipButtonStates.inactive: swapShipButton,
    };

    add(
        TappableRegion(
          position: Vector2(0, 0),
          size: size,
          onTap: () {
            swapShips();
          },
          onRelease: () {},
          buttonEnabled: isEnabled,
        )
    );
  }

  void setState(SwapShipButtonStates state){

    if (SwapShipButtonStates.inactive == state){
      opacity = 0;
      current = SwapShipButtonStates.inactive;
    } else {
      opacity = 1;
      current = state;
    }

  }

  bool isEnabled() {
    if (current == SwapShipButtonStates.inactive) {
      return false;
    }
    return true;
  }

  void swapShips(){

    gameRef.userShip.switchShip(planetData);

  }

  /* Render Translucent Green */
  // @override
  // void render(Canvas canvas) {
    // canvas.drawRect(size.toRect(), Paint()..color = const Color(0x6600FF00));
    // super.render(canvas);
  // }

}