

import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:star_routes/components/balance.dart';
import 'package:star_routes/components/experience_bar.dart';
import 'package:star_routes/components/navigation_pointer.dart';
import 'package:star_routes/controls/mini_map.dart';

import 'package:star_routes/data/player_data.dart';
import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/data/world_data.dart';
import 'package:star_routes/data/space_ship_data.dart';

import 'package:star_routes/game/star_world.dart';
import 'package:star_routes/game/config.dart';

import 'package:star_routes/components/background.dart';
import 'package:star_routes/components/ship.dart';
import 'package:star_routes/controls/dpad.dart';
import 'package:star_routes/controls/orbit_button.dart';
import 'package:star_routes/components/planet.dart';
import 'package:star_routes/controls/delivery_button.dart';
import 'package:star_routes/controls/dashboard_button.dart';
import 'package:star_routes/controls/swap_ship_button.dart';
import 'package:star_routes/screens/loading_screen.dart';
import 'package:star_routes/screens/main_menu_screen.dart';
import 'package:star_routes/services/datastore.dart';

import "package:star_routes/states/dpad.dart";
import 'package:star_routes/states/delivery_button.dart';

import 'package:star_routes/services/authentication.dart';
import 'package:star_routes/states/orbit_button.dart';
import 'package:star_routes/states/swap_ship_button.dart';



class StarRoutes extends FlameGame with HasCollisionDetection{

  late Authentication auth;

  late PlayerData playerData;
  late Ship userShip;
  late StarWorld starWorld;

  late DPad dpad;
  late OrbitButton orbitButton;
  late DeliveryButton deliveryButton;
  late MiniMap miniMap;
  late DashboardButton dashboardButton;
  late SwapShipButton swapShipButton;

  late NavigationPointer navigationPointer;
  late ExperienceBar experienceBar;
  late Balance balance;

  bool isDetectingPlanet = false;
  double cameraZoomSetPoint = 1.0;
  List<Planet> closestPlanets = [];

  List<Ship> showRoomShips = [];

  StarRoutes({required this.playerData});

  @override
  Future<void> onLoad() async {

    /* Initialize Controls */
    dpad = DPad();
    orbitButton = OrbitButton();
    deliveryButton = DeliveryButton();
    miniMap = MiniMap();
    dashboardButton = DashboardButton();
    swapShipButton = SwapShipButton();

    /* Initialize UI Elements */
    navigationPointer = NavigationPointer();
    experienceBar = ExperienceBar();
    balance = Balance();

    /* Initialize User Ship */

    userShip = Ship(spaceShipData: SpaceShipData.spaceShips[0], spawnLocation: playerData.shipSpawnLocation);


    /* Initialize Hanger Ships */
    Vector2 startPosition = Vector2(0, 0);
    Vector2 padding = Vector2(400, 0);

    for (SpaceShipData shipData in SpaceShipData.spaceShips){
      startPosition += padding;
      startPosition += Vector2(shipData.spriteSize[0] / 2, 0);
      Ship newShip = Ship(spaceShipData: shipData, spawnLocation: startPosition.clone());
      startPosition += Vector2(shipData.spriteSize[0] / 2, 0);

      newShip.applyPhysics = false;
      showRoomShips.add(newShip);
    }
    // showRoomShips.add(Ship(shipName: "Small Courier"));

    /* Initialize World */
    starWorld = StarWorld(userShip: userShip);
    await starWorld.loadPlanets();
    world = starWorld;


    camera = CameraComponent(world: world,
        hudComponents: [dpad, orbitButton, deliveryButton, miniMap,
                        dashboardButton, swapShipButton, navigationPointer,
                        experienceBar, balance]);

    // print("Children of the camera ${camera.hud}");
    addAll([
      Background(),
      world,
    ]);
    // await Future.wait(worldData.planets.map((planet) => planet.loadSprite()));
    camera.follow(userShip);

    for (var planet in starWorld.planetComponents) {
      closestPlanets.add(planet);
    }


    print("Loaded Game");

  }

  void setupHanger() {
    print("Setting up Hangar");

    dpad.setState(DPadStates.inactive);
    miniMap.setState(false);
    orbitButton.setState(OrbitButtonStates.inactive);
    swapShipButton.setState(SwapShipButtonStates.inactive);
    deliveryButton.setState(DeliveryButtonStates.inactive);


    isDetectingPlanet = false;

    for (Ship ship in showRoomShips){

      ship.opacity = 1;
      if (world.children.contains(ship)){
        continue;
      }
      world.add(ship);
      // ship.anchor = Anchor.bottomCenter;


      // startPosition += Vector2(2.1 * showRoomShips[index].size.x, 0);
    }

    userShip.opacity = 0;

    for (Planet planetComponent in starWorld.planetComponents){
      planetComponent.opacity = 0;
    }
    // camera.stop();
    camera.follow(showRoomShips[0]);
    adjustCameraZoom(objectSize: showRoomShips[0].size, screenPercentage: 80);
    // camera.moveTo(showRoomShips[0].position);
  }

