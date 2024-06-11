

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

import "package:star_routes/states/dpad.dart";

import 'package:star_routes/services/authentication.dart';



class StarRoutes extends FlameGame with HasCollisionDetection{

  late Authentication auth;

  late PlayerData playerData;
  late Ship userShip;

  late DPad dpad;
  late OrbitButton orbitButton;
  late DeliveryButton deliveryButton;
  late MiniMap miniMap;
  late DashboardButton dashboardButton;
  late SwapShipButton swapShipButton;

  late NavigationPointer navigationPointer;
  late ExperienceBar experienceBar;
  late Balance balance;

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
    for (SpaceShipData shipData in SpaceShipData.spaceShips){
      if (shipData.shipClassName == "Small Courier"){
        userShip = Ship(spaceShipData: shipData);
      }
    }

    /* Initialize Hanger Ships */
    for (SpaceShipData shipData in SpaceShipData.spaceShips){
      Ship newShip = Ship(spaceShipData: shipData);
      newShip.applyPhysics = false;
      showRoomShips.add(newShip);
    }
    // showRoomShips.add(Ship(shipName: "Small Courier"));

    /* Initialize World */
    final StarWorld starWorld = StarWorld(userShip: userShip);
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

    adjustCameraZoom(objectSize: userShip.size, screenPercentage: 20);

    print("Loaded Game");

  }

  void setupHanger() {
    print("Setting up Hangar");
    dpad.setState(DPadStates.inactive);
    miniMap.setState(false);

    int index = 0;
    Vector2 startPosition = Vector2(0, 0);
    Vector2 padding = Vector2(400, 0);
    for (Ship ship in showRoomShips){

      ship.opacity = 1;
      if (world.children.contains(ship)){
        continue;
      }
      world.add(ship);
      ship.anchor = Anchor.bottomCenter;

      startPosition += padding;
      startPosition += Vector2(ship.size.x / 2, 0);
      showRoomShips[index].position = startPosition.clone();
      startPosition += Vector2(ship.size.x / 2, 0);
      // startPosition += Vector2(2.1 * showRoomShips[index].size.x, 0);

      index++;
    }
    userShip.opacity = 0;
    camera.moveTo(showRoomShips[0].position);
    adjustCameraZoom(objectSize: showRoomShips[0].size, screenPercentage: 50);
    // camera.moveTo(showRoomShips[0].position);
  }


  void setupGame(){
    dpad.setState(DPadStates.idle);
    miniMap.setState(true);

    for (Ship ship in showRoomShips){
      if (children.contains(ship)){
        remove(ship);
      }
    }
    userShip.opacity = 1;
    camera.follow(userShip);
  }

  void updateClosestPlanets(){
    closestPlanets = [];
    for (var planet in world.children) {
      if (planet is! Planet){
        continue;
      }
      closestPlanets.add(planet);
    }
    closestPlanets.sort((a, b) => a.position.distanceTo(userShip.position)
        .compareTo(b.position.distanceTo(userShip.position)));

  }

  bool detectCameraZoom() {

    if (closestPlanets.isEmpty){
      cameraZoomSetPoint = 1.0;
      return false;
    }

    double planetRadius = closestPlanets[0].size.x / 2;
    double planetDistance = closestPlanets[0].position.distanceTo(userShip.position);
    double zoomOutConstant = 0.75;
    double planetInRangeConstant = 3;

    if (planetDistance > planetInRangeConstant * planetRadius){
      cameraZoomSetPoint = 1.0;
      return false;
    }

    cameraZoomSetPoint =  zoomOutConstant * planetRadius / planetDistance;

    return true;

  }

  void setCameraZoom(){
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

    camera.viewfinder.zoom += (cameraZoomSetPoint
                             - camera.viewfinder.zoom) * 0.02;

  }


  void adjustCameraZoom({required Vector2 objectSize, required double screenPercentage}) {
    // print("Object Size: $objectSize");
    Vector2 screenSize = size;

    Vector2 targetSize = screenSize * screenPercentage / 100;

    Vector2 targetZoom = Vector2(targetSize.x  / objectSize.x, targetSize.y / objectSize.y);
    // print("Target Zoom: $targetZoom");
    cameraZoomSetPoint = targetZoom.x;

    // print("Camera Zoom Set Point: $cameraZoomSetPoint");
  }


  @override
  void update(double dt) {
    super.update(dt);

    updateClosestPlanets();

    setCameraZoom();

    // print("Num children: ${world.children.length}");

  }




}