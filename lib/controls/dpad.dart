import 'package:flame/components.dart';
import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/states/dpad.dart';

class DPad extends SpriteGroupComponent<DPadStates>
    with HasGameRef<StarRoutes> {
  double margin = 35;

  @override
  Future<void> onLoad() async {
    final controller = await Sprite.load(Assets.controller);
    double dim = 150;

    size = Vector2(dim, dim);

    x = margin;
    y = gameRef.size.y - margin;
    current = DPadStates.idle;
    sprites = {
      DPadStates.idle: controller,
      DPadStates.pressed: controller,
    };

    anchor = Anchor.bottomLeft;
    addTappableRegions(dim);
  }

  void addTappableRegions(double dim) {
    double ratioPrimary = 0.38;
    double ratioSecondary = 0.35;

    /* Top */
    add(TappableRegion(
      position: Vector2(dim * (1 - ratioPrimary) / 2, 0),
      size: Vector2(dim * ratioPrimary, dim * ratioSecondary),
      onTap: () {
        gameRef.userShip
            .setImpulse(Vector2(1, 0)); // Ensure these values are correct
      },
      onRelease: () {
        gameRef.userShip.setImpulse(Vector2(0, 0));
      },
      buttonEnabled: isEnabled,
    ));

    /* Bottom */
    add(TappableRegion(
      position:
          Vector2(dim * (1 - ratioPrimary) / 2, dim * (1 - ratioSecondary)),
      size: Vector2(dim * ratioPrimary, dim * ratioSecondary),
      onTap: () {
        gameRef.userShip
            .setImpulse(Vector2(-1, 0)); // Ensure these values are correct
      },
      onRelease: () {
        gameRef.userShip.setImpulse(Vector2(0, 0));
      },
      buttonEnabled: isEnabled,
    ));

    /* Left */
    add(TappableRegion(
      position: Vector2(0, dim * (1 - ratioPrimary) / 2),
      size: Vector2(dim * ratioSecondary, dim * ratioPrimary),
      onTap: () {
        gameRef.userShip
            .setImpulse(Vector2(0, -1)); // Ensure these values are correct
      },
      onRelease: () {
        gameRef.userShip.setImpulse(Vector2(0, 0));
      },
      buttonEnabled: isEnabled,
    ));

    /* Right */
    add(TappableRegion(
      position:
          Vector2(dim * (1 - ratioSecondary), dim * (1 - ratioPrimary) / 2),
      size: Vector2(dim * ratioSecondary, dim * ratioPrimary),
      onTap: () {
        gameRef.userShip
            .setImpulse(Vector2(0, 1)); // Ensure these values are correct
      },
      onRelease: () {
        gameRef.userShip.setImpulse(Vector2(0, 0));
      },
      buttonEnabled: isEnabled,
    ));
  }

  void setState(DPadStates state) {
    if (DPadStates.inactive == state) {
      opacity = 0;
      current = DPadStates.inactive;
    } else {
      opacity = 1;
      current = state;
    }
  }

  bool isEnabled() {
    return current != DPadStates.inactive;
  }
}
