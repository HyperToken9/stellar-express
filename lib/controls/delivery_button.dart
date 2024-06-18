
import 'package:flame/components.dart';
import 'package:star_routes/components/cargo_ship.dart';
import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/data/planet_data.dart';

import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/states/delivery_button.dart';
import 'package:star_routes/game/tappable_region.dart';

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
            game.world.add(CargoShip(toOrbit: false, onDeliveryComplete: () {
              print("Delivery Complete");
              print("We do delivery");
              print("Initiated Missions: ${game.playerData.initiatedMissions}");
              print("remove mission: $missionData");
              game.playerData.initiatedMissions.remove(missionData!);
              print("Initiated Missions: ${game.playerData.initiatedMissions}");
              game.playerData.completedMissions.add(missionData!);

              print("Mission Completed");

              /* Add Money to the player */
              game.playerData.coin += missionData!.reward;
              // game.balance = game.playerData.coin;

              game.playerData.getEquippedShipState().isCarryingCargo = false;
              game.playerData.getEquippedShipState().currentMission = null;
            }));

          }else{

            game.world.add(CargoShip(toOrbit: true, onDeliveryComplete: onLoadingCargo));

          }

        },
        onRelease: () {},
        buttonEnabled: isEnabled,
      )
    );


  }

  void onLoadingCargo(){

    /* Move the mission to initiaed */
    game.playerData.initiatedMissions.add(missionData!);
    game.playerData.acceptedMissions.remove(missionData!);
    print("Picked Up Cargo");

    /* Move the cargo to the ship */
    game.playerData.getEquippedShipState().isCarryingCargo = true;
    game.playerData.getEquippedShipState().currentMission = missionData!;
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