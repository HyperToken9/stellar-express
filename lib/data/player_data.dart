
import 'package:flame/components.dart';
import 'package:star_routes/data/planet_data.dart';

import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/mission_data.dart';

class PlayerData{


  int coin = 324002;

  int totalExperience = 165;

  static const List<int> experiencePolynomialParameter = [];

  Vector2 shipLocation = Vector2(1291.0, 2261.0) + Vector2(0, 300);

  Map<String, SpaceShipState> spaceShipStates = {};

  List<MissionData> archivedMissions = [];

  List<MissionData> completedMissions = [];

  List<MissionData> initiatedMissions = [];

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

  String formattedCoin(){
    final numberString = coin.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < numberString.length; i++) {
      if (i > 0 && (numberString.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(numberString[i]);
    }

    return '$buffer'.toUpperCase();
  }

  int expRequired(int level) {

    double xp = 100;
    for (int i = 1; i < level; i++) {
      if (i % 2 != 0) {
        xp *= 1.3;
      } else {
        xp *= 1.2;
      }
    }

    int xpInt = xp.toInt();

    // Convert xpInt to string to manipulate the trailing digits
    String xpStr = xpInt.toString();
    int length = xpStr.length;

    // Calculate how many trailing digits should be zero
    int trailingZeros = (length / 2).floor();

    // Create the new xp with trailing zeros
    String newXpStr = xpStr.substring(0, length - trailingZeros) +
                      '0' * trailingZeros;

    // Convert back to integer
    int newXp = int.parse(newXpStr);

    return newXp;
  }

  int getPlayerLevel(){
    int level = 1;
    int xp = totalExperience;

    while (xp >= expRequired(level)){
      xp -= expRequired(level);
      level++;
    }

    return level;
  }

  double getExperienceLevelProgress(){
    double xp = totalExperience.toDouble();
    double xpRequired = expRequired(getPlayerLevel()).toDouble();
    int level = getPlayerLevel();

    for (int i = 1; i < level; i++) {
      xp -= expRequired(i);
    }

    print("XP: $xp, XP Required: $xpRequired");
    return xp/ xpRequired;
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