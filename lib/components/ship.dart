
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:star_routes/components/planet.dart';
import 'package:star_routes/data/planet_data.dart';
import 'package:star_routes/data/space_ship_state.dart';
import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/data/space_ship_data.dart';

import 'package:star_routes/game/config.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';

import 'package:star_routes/states/dpad.dart';
import 'package:star_routes/states/orbit_button.dart';
import 'package:star_routes/states/delivery_button.dart';
import 'package:star_routes/states/swap_ship_button.dart';

class Ship extends SpriteComponent with HasGameRef<StarRoutes>{

  /* Ship Data */
  // String shipName;
  SpaceShipData spaceShipData;
  Vector2 spawnLocation;

  /* Ship Control State */
  bool applyPhysics = true;
  Vector2 impulse = Vector2.zero();
  Vector2 linearVelocity = Vector2.zero();
  double angularVelocity = 0;

  /* Ship Orbit State */
  bool inOrbit = false;
  Vector2 orbitCenter =  Vector2(0, 0);
  double targetOrbitRadius = 300;
  double targetShipAngle = 0;
  double orbitRadius = 300;
  double angleInOrbit = 0;
  //TODO: int orbitDirection = 1;


  /* Ship Attributes */
  double _maxVelocity = 0;
  double _maxAngularVelocity = 0;

  late ParticleSystemComponent particleComponent;

  Ship({required this.spaceShipData, required this.spawnLocation}){
    size = Vector2(spaceShipData.spriteSize[0].toDouble(),
                   spaceShipData.spriteSize[1].toDouble());
    position = spawnLocation;
    priority = 2;
  }

  @override
  Future<void> onLoad() async {
    // Load the ship image
    sprite = await Sprite.load("${Assets.shipBasePath}${spaceShipData.spriteName}.png");
    print("Loaded Ship: ${spaceShipData.shipClassName}");
    // position = game.playerData.shipSpawnLocation;
    anchor = Anchor.center;

    /* Game Attributes */
    _maxVelocity = 600;
    _maxAngularVelocity = 8;
    priority = 2;

    /* Add Hit Box */
    add(RectangleHitbox());

    final thrustImage = await Flame.images.load('particles/effect_yellow.png');

    particleComponent = ParticleSystemComponent(
      anchor: Anchor.center,
      position: position,
      priority: 1,
      particle: Particle.generate(
          lifespan: 1,
          count: 100,
          generator: (i){
            return AcceleratedParticle(
                position: Vector2(size.x/2, 0),
                acceleration: Vector2(0, Random().nextDouble() * 100),
                speed: Vector2(0, Random().nextDouble() * 100),
                child: CircleParticle(
                  radius: 10,
                  paint: Paint()..color = const Color(0xFFFFCC00),
                ),
            );

          }
      )


    );


  }

  void setImpulse(Vector2 impulseUpdate){
    // print("Detected Impulse");
    impulse = impulseUpdate;
  }

  void setVelocity(){
    /* Momentum Decay */
    if (impulse.y == 0){
      angularVelocity = angularVelocity * 0.99;
    }
    if (impulse.x == 0){
      linearVelocity = linearVelocity * 0.999;
    }

    /* Calculate Error  */
    angularVelocity += (_maxAngularVelocity * impulse.y - angularVelocity) * 0.01;

    linearVelocity = linearVelocity + Vector2(sin(angle), -cos(angle)) * impulse.x * 2;


    /* Normalize */
    if (linearVelocity.length > _maxVelocity){
      linearVelocity = linearVelocity.normalized() * _maxVelocity;
      // print("Max Velocity Reached");
    }

    if (angularVelocity.abs() > _maxAngularVelocity){
      angularVelocity = _maxAngularVelocity * angularVelocity.sign;
    }


  }

