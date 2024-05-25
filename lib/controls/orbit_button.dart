

import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/game/assets.dart';

import 'package:star_routes/states/orbit_button.dart';

class OrbitButton extends SpriteGroupComponent<OrbitButtonStates> with HasGameRef<StarRoutes>{


  OrbitButton() : super(priority: 1);

  @override
  Future<void> onLoad() async {

    final enterOrbitButton = await Sprite.load(Assets.enterOrbitButton);
    final exitOrbitButton = await Sprite.load(Assets.exitOrbitButton);


    double dim = 70;
    Vector2 margin = Vector2(45, 120);
    size = Vector2(dim, dim);

    position = gameRef.size - margin;

    anchor = Anchor.bottomRight;

    current = OrbitButtonStates.inactive;
    opacity = 0;

    sprites = {
      OrbitButtonStates.enterOrbitIdle: enterOrbitButton,
      OrbitButtonStates.enterOrbitPressed: enterOrbitButton,
      OrbitButtonStates.exitOrbitIdle: exitOrbitButton,
      OrbitButtonStates.exitOrbitPressed: exitOrbitButton,
      OrbitButtonStates.inactive: exitOrbitButton,
    };

    add(
      TappableRegion(
        position: Vector2(0, 0),
        size: size,
        onTap: () {
            // print("State: $current");
            // current = OrbitButtonStates.exitOrbitPressed;
            if (OrbitButtonStates.enterOrbitIdle == current){
              gameRef.userShip.insertIntoOrbit();
              current = OrbitButtonStates.exitOrbitIdle;

            } else if (OrbitButtonStates.exitOrbitIdle == current){
              gameRef.userShip.removeFromOrbit();
              current = OrbitButtonStates.enterOrbitIdle;
            }


          },
        onRelease: () {},
        buttonEnabled: isEnabled,
      )
    );

  }


  void setState(OrbitButtonStates state){

    if (OrbitButtonStates.inactive == state){
      opacity = 0;
      current = OrbitButtonStates.inactive;
    } else {
      opacity = 1;
      current = state;
    }

  }


  bool isEnabled() {
    if (current == OrbitButtonStates.inactive) {
      return false;
    }
    return true;
  }

  /* Render Tappable regions translucent green */
  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   canvas.drawRect(size.toRect(), Paint()..color = Color(0x8800FF00));
  // }

}