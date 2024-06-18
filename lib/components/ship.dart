
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:star_routes/components/planet.dart';
import 'package:star_routes/components/thrusters.dart';
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
  double orbitalAngularVelocityFactor = 0;
  double orbitalAngularVelocity = 0;
  double targetOrbitRadius = 300;
  double targetShipAngle = 0;
  double orbitRadius = 300;
  double angleInOrbit = 0;
  double offsetAngle = 0;
  Planet? orbitingPlanet;
  //TODO: int orbitDirection = 1;


  /* Ship Attributes */
  double _maxVelocity = 0;
  double _maxAngularVelocity = 0;
  double _linearAcceleration = 0;
  double _angularAcceleration = 0;

  late ParticleSystemComponent particleComponent;

  Ship({required this.spaceShipData, required this.spawnLocation}){
  // Ship(){
    size = Vector2(spaceShipData.spriteSize[0].toDouble(),
                   spaceShipData.spriteSize[1].toDouble());
    position = spawnLocation;
    priority = 6;
  }

  @override
  Future<void> onLoad() async {
    // Load the ship image
    sprite = await Sprite.load("${Assets.shipBasePath}${spaceShipData.spriteName}.png");

    anchor = Anchor.center;

    /* Game Attributes */
    _maxVelocity = 0;
    _maxAngularVelocity = 0;
    _linearAcceleration = 0;
    _angularAcceleration = 0;

    /* Add Hit Box */
    add(RectangleHitbox());

    add(Thrusters());

  }

  void setImpulse(Vector2 impulseUpdate){
    // print("Detected Impulse");
    impulse = impulseUpdate;
  }

  void setVelocity() {
    /* Momentum Decay */
    if (impulse.y == 0) {
      angularVelocity = angularVelocity * 0.99;
    }
    if (impulse.x == 0) {
      linearVelocity = linearVelocity * 0.999;
    }

    Vector2 addedLinearVelocity = Vector2(sin(angle), -cos(angle)) * impulse.x * _linearAcceleration;
    Vector2 bufferLinearVelocity = linearVelocity;
    double currentSpeed = bufferLinearVelocity.length;

    /* Calculate Error  */
    angularVelocity += (_maxAngularVelocity * impulse.y - angularVelocity) * _angularAcceleration;

    bufferLinearVelocity += addedLinearVelocity;

    // If the new velocity exceeds the max velocity and the current speed is less than the new speed
    if (bufferLinearVelocity.length > _maxVelocity && currentSpeed < bufferLinearVelocity.length) {
      // Cap the velocity to the previous current speed if it exceeds the max velocity
      bufferLinearVelocity = bufferLinearVelocity.normalized() * currentSpeed;
    }

    linearVelocity = bufferLinearVelocity;


    if (angularVelocity.abs() > _maxAngularVelocity) {
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

      orbitalAngularVelocity = orbitalAngularVelocityFactor / pow(max(orbitRadius,1), 3 / 2);

      angleInOrbit += orbitalAngularVelocity * dt;
      targetShipAngle = angleInOrbit - pi + degrees2Radians * 12;

      position = orbitCenter + Vector2(cos(angleInOrbit), sin(angleInOrbit)) * orbitRadius;

      double deltaAngle = (targetShipAngle - angle) % (2 * pi);
      if (deltaAngle > pi) {
        deltaAngle -= 2 * pi;
      } else if (deltaAngle < -pi) {
        deltaAngle += 2 * pi;
      }
      angle += deltaAngle * 0.05;

      orbitRadius += (targetOrbitRadius - orbitRadius) * 0.01 ;

      if (orbitingPlanet != null){
        detectCargoDelivery(orbitingPlanet!);
      }

    }else{
      /* Update Position */
      setVelocity();
      position += linearVelocity * dt;
      angle += angularVelocity * dt;
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

    orbitingPlanet = closestPlanet;

    /* Set Orbital Dynamics */
    targetOrbitRadius = closestPlanet.size.x / 2 + size.x / 1.1;
    orbitRadius = closestPlanet.position.distanceTo(position);
    orbitCenter = closestPlanet.position;
    orbitalAngularVelocityFactor = closestPlanet.planetData.getAngularVelocityFactor();
    Vector2 delta = closestPlanet.position - position;
    angleInOrbit = atan2(delta.y, delta.x) + pi;
    inOrbit = true;
    linearVelocity = Vector2.zero();

    /* Set Focus the planet */
    double distanceToClosestPlanet = closestPlanet.position.distanceTo(position);
    gameRef.camera.follow(closestPlanet, maxSpeed: 1 + distanceToClosestPlanet);
    gameRef.adjustCameraZoom(objectSize: Vector2.all(targetOrbitRadius * 2),
                             screenPercentage: 95);

    /* Disable D-Pad */
    gameRef.dpad.setState(DPadStates.inactive);

    // /* Disable MiniMap */
    // gameRef.miniMap.setState(false);

    /* Enable Delivery Button */
    /* Check if ship has cargo */




    // gameRef.deliveryButton.setState(DeliveryButtonStates.idle);
    // gameRef.deliveryButton.isDelivering = true;


    detectCargoDelivery(closestPlanet);

    detectShipSwapping(closestPlanet);


  }

  void detectCargoDelivery(Planet closestPlanet){
    final SpaceShipState shipState = game.playerData.getEquippedShipState();
    if (shipState.isCarryingCargo &&
        shipState.currentMission!.destinationPlanet == closestPlanet.planetData.planetName){
      // print("Cargo Delivery");
      gameRef.deliveryButton.setState(DeliveryButtonStates.idle);
      gameRef.deliveryButton.missionData = shipState.currentMission;
      gameRef.deliveryButton.planetData = closestPlanet.planetData;
      gameRef.deliveryButton.isDelivering = true;

    }else{
      for (MissionData mission in game.playerData.acceptedMissions){

        if (mission.sourcePlanet == closestPlanet.planetData.planetName){
          // print("Cargo Pickup");
          gameRef.deliveryButton.setState(DeliveryButtonStates.idle);
          gameRef.deliveryButton.planetData = closestPlanet.planetData;
          gameRef.deliveryButton.missionData = mission;
          gameRef.deliveryButton.isDelivering = false;
          break;
        }

      }
    }
  }


  void detectShipSwapping(Planet closestPlanet){
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
        gameRef.swapShipButton.planetComponent = closestPlanet;
        gameRef.swapShipButton.setState(SwapShipButtonStates.idle);
        break;
      }
    }
  }

  void removeFromOrbit(){


    inOrbit = false;
    orbitingPlanet = null;


    /* Enable DPad */
    gameRef.dpad.setState(DPadStates.idle);
    /* Enable MiniMap */
    // gameRef.miniMap.setState(true);

    /* Set Focus on Ship */
    // gameRef.camera.moveTo(position, speed: 500);
    gameRef.camera.follow(this, maxSpeed: _maxVelocity * 10);
    gameRef.adjustCameraZoom(objectSize: size, screenPercentage: spaceShipData.zoomPercentage);

    /* Setting Residual Impulse & Angular Velocity to Zero */
    impulse = Vector2.zero();
    angularVelocity = 0;

    /* Exit Orbit with half max velocity along the tangent */
    double tangentAngle = angleInOrbit + pi / 2;
    linearVelocity = Vector2(cos(tangentAngle), sin(tangentAngle)).normalized() /* Direction */
                     * orbitalAngularVelocity * orbitRadius; /* Magnitude */

    gameRef.deliveryButton.setState(DeliveryButtonStates.inactive);
    gameRef.swapShipButton.setState(SwapShipButtonStates.inactive);

  }

  void loadNewShip({Vector2? atPosition}) async {
    for  (SpaceShipData shipData in SpaceShipData.spaceShips){
      if (shipData.shipClassName == game.playerData.equippedShip){
        spaceShipData = shipData;
        // print("Equipped Ship: ${spaceShipData.shipClassName}");
        break;
      }
    }

    sprite = await Sprite.load("${Assets.shipBasePath}${spaceShipData.spriteName}.png");
    size = Vector2(spaceShipData.spriteSize[0].toDouble(),
                   spaceShipData.spriteSize[1].toDouble());
    position = atPosition ?? game.playerData.shipSpawnLocation;

    _maxVelocity = spaceShipData.maxVelocity;
    _maxAngularVelocity = spaceShipData.maxAngularVelocity;
    _linearAcceleration = spaceShipData.linearAcceleration;
    _angularAcceleration = spaceShipData.angularAcceleration;

    if (!inOrbit){
      game.adjustCameraZoom(objectSize: size, screenPercentage: spaceShipData.zoomPercentage);
      game.camera.follow(this);
    }else{
      game.dpad.setState(DPadStates.inactive);
      // game.miniMap.setState(false);
    }

  }

  @override
  double get angle => super.angle + offsetAngle;

  @override
  set angle(double newAngle) {
    super.angle = newAngle - offsetAngle;
  }

/*  @override
  void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {

    print("Collision Detected");

  }*/


}