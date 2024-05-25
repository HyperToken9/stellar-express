
import 'dart:ui';

import 'package:flame/components.dart';

class PlanetData{

  /* Identification Data */
  String planetName;

  /* Physical Data */
  Vector2 location;
  double radius;
  double mass;

  /* Cultural Data */
  int population;
  List<String> occupations;
  List<String> exports;
  List<String> imports;

  /* Sprite Data */
  String spriteName;
  Vector2 spriteSize;
  int numSprites;
  Color miniMapColor;

  /* Constructor */
  PlanetData({
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