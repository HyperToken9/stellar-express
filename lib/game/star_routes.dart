
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:star_routes/controls/mini_map.dart';

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


class StarRoutes extends FlameGame with HasCollisionDetection{

  late Ship userShip;

  late WorldData worldData;

  late DPad dpad;
  late OrbitButton orbitButton;
  late DeliveryButton deliveryButton;
  late MiniMap miniMap;
  late DashboardButton dashboardButton;
  late SwapShipButton swapShipButton;

  double cameraZoomSetPoint = 1.0;
  List<Planet> closestPlanets = [];

  @override
  Future<void> onLoad() async {

    /* Initialize World */
    worldData = WorldData();


    /* Initialize Controls */
    dpad = DPad();
    orbitButton = OrbitButton();
    deliveryButton = DeliveryButton();
    miniMap = MiniMap();
    dashboardButton = DashboardButton();
    swapShipButton = SwapShipButton();

    /* Initialize User Ship */
    for (SpaceShipData data in worldData.spaceShips){
      if (data.isEquipped){
        print("Equipped Ship: ${data.shipClassName}");
        userShip = Ship(spaceShipData: data);
      }
    }

    world = StarWorld(userShip: userShip, worldData: worldData);
    camera = CameraComponent(world: world,
        hudComponents: [dpad, orbitButton, deliveryButton, miniMap,
                        dashboardButton, swapShipButton]);

    addAll([
      Background(),
      world,
    ]);
    // await Future.wait(worldData.planets.map((planet) => planet.loadSprite()));
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
    if (cameraZoomSetPoint > 2.5){
      cameraZoomSetPoint = 2.5;
      // print("Trying to overzoom");
    }

    if (cameraZoomSetPoint < 0.5){
      cameraZoomSetPoint = 0.5;
      // print("Trying to underzoom");
    }

    camera.viewfinder.zoom += (cameraZoomSetPoint
                             - camera.viewfinder.zoom) * 0.01;

  }

  @override
  void update(double dt) {
    super.update(dt);

    updateClosestPlanets();

    detectCameraZoom();

    setCameraZoom();

    // print("Num children: ${world.children.length}");

  }




}