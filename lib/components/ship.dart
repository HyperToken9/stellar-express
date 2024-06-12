
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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

  // Ship({required this.spaceShipData});

  Ship({required this.spaceShipData, required this.spawnLocation}){
    size = Vector2(spaceShipData.spriteSize[0].toDouble(),
                   spaceShipData.spriteSize[1].toDouble());
    position = spawnLocation;
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

    /* Add Hit Box */
    add(RectangleHitbox());

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
    if (position.x < Config.worldBoundaryLeft) {
      boundaryPushback.x = (Config.worldBoundaryLeft - position.x) * boundaryPushbackConstant;
    } else if (position.x > Config.worldBoundaryRight) {
      boundaryPushback.x = (Config.worldBoundaryRight - position.x) * boundaryPushbackConstant;
    }

    if (position.y < Config.worldBoundaryTop) {
      boundaryPushback.y = (Config.worldBoundaryTop - position.y) * boundaryPushbackConstant;
    } else if (position.y > Config.worldBoundaryBottom) {
      boundaryPushback.y = (Config.worldBoundaryBottom - position.y) * boundaryPushbackConstant;
    }

    linearVelocity += boundaryPushback;

  }


  void insertIntoOrbit() {

    if (gameRef.closestPlanets.isEmpty){
      return;
    }
    Planet closestPlanet = gameRef.closestPlanets[0];

    /* Set Focus the planet */
    gameRef.camera.follow(closestPlanet, maxSpeed: _maxVelocity * 0.3);

    /* Set Orbital Dynamics */
    targetOrbitRadius = closestPlanet.size.x;
    orbitRadius = closestPlanet.position.distanceTo(position);
    orbitCenter = closestPlanet.position;
    Vector2 delta = closestPlanet.position - position;
    angleInOrbit = atan2(delta.y, delta.x) + pi;
    inOrbit = true;

    /* Disable D-Pad */
    gameRef.dpad.setState(DPadStates.inactive);

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


    for (SpaceShipData shipData in SpaceShipData.spaceShips){
      if (game.playerData.spaceShipStates[shipData.shipClassName]!.dockedAt
          == closestPlanet.planetData.planetName){
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
    gameRef.dpad.setState(DPadStates.idle);

    /* Set Focus on Ship */
    gameRef.camera.follow(this, maxSpeed: _maxVelocity);

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
    game.adjustCameraZoom(objectSize: size, screenPercentage: spaceShipData.zoomPercentage);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {

    print("Collision Detected");

  }


}