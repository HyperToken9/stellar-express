
import 'package:flame/components.dart';

import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/mission_data.dart';

class PlayerData{

  Vector2 shipLocation = Vector2(837.0, 2982.0) + Vector2(30, 80);

  Map<String, SpaceShipState> spaceShipStates = {};

  List<MissionData> acceptedMissions = [];

  List<MissionData> availableMissions = [];
  // List<MissionData> missions = [];


  PlayerData(){

    /* Initializes Ship States */
    for (SpaceShipData data in SpaceShipData.spaceShips){
      spaceShipStates[data.shipClassName] = SpaceShipState(isOwned: true);
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

}


class SpaceShipState{

  bool isOwned;

  SpaceShipState({
    required this.isOwned,
  });

}