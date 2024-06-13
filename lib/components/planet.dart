

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:star_routes/game/config.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/data/planet_data.dart';


class Planet extends SpriteAnimationComponent with HasGameRef<StarRoutes>{

  PlanetData planetData;
  late Future<void> imageLoader;
  // late final image;
  // late Future


  Planet({required this.planetData}) {
    // Initiate the background loading of the image
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
    priority = 1;
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


    /*Draw a red circle of size */
    Paint circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;
    super.render(canvas);
    // canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x, circlePaint);


  }


}