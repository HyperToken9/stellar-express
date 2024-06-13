
import 'package:star_routes/data/mission_data.dart';

class SpaceShipState{

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
    };
  }

  /*JSON to Ship State*/
  factory SpaceShipState.fromJson(Map<String, dynamic> json){
    // print(json);
    return SpaceShipState(
      isOwned: json['isOwned'],
      isEquipped: json['isEquipped'],
      isCarryingCargo: json['isCarryingCargo'] ?? false,
      currentMission: (json['currentMission'] != null) ?
          MissionData.fromJson(json['currentMission']) : null,
      dockedAt: json['dockedAt'] ?? "",
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