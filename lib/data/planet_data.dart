
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

class PlanetData{

  /* Identification Data */
  final String planetName;

  /* Physical Data */
  final Vector2 location;
  final double radius;
  final double mass;

  /* Cultural Data */
  final int population;
  final List<String> occupations;
  final List<String> exports;
  final List<String> imports;

  /* Sprite Data */
  final String spriteName;
  final Vector2 spriteSize;
  final int numSprites;
  final Color miniMapColor;
  final double spriteSpeed;

  /* Constructor */
  const PlanetData({
    required this.planetName,
    required this.location,
    required this.radius,
    required this.mass,
    required this.population,
    required this.occupations,
    required this.exports,
    required this.imports,
    required this.spriteName,
    required this.spriteSize,
    required this.numSprites,
    this.miniMapColor = const Color(0xEEFFFFFF),
    this.spriteSpeed = 0.0085,
  });


  double getAngularVelocityFactor(){
    return 75000 * sqrt(mass);
  }

}