
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/components/ship.dart';
import 'package:star_routes/components/planet.dart';


import 'package:star_routes/data/world_data.dart';


class StarWorld extends World with HasGameRef<StarRoutes>, CollisionCallbacks{

  Ship userShip;
  double cullingMargin = 10000;

  List<Planet> planetComponents = [];

  StarWorld({ required this.userShip });

  Future<void> loadPlanets() async{

    planetComponents = WorldData.planets.map((data) => Planet(planetData: data)).toList();

    // Collect all the imageLoader futures
    List<Future<void>> loaders = planetComponents.map((planet) => planet.imageLoader).toList();

    // Wait for all the images to be loaded in parallel
    await Future.wait(loaders);

  }

  @override
  Future<void> onLoad() async {

    add(userShip);

  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameRef.camera.isMounted){
      return;
    }

    final cameraRect = gameRef.camera.visibleWorldRect;

    // Expand the visible world rectangle by the preload margin
    final expandedCameraRect = Rect.fromLTRB(
      cameraRect.left - cullingMargin,
      cameraRect.top - cullingMargin,
      cameraRect.right + cullingMargin,
      cameraRect.bottom + cullingMargin,
    );

    for (var planet in planetComponents) {

      final componentRect = Rect.fromLTWH(planet.position.x - planet.size.x / 2,
                                          planet.position.y - planet.size.y / 2,
                                          planet.size.x , planet.size.y );

      // if (planet.planetData.planetName == "Ratha")
      // {
      //   print("Ratha: ${componentRect.overlaps(expandedCameraRect)}");
      // }
      if (componentRect.overlaps(expandedCameraRect) && !gameRef.world.children.contains(planet)){
        add(planet);
      }

      if (!componentRect.overlaps(expandedCameraRect) && gameRef.world.children.contains(planet)){
        remove(planet);
      }

    }

  }


}