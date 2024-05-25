
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:star_routes/data/planet_data.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/components/ship.dart';
import 'package:star_routes/components/planet.dart';


import 'package:star_routes/data/world_data.dart';


class StarWorld extends World with HasGameRef<StarRoutes>, CollisionCallbacks{

  Ship userShip;
  double cullingMargin = 2000;

  WorldData worldData;

  List<Planet> planetComponents = [];

  StarWorld({ required this.userShip, required this.worldData });

  @override
  Future<void> onLoad() async {

    add(userShip);

    // Time this for loop

    // DateTime startTime = DateTime.now();
    for (PlanetData data in worldData.planets){

      final planet = Planet(planetData: data);
      planetComponents.add(planet);

      // if (rShip.spawnLocation.distanceTo(data.location) < 3* cullingMargin){
      //   add(planet)use;
      // }

    }



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

      final componentRect = Rect.fromLTWH(planet.planetData.location.x - planet.planetData.radius,
                                          planet.planetData.location.y - planet.planetData.radius,
                                          planet.planetData.radius*2 , planet.planetData.radius *2 );

      if (componentRect.overlaps(expandedCameraRect) && !gameRef.world.children.contains(planet)){

        add(planet);
      }

      if (!componentRect.overlaps(expandedCameraRect) && gameRef.world.children.contains(planet)){
        remove(planet);
      }

    }

  }


}