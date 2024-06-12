
import 'package:star_routes/data/mission_data.dart';

class SpaceShipState{

  bool isOwned;
  bool isCarryingCargo;
  bool isEquipped;
  MissionData? currentMission;
  String dockedAt;

  SpaceShipState({
    required this.isOwned,
    this.isCarryingCargo = false,
    required this.isEquipped,
    required this.dockedAt,
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
      isEquipped: json['isEquipped'],
      dockedAt: json['dockedAt'],
    );
  }

  String displayLocationStatus(){
    if (dockedAt == ""){
      return "Floating In Space".toUpperCase();
    }
    return "Docked At $dockedAt".toUpperCase();
  }

  String displayMissionStatus(){
    if  (currentMission == null){
      return "No Active Mission".toUpperCase();

    }
    return "Mission Active".toUpperCase();
  }

  String displayCrashes(){
    return "6";
  }

  String displayMissionCount(){
    return "3";
  }
}