
import 'dart:ui';

import 'package:flame/components.dart';

import 'package:star_routes/data/planet_data.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/cargo_types.dart';

class WorldData{

  static List<PlanetData> planets = [
    // PlanetData(
    //   planetName: "Aether Nexus",
    //   location: Vector2(0, 0),
    //   radius: 1000.0,
    //   mass: 0.0,
    //   population: 0,
    //   occupations: [],
    //   exports: [],
    //   imports: [],
    //   spriteName: "aether_nexus",
    //   spriteSize: Vector2(260, 260),
    //   numSprites: 50,
    //   miniMapColor: const Color(0xFFe4ffe5),
    // ),
    PlanetData(
      planetName: "Zeloris",
      location: Vector2(4206, -2783.0),
      radius: 40.0,
      mass: 0.8,
      population: 1200000000,
      occupations: ["Mining", "Agriculture"],
      exports: ["Metals", "Crops"],
      imports: ["Food", "Raw materials"],
      spriteName: "zeloris",
      spriteSize: Vector2(100, 100),
      numSprites: 50,
      miniMapColor: const Color(0xffa41652),
    ),
    PlanetData(
      planetName: "Icarion",
      location: Vector2(46.0, -4516.0),
      radius: 75.0,
      mass: 1.5,
      population: 300000000,
      occupations: ["Ice mining", "Scientific research"],
      exports: ["Ice", "Research data"],
      imports: ["Scientific equipment", "Frozen goods"],
      spriteName: "icarion",
      spriteSize: Vector2(110, 110),
      numSprites: 50,
      miniMapColor: const Color(0xFFa6b5b9),
    ),
    PlanetData(
      planetName: "Targalon",
      location: Vector2(3331.0, -4599.0),
      radius: 30.0,
      mass: 0.6,
      population: 50000000,
      occupations: ["Mining rare minerals"],
      exports: ["Rare minerals"],
      imports: ["Mining equipment", "Supplies"],
      spriteName: "targalon",
      spriteSize: Vector2(90, 90),
      numSprites: 50,
      miniMapColor: const Color(0xFFbbc993),
    ),

    PlanetData(
      planetName: "Noridia",
      location: Vector2(230.0, -3960.0),
      radius: 30,
      mass: 0.3,
      population: 100000000,
      occupations: ["Mining", "Salvaging"],
      exports: ["Salvaged materials", "Ore"],
      imports: ["Salvage parts", "Mining tools"],
      spriteName: "noridia",
      spriteSize: Vector2(70, 70),
      numSprites: 1,
      miniMapColor: const Color(0xffda8ecc),
    ),

    PlanetData(
      planetName: "Cryon",
      location: Vector2(1289.0, -3852.0),
      radius: 70.0,
      mass: 1.4,
      population: 400000000,
      occupations: ["Ice mining", "Cryogenic research"],
      exports: ["Ice", "Research data"],
      imports: ["Cryogenic supplies", "Research equipment"],
      spriteName: "cryon",
      spriteSize: Vector2(105, 105),
      numSprites: 50,
      miniMapColor: const Color(0xFF8485b9),
    ),

    // PlanetData(
    //   planetName: "Elysara",
    //   location: Vector2(682.0, -3002.0),
    //   radius: 60.0,
    //   mass: 1.2,
    //   population: 5000000000,
    //   occupations: ["Advanced scientific research", "Manufacturing"],
    //   exports: ["Manufactured goods", "Scientific data"],
    //   imports: ["Scientific experiments", "High-tech equipment"],
    //   spriteName: "elysara",
    //   spriteSize: Vector2(95, 95),
    //   numSprites: 50,
    //   miniMapColor: const Color(0xFF7cb29c),
    // ),
    //
    PlanetData(
      planetName: "Pyros",
      location: Vector2(2141.0, 3863.0),
      radius: 45.0,
      mass: 0.9,
      population: 500000000,
      occupations: ["Energy production", "Metal forging"],
      exports: ["Energy", "Forged metals"],
      imports: ["Energy cells", "Refined metals"],
      spriteName: "pyros",
      spriteSize: Vector2(105, 105),
      numSprites: 50,
      miniMapColor: const Color(0xFF552727),
    ),
    //
    // PlanetData(
    //   planetName: "Ratha",
    //   location: Vector2(3766.0, -2102.0),
    //   radius: 65.0,
    //   mass: 1.3,
    //   population: 2000000000,
    //   occupations: ["Trade", "Fishing", "Tourism"],
    //   exports: ["Fish", "Tourism services"],
    //   imports: ["Luxury goods", "Seafood"],
    //   spriteName: "ratha",
    //   spriteSize: Vector2(100, 100),
    //   numSprites: 50,
    //   miniMapColor: const Color(0xFF6067a5),
    // ),
    //
    PlanetData(
      planetName: "Dracona",
      location: Vector2(1939.0, 1625.0),
      radius: 35.0,
      mass: 0.7,
      population: 1000000000,
      occupations: ["Military training", "Weapon manufacturing"],
      exports: ["Trained soldiers", "Weapons"],
      imports: ["Weapons", "Military supplies"],
      spriteName: "dracona",
      spriteSize: Vector2(95, 95),
      numSprites: 50,
      miniMapColor: const Color(0xFF77ce4f),
    ),
    //
    // PlanetData(
    //   planetName: "Marid",
    //   location: Vector2(2703.0, -2291.0),
    //   radius: 50.0,
    //   mass: 1.0,
    //   population: 200000000,
    //   occupations: ["Scientific research", "Mineral extraction"],
    //   exports: ["Research data", "Extracted minerals"],
    //   imports: ["Research tools", "Minerals"],
    //   spriteName: "marid",
    //   spriteSize: Vector2(100, 100),
    //   numSprites: 50,
    //   miniMapColor: const Color(0xFFdd7fcd),
    // ),
    //
    // PlanetData(
    //   planetName: "Zephyros",
    //   location: Vector2(3061.0, 923.0),
    //   radius: 250.0,
    //   mass: 5.0,
    //   population: 0,
    //   occupations: ["Gas extraction", "Scientific research"],
    //   exports: ["Extracted gases", "Research data"],
    //   imports: ["Research equipment", "Gas containers"],
    //   spriteName: "zephyros",
    //   spriteSize: Vector2(130, 130),
    //   numSprites: 50,
    //   miniMapColor: const Color(0xFF290837),
    // ),
    //
    PlanetData(
      planetName: "Chronus",
      location: Vector2(837.0, 2982.0),
      radius: 150.0,
      mass: 3.0,
      population: 0,
      occupations: ["Gas mining", "Energy harvesting"],
      exports: ["Mined gases", "Harvested energy"],
      imports: ["Mining supplies", "Energy cells"],
      spriteName: "chronus",
      spriteSize: Vector2(267, 267),
      numSprites: 50,
      miniMapColor: const Color(0xFFffba2b),
    ),

    // PlanetData(
    //   planetName: "Helios",
    //   location: Vector2(1291.0, 2261.0),
    //   radius: 400.0,
    //   mass: 100.0,
    //   population: 0,
    //   occupations: ["Energy source"],
    //   exports: ["Energy"],
    //   imports: ["Energy collection"],
    //   spriteName: "helios",
    //   spriteSize: Vector2(240, 240),
    //   numSprites: 50,
    //   miniMapColor: const Color(0xFFffd0c8),
    // ),
    //
    // PlanetData(
    //   planetName: "Nebulios",
    //   location: Vector2(2969.0, -4087.0),
    //   radius: 500.0,
    //   mass: 200.0,
    //   population: 0,
    //   occupations: ["Varied"],
    //   exports: ["Varied"],
    //   imports: ["Varied"],
    //   spriteName: "nebulios",
    //   spriteSize: Vector2(250, 250),
    //   numSprites: 50,
    //   miniMapColor: const Color(0xFF747bfd),
    // ),
  ];


}



