
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

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
  final spriteSize;
  final int numSprites;
  final Color miniMapColor;


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
  });

}