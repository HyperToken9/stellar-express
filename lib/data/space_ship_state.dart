
import 'package:star_routes/data/mission_data.dart';

class SpaceShipState{

  bool isOwned;
  bool isCarryingCargo = false;

  MissionData? currentMission;

  SpaceShipState({
    required this.isOwned,
    this.isCarryingCargo = false,
    this.currentMission,
  });

  /*Ship State to JSON*/
  Map<String, dynamic> toJson(){
    return {
      'isOwned': isOwned,
      'isCarryingCargo': isCarryingCargo,
      'currentMission': currentMission?.toJson(),
    };
  }

  /*JSON to Ship State*/
  factory SpaceShipState.fromJson(Map<String, dynamic> json){
    return SpaceShipState(
      isOwned: json['isOwned'],
      isCarryingCargo: json['isCarryingCargo'],
      currentMission: (json['currentMission'] != null) ?
      MissionData.fromJson(json['currentMission']) : null,
    );
  }



}