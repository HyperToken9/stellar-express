
import 'package:flame/components.dart';

import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/world_data.dart';

class PlayerData{

  Map<String, SpaceShipState> spaceShipStates = {};

  Vector2 shipLocation = Vector2(4206, -2783.0) + Vector2(10, 50);
  // late Ship shipState;

  PlayerData(){
    for (SpaceShipData data in SpaceShipData.spaceShips){
      spaceShipStates[data.shipClassName] = SpaceShipState(isOwned: true);
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