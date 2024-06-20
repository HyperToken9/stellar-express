

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:star_routes/effects/orbit_effects.dart';
import 'package:star_routes/game/config.dart';
import 'package:star_routes/game/priorities.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/data/planet_data.dart';


class Planet extends SpriteAnimationComponent with HasGameRef<StarRoutes>{

  PlanetData planetData;
  late Future<void> imageLoader;
  // late final image;
  // late Future


  Planet({required this.planetData}) {
    // Initiate the background loading of the image
    priority = Priorities.planet;
    imageLoader = _loadImage();
  }

  Future<void> _loadImage() async {

    // Load the image asynchronously
    final loadedImage = await Flame.images.load("planets/${planetData.spriteName}.png");

    // Create the sprite sheet and animation
    final spriteSheet = SpriteSheet(
      image: loadedImage,
      srcSize: planetData.spriteSize,
    );

    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: planetData.spriteSpeed,
      from: 0,
      to: planetData.numSprites * planetData.numSprites,
    );

    // Set other properties after the image is loaded

    size = Vector2(planetData.radius, planetData.radius) * Config.radiusScaleFactor;
    position = planetData.location * Config.spaceScaleFactor;
    anchor = Anchor.center;
    // print("Image loaded for ${planetData.spriteName}");
  }

  @override
  Future<void> onLoad() async {
    // Wait for the image to be fully loaded before proceeding
    await imageLoader;
  }

  /*Override render  */
  @override
  void render(Canvas canvas) {
    /* A green aura around the planet with a gradient */
    Rect rect = Rect.fromCircle(
      center: Offset(size.x / 2, size.y / 2),
      radius: size.x * 3,
    );

    // Define the gradient
    RadialGradient gradient = RadialGradient(
      colors: [
        planetData.miniMapColor.withAlpha(70),  // Fully opaque green
        const Color(0x00000000),  // Fully transparent green
      ],
      stops: [0.0, 1.0],  // Define the stops for the gradient
    );

    // Create a Paint object with the gradient shader
    Paint auraPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // Draw the circle with the gradient
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * 5, auraPaint);

    super.render(canvas);



    /* Debugging ??? */


    /*Draw a red circle of size */
    Paint circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    // canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x, circlePaint);


    // Path orbitalArc = OrbitEffects().scalePath(
    //                     OrbitEffects().makeDeOrbitPath(),
    //                     game.userShip.orbitRadius);
    // orbitalArc = OrbitEffects().scalePath(orbitalArc, scalePathBy);
    /*pRINT THE last point on the path */

    /*(-106.922, 102.033); */
    // double currentAngle = atan2(102.033, -106.922);
    // double requiredAngle = atan2(game.userShip.position.y - game.userShip.orbitCenter.y,
    //                              game.userShip.position.x - game.userShip.orbitCenter.x);
    //
    // double angleDifference = requiredAngle - currentAngle + pi/2;
    //
    // orbitalArc = OrbitEffects().rotatePath(orbitalArc, angleDifference);
    //
    // canvas.translate(size.x / 2, size.y / 2);
    // Vector2 delta = game.userShip.orbitCenter - game.userShip.position;
    // canvas.translate(-delta.x, -delta.y);
    //
    // canvas.drawPath(orbitalArc, circlePaint);


  }


}