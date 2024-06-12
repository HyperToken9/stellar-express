

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

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
      stepTime: 0.0085,
      from: 0,
      to: planetData.numSprites * planetData.numSprites,
    );

    // Set other properties after the image is loaded
    const double scaleFactor = 10;
    size = Vector2(planetData.radius, planetData.radius) * scaleFactor;
    position = planetData.location;
    anchor = Anchor.center;
    priority = 1;
    // print("Image loaded for ${planetData.spriteName}");
  }

  @override
  Future<void> onLoad() async {
    // Wait for the image to be fully loaded before proceeding
    await imageLoader;
  }




}