
import 'package:flame/components.dart';
import 'package:star_routes/data/planet_data.dart';

import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/mission_data.dart';

class PlayerData{

  Vector2 shipLocation = Vector2(1291.0, 2261.0) + Vector2(0, 300);

  Map<String, SpaceShipState> spaceShipStates = {};

  List<MissionData> acceptedMissions = [];

  List<MissionData> availableMissions = [];

  String equippedShip  = "Small Courier";


  PlayerData(){

    /* Initializes Ship States */
    for (SpaceShipData data in SpaceShipData.spaceShips){
      if (data.shipClassName == "Small Courier"){
        spaceShipStates[data.shipClassName] = SpaceShipState(isOwned: true);
      }else{
        spaceShipStates[data.shipClassName] = SpaceShipState(isOwned: false);
      }
    }

    /* Initializes Mission States*/
    for (int i = 0; i < 7; i++) {
      availableMissions.add(MissionData.makeMission(this));
    }

  }

  bool isShipOwned(String shipClassName){

    if (spaceShipStates[shipClassName] == null){
      return false;
    }
    return spaceShipStates[shipClassName]!.isOwned;

  }

  SpaceShipData getEquippedShipData(){
    return SpaceShipData.spaceShips.firstWhere((element) => element.shipClassName == equippedShip);
  }

  SpaceShipState getEquippedShipState(){
    return spaceShipStates[equippedShip]!;
  }

}


class SpaceShipState{

  bool isOwned;
  bool isCarryingCargo = false;

  MissionData? currentMission;

  SpaceShipState({
    required this.isOwned,
  });

}