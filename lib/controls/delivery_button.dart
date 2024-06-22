
import 'package:flame/components.dart';
import 'package:star_routes/components/cargo_ship.dart';
import 'package:star_routes/components/planet.dart';
import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/data/planet_data.dart';
import 'package:star_routes/data/space_ship_state.dart';

import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/tappable_region.dart';

import 'package:star_routes/states/delivery_button.dart';
import 'package:star_routes/states/orbit_button.dart';
import 'package:star_routes/states/swap_ship_button.dart';

class DeliveryButton extends SpriteGroupComponent<DeliveryButtonStates> with HasGameRef<StarRoutes>{

  Vector2 margin = Vector2(120, 45);
  PlanetData? planetData;
  MissionData? missionData;
  bool isDelivering = false;

  // DeliveryButton();
  @override
  Future<void> onLoad() async {

    final deliveryButton = await Sprite.load(Assets.blankButton);

    double dim = 70;

    size = Vector2(dim, dim);

    position = gameRef.size - margin;

    anchor = Anchor.bottomRight;

    current = DeliveryButtonStates.inactive;
    opacity = 0;

    sprites = {
      DeliveryButtonStates.inactive: deliveryButton,
      DeliveryButtonStates.idle: deliveryButton,
    };

    add(
      TappableRegion(
        position: Vector2(0, 0),
        size: size,
        onTap: () {
          setState(DeliveryButtonStates.inactive);
          if (isDelivering){

            SpaceShipState shipState = game.playerData.getEquippedShipState();

            CargoShip cargoShip = CargoShip(missionData: missionData!, toOrbit: false,
                onDeliveryComplete: () {
                  // print("Delivery Complete");
                  // print("Initiated Missions: ${game.playerData.initiatedMissions}");
                  game.playerData.initiatedMissions.remove(missionData!);
                  // print("Initiated Missions: ${game.playerData.initiatedMissions}");
                  game.playerData.completedMissions.add(missionData!);

                  game.displayMessage("Mission Complete\n +${missionData!.reward} ATH");
                  /* Add Money to the player */
                  game.playerData.coin += missionData!.reward;

                });


            shipState.isCarryingCargo = false;
            shipState.currentMission = null;

            print("From Delivery");
            game.userShip.loadNewShip();

            game.world.add(cargoShip);

          }else{
            /* Move the mission to initiaed */
            game.orbitButton.setState(OrbitButtonStates.inactive);
            game.swapShipButton.setState(SwapShipButtonStates.inactive);

            game.playerData.initiatedMissions.add(missionData!);
            game.playerData.acceptedMissions.remove(missionData!);

            CargoShip cargoShip = CargoShip(missionData: missionData!, toOrbit: true,
                                            onDeliveryComplete: onLoadingCargo);
            cargoShip.size /= 2;
            game.world.add(cargoShip);

          }

        },
        onRelease: () {},
        buttonEnabled: isEnabled,
      )
    );


  }

  void onLoadingCargo(){


    game.displayMessage("Cargo Loaded");

    /* Move the cargo to the ship */
    game.playerData.getEquippedShipState().isCarryingCargo = true;
    game.playerData.getEquippedShipState().currentMission = missionData!;
    game.orbitButton.setState(OrbitButtonStates.exitOrbitIdle);
    if (game.userShip.orbitingPlanet != null) {
      // Planet planet = game.userShip.orbitingPlanet=;
      game.userShip.detectShipSwapping(game.userShip.orbitingPlanet!);
    }
    print("From Loading Cargo");
    game.userShip.loadNewShip();
  }

  void setState(DeliveryButtonStates state){

    if (DeliveryButtonStates.inactive == state){
      opacity = 0;
      current = DeliveryButtonStates.inactive;
    } else {
      opacity = 1;
      current = state;
    }

  }

  bool isEnabled(){

    if (DeliveryButtonStates.inactive == current){
      return false;
    }
    return true;

  }

}