  void setupGame(){

    loadGame();

    dpad.setState(DPadStates.idle);
    miniMap.setState(true);

    isDetectingPlanet = true;

    for (Ship ship in showRoomShips){
      if (world.children.contains(ship)){
        world.remove(ship);
      }
    }

    for (Planet planetComponent in starWorld.planetComponents){
      planetComponent.opacity = 1;
    }
    // print("Player Data location: ${playerData.shipSpawnLocation}");
    // print("Ship Spawn Location: ${userShip.position}");

    if (userShip.inOrbit){
      camera.follow(userShip.orbitingPlanet!);
      adjustCameraZoom(objectSize: Vector2.all(userShip.targetOrbitRadius*2),
                       screenPercentage: 95);
      orbitButton.setState(OrbitButtonStates.exitOrbitIdle);

      if (userShip.orbitingPlanet != null){
        userShip.detectShipSwapping(userShip.orbitingPlanet!);
      }

    }else{
      camera.follow(userShip);
    }
    userShip.opacity = 1;
    userShip.loadNewShip();

  }

  void saveGame(){

    Datastore dataStore = Datastore();
    dataStore.saveDataLocally(this);

  }

  void loadGame(){

    Datastore dataStore = Datastore();
    dataStore.loadDataLocally(playerData);

  }


  void initializePlayerData(String playerId){
    playerData.loadPlayerData(playerId);
  }

  void updateClosestPlanets(){

    closestPlanets.sort((a, b) => a.position.distanceTo(userShip.position)
        .compareTo(b.position.distanceTo(userShip.position)));

  }

  bool detectCameraZoom() {
    if (!isDetectingPlanet){
      return false;
    }
    if (closestPlanets.isEmpty){
      return false;
    }

    if (userShip.inOrbit){
      return false;
    }

    double zoomDistanceThreshold = 6000 + closestPlanets[0].size.x / 1.52;
    Planet closestPlanet = closestPlanets[0];
    // print("Closest Planet: ${closestPlanet.planetData.planetName}");

    double distanceToPlanet = closestPlanet.position.distanceTo(userShip.position);

    if (distanceToPlanet > zoomDistanceThreshold){
      return false;
    }
    // print("Closest Planet: ${closestPlanet.planetData.planetName} Size:: ${closestPlanet.size}");
    double zoomInfinity = calculateCameraZoom(objectSize: userShip.size,
                                              screenPercentage: userShip.spaceShipData.zoomPercentage);

    double zoomOrbit = calculateCameraZoom(objectSize: closestPlanet.size,
                                            screenPercentage: Config.cameraZoomPercentageInOrbit);

    cameraZoomSetPoint = zoomOrbit + (distanceToPlanet - closestPlanet.size.x / 2)
                                   * (zoomInfinity - zoomOrbit)
                                   / (zoomDistanceThreshold - closestPlanet.size.x / 2);

    cameraZoomSetPoint = max(zoomOrbit, cameraZoomSetPoint);
    cameraZoomSetPoint = min(zoomInfinity, cameraZoomSetPoint);


    return true;

  }

  void _setCameraZoom(){
    // print("Camera Zoom Set Point: $cameraZoomSetPoint");
    // if (cameraZoomSetPoint > 2.5){
    //   cameraZoomSetPoint = 2.5;
    //   print("Trying to overzoom");
    // }
    //
    // if (cameraZoomSetPoint < 0.5){
    //   cameraZoomSetPoint = 0.5;
    //   print("Trying to underzoom");
    // }
    // print("Setting Camera Zoom: ${camera.viewfinder.zoom} to $cameraZoomSetPoint");
    camera.viewfinder.zoom += (cameraZoomSetPoint
                             - camera.viewfinder.zoom) * 0.04;

  }


  double calculateCameraZoom({required Vector2 objectSize, required double screenPercentage}) {
    Vector2 screenSize = size;

    // print("Object Size: $objectSize");
    Vector2 targetSize = screenSize * screenPercentage / 100;

    Vector2 targetZoom = Vector2(targetSize.x  / objectSize.x, targetSize.y / objectSize.y);

    return targetZoom.x;
  }

  void adjustCameraZoom({required Vector2 objectSize, required double screenPercentage}) {

    cameraZoomSetPoint = calculateCameraZoom(objectSize: objectSize,
                                              screenPercentage: screenPercentage);

    print("Camera Zoom Set Point: $cameraZoomSetPoint");
  }


  @override
  void update(double dt) {
    super.update(dt);

    updateClosestPlanets();

    detectCameraZoom();

    _setCameraZoom();

    // print("Num children: ${world.children.length}");

  }




}