
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';


class Background extends ParallaxComponent<StarRoutes>
    with HasGameRef<StarRoutes>{

  Background();

  @override
  Future<void> onLoad() async {

    // Load the background images
    final backgroundAway = await Flame.images.load(Assets.backgroundAway);
    final backgroundClose = await Flame.images.load(Assets.backgroundClose);

    // Create the parallax
    parallax = Parallax([
      ParallaxLayer(
          ParallaxImage(backgroundAway, repeat: ImageRepeat.repeat),
          velocityMultiplier: Vector2(0.05, 0.05)
      ),
      ParallaxLayer(
          ParallaxImage(backgroundClose, repeat: ImageRepeat.repeat),
          velocityMultiplier: Vector2(0.22, 0.22)
      )
    ]);

  }

  @override
  void update(double dt){
    super.update(dt);
    parallax?.baseVelocity =  gameRef.userShip.linearVelocity;
  }
}