import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';

class Vortex extends SpriteComponent with HasGameRef<StarRoutes>{

  final List<Sprite> sprites = [];

  int state = 0;
  bool isTransitioning = false;
  double transitionDuration = 1.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    for (var imagePath in Assets.vortexImages) {
      var stateSprite = await Sprite.load(imagePath);
      sprites.add(stateSprite);
    }
    state = 0;
    sprite = sprites[state];
    size = Vector2(500, 500);
    anchor = Anchor.center;
    position = gameRef.size / 2;

    // Start the initial fade in effect
    // add(
    //     OpacityEffect.to(
    //         0.5,
    //         EffectController(duration: 1)
    // ));




  }

  @override
  void update(double dt) {
    super.update(dt);

    /* Smooth transition from one state to another */


    // Apply fade out effect to the current sprite only if no transition is in progress
    if (!isTransitioning) {
      isTransitioning = true;
      add(
        OpacityEffect.to(
          0.2,
          EffectController(duration: transitionDuration),
          onComplete: () {
            if (state < sprites.length - 1) {
              state += 1;
            } else {
              state = 0;
            }
            sprite = sprites[state];
            add(
              OpacityEffect.to(
                1.0,
                EffectController(duration: transitionDuration),
                onComplete: () {
                  isTransitioning = false; // Mark transition as completed
                },
              ),
            );
          },
        ),
      );
    }


  }
}