  @override
  void update(double dt){
    super.update(dt);


    // particleComponent.position = position;
    gameRef.world.add(ParticleSystemComponent(
        anchor: Anchor.center,
        position: position,
        priority: 1,
        particle: Particle.generate(
            lifespan: 1,
            count: 2,
            generator: (i){
              return AcceleratedParticle(
                position: Vector2(size.x/2, 0),
                acceleration: Vector2(0, Random().nextDouble() * 100),
                speed: Vector2(0, Random().nextDouble() * 100),
                child: CircleParticle(
                  radius: 5,
                  paint: Paint()..color = const Color(0xAAFFCC00),
                ),
              );

            }
        )));

    // print("Partciel Prog: ${particleComponent.progress}");

    if (!applyPhysics){
      return;
    }
    // print("${gameRef.camera.}");
    // print("Ship name: $shipName");
    /* Update Position */
    setVelocity();
    position += linearVelocity * dt;
    angle += angularVelocity * dt;

    /* Check If Eligible to enter orbit */
    if (gameRef.closestPlanets.isNotEmpty && !inOrbit){
      Planet closestPlanet = gameRef.closestPlanets[0];

      if (closestPlanet.position.distanceTo(position) < closestPlanet.size.x * 1.5) {
        gameRef.orbitButton.setState(OrbitButtonStates.enterOrbitIdle);
        // gameRef.deliveryButton.setState(DeliveryButtonStates.idle);
      } else{
        gameRef.orbitButton.setState(OrbitButtonStates.inactive);
        // gameRef.deliveryButton.setState(DeliveryButtonStates.inactive);
      }

    }


    /* Orbit Mechanics */
    if (inOrbit){

      angleInOrbit += 0.006;
      targetShipAngle = angleInOrbit - pi;

      position = orbitCenter + Vector2(cos(angleInOrbit), sin(angleInOrbit)) * orbitRadius;
      angle = angle + (targetShipAngle - angle) * 0.05;

      orbitRadius += (targetOrbitRadius - orbitRadius) * 0.01 ;

    }


    /* Clip By Boundary */
    Vector2 boundaryPushback = Vector2.zero();
    double boundaryPushbackConstant = 0.05;
    if (position.x < Config.worldBoundaryLeft * Config.spaceScaleFactor) {
      boundaryPushback.x = (Config.worldBoundaryLeft * Config.spaceScaleFactor - position.x) * boundaryPushbackConstant;
    } else if (position.x > Config.worldBoundaryRight * Config.spaceScaleFactor) {
      boundaryPushback.x = (Config.worldBoundaryRight * Config.spaceScaleFactor - position.x) * boundaryPushbackConstant;
    }

    if (position.y < Config.worldBoundaryTop * Config.spaceScaleFactor) {
      boundaryPushback.y = (Config.worldBoundaryTop * Config.spaceScaleFactor - position.y) * boundaryPushbackConstant;
    } else if (position.y > Config.worldBoundaryBottom * Config.spaceScaleFactor) {
      boundaryPushback.y = (Config.worldBoundaryBottom * Config.spaceScaleFactor - position.y) * boundaryPushbackConstant;
    }

    linearVelocity += boundaryPushback;

  }


