

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/data/planet_data.dart';


class Planet extends SpriteAnimationComponent with HasGameRef<StarRoutes>{

  PlanetData planetData;
  // late final image;
  // late Future



  Planet({required this.planetData}){

  }

  @override
  Future<void> onLoad() async {

    print("Loading Planet: ${planetData.planetName}");
    image = await Flame.images.load("planets/${planetData.spriteName}.png");

    // Start timer
    // DateTime startTime = DateTime.now();
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: planetData.spriteSize,
    );

    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.0085,
      from: 0,
      to: planetData.numSprites * planetData.numSprites,
    );

    // sprite = await Sprite.load(Assets.planet);
    size = Vector2(planetData.radius, planetData.radius) * 2;

    position = planetData.location;
    anchor = Anchor.center;
    priority = 1;

    // End timer
    DateTime endTime = DateTime.now();
    // print("Planet Load Time: ${endTime.difference(startTime).inMilliseconds}ms");
  }




}