
import 'package:star_routes/data/mission_data.dart';

class SpaceShipState{

  int crashes;
  int missionsCompleted;
  bool isOwned;
  bool isCarryingCargo;
  bool isEquipped;
  MissionData? currentMission;
  String dockedAt;

  SpaceShipState({
    required this.isOwned,
    required this.isEquipped,
    this.isCarryingCargo = false,
    this.dockedAt = "",
    this.currentMission,
    this.crashes = 0,
    this.missionsCompleted = 0,
  }){
    /* If not equipped and ownned docked At can not be "" */
    if (!isEquipped && isOwned){
      /*Throw error */
      if (dockedAt == ""){
        throw Exception("Ship must be docked if owned but not equipped");
      }
    }
  }

  /*Ship State to JSON*/
  Map<String, dynamic> toJson(){
    return {
      'isOwned': isOwned,
      'isCarryingCargo': isCarryingCargo,
      'currentMission': currentMission?.toJson(),
      'isEquipped': isEquipped,
      'dockedAt': dockedAt,
      'crashes': crashes,
      'missionsCompleted': missionsCompleted,
    };
  }

  /*JSON to Ship State*/
  factory SpaceShipState.fromJson(Map<String, dynamic> json){
    // print(json);
    // print("SHIP sTATE FROM JSON: $json");

    MissionData? missionDetails = (json['currentMission'] != null) ?
          MissionData.fromJson(Map<String, dynamic>.from(json['currentMission']))
            : null;
    return SpaceShipState(
      isOwned: json['isOwned'],
      isEquipped: json['isEquipped'],
      isCarryingCargo: json['isCarryingCargo'] ?? false,
      currentMission: missionDetails,
      dockedAt: json['dockedAt'] ?? "",
      crashes: json['crashes'] ?? 0,
      missionsCompleted: json['missionsCompleted'] ?? 0,
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
    return "{$crashes}";
  }

  String displayMissionCount(){
    return "{$missionsCompleted}";
  }
}