  void insertIntoOrbit() {

    if (gameRef.closestPlanets.isEmpty){
      return;
    }
    Planet closestPlanet = gameRef.closestPlanets[0];

    /* Set Focus the planet */
    gameRef.camera.follow(closestPlanet, maxSpeed: 500);
    gameRef.adjustCameraZoom(objectSize: closestPlanet.size,
                             screenPercentage: Config.cameraZoomPercentageInOrbit);

    /* Set Orbital Dynamics */
    targetOrbitRadius = closestPlanet.size.x/2 + 500;
    orbitRadius = closestPlanet.position.distanceTo(position);
    orbitCenter = closestPlanet.position;
    Vector2 delta = closestPlanet.position - position;
    angleInOrbit = atan2(delta.y, delta.x) + pi;
    inOrbit = true;
    linearVelocity = Vector2.zero();

    /* Disable D-Pad */
    gameRef.dpad.setState(DPadStates.inactive);

    /* Disable MiniMap */
    gameRef.miniMap.setState(false);

    /* Enable Delivery Button */
    /* Check if ship has cargo */
    final SpaceShipState shipState = game.playerData.getEquippedShipState();

    if (shipState.isCarryingCargo &&
        shipState.currentMission!.destinationPlanet == closestPlanet.planetData.planetName){
      print("Cargo Delivery");
      gameRef.deliveryButton.setState(DeliveryButtonStates.idle);
      gameRef.deliveryButton.missionData = shipState.currentMission;
      gameRef.deliveryButton.planetData = closestPlanet.planetData;
      gameRef.deliveryButton.isDelivering = true;

    }else{
      for (MissionData mission in game.playerData.acceptedMissions){

        if (mission.sourcePlanet == closestPlanet.planetData.planetName){
          print("Cargo Pickup");
          gameRef.deliveryButton.setState(DeliveryButtonStates.idle);
          gameRef.deliveryButton.planetData = closestPlanet.planetData;
          gameRef.deliveryButton.missionData = mission;
          gameRef.deliveryButton.isDelivering = false;
          break;
        }

      }
    }

    /* Swapping Ships */
    for (SpaceShipData shipData in SpaceShipData.spaceShips){
      SpaceShipState? shipState = game.playerData.spaceShipStates[shipData.shipClassName];
      if (shipState == null){
        continue;
      }
      if (!shipState.isOwned){
        continue;
      }
      if (shipState.dockedAt
          == closestPlanet.planetData.planetName){
        print("Found: ${shipData.shipClassName}");
        gameRef.swapShipButton.planetData = closestPlanet.planetData;
        gameRef.swapShipButton.setState(SwapShipButtonStates.idle);
        break;
      }
    }
    /* If A ship exits on planet */
    // for (SpaceShipData shipData in gameRef.worldData.spaceShips){
    //   if (shipData.dockedPlanet == closestPlanet.planetData.planetName){
    //     gameRef.swapShipButton.planetData = closestPlanet.planetData;
    //     gameRef.swapShipButton.setState(SwapShipButtonStates.idle);
    //     break;
    //   }
    // }

  }

  void removeFromOrbit(){
    inOrbit = false;

    /* Enable DPad */
    gameRef.dpad.setState(DPadStates.idle);
    /* Enable MiniMap */
    gameRef.miniMap.setState(true);

    /* Set Focus on Ship */
    // gameRef.camera.moveTo(position, speed: 500);
    gameRef.camera.follow(this, maxSpeed: _maxVelocity * 10);
    gameRef.adjustCameraZoom(objectSize: size, screenPercentage: spaceShipData.zoomPercentage);

    /* Setting Residual Impulse & Angular Velocity to Zero */
    impulse = Vector2.zero();
    angularVelocity = 0;

    /* Exit Orbit with half max velocity along the tangent */
    double tangentAngle = angleInOrbit + pi / 2;
    linearVelocity = Vector2(cos(tangentAngle), sin(tangentAngle)) * _maxVelocity * 0.25;

    gameRef.deliveryButton.setState(DeliveryButtonStates.inactive);
    gameRef.swapShipButton.setState(SwapShipButtonStates.inactive);

  }

  void loadNewShip() async {
    sprite = await Sprite.load("${Assets.shipBasePath}${spaceShipData.spriteName}.png");
    size = Vector2(spaceShipData.spriteSize[0].toDouble(),
                   spaceShipData.spriteSize[1].toDouble());
    position = game.playerData.shipSpawnLocation;

    if (!inOrbit){
      game.adjustCameraZoom(objectSize: size, screenPercentage: spaceShipData.zoomPercentage);
      game.camera.follow(this);
    }else{
      game.dpad.setState(DPadStates.inactive);
      game.miniMap.setState(false);
    }

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {

    print("Collision Detected");

  }


}