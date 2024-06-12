
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:star_routes/data/planet_data.dart';

import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/space_ship_state.dart';
import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/services/datastore.dart';

class PlayerData{

  String playerId = "";

  int coin = 0;

  int totalExperience = 165;

  String equippedShip  = "Small Courier";

  Vector2 shipSpawnLocation = Vector2(1291.0, 2261.0) + Vector2(0, 300);

  Map<String, SpaceShipState> spaceShipStates = {};

  List<MissionData> archivedMissions = [];

  List<MissionData> completedMissions = [];

  List<MissionData> initiatedMissions = [];

  List<MissionData> acceptedMissions = [];

  List<MissionData> availableMissions = [];


  PlayerData(){

    /* Initializes Ship States */
    for (SpaceShipData data in SpaceShipData.spaceShips){
      if (data.shipClassName == "Small Courier"){
        spaceShipStates[data.shipClassName] = SpaceShipState(isOwned: true,
                                                            isEquipped: true,
                                                            dockedAt: "");
      }else if(data.shipClassName == "Express Shuttle"){
        spaceShipStates[data.shipClassName] = SpaceShipState(isOwned: true,
                                                              isEquipped: false,
                                                              dockedAt: "Ratha");
      }else{
        spaceShipStates[data.shipClassName] = SpaceShipState(isOwned: false, isEquipped: false, dockedAt: "");
      }
      // print(spaceShipStates[data.shipClassName]?.toJson());
    }

    /* Initializes Mission States*/
    for (int i = 0; i < 7; i++) {
      availableMissions.add(MissionData.makeMission(this));
    }

    setEquippedShip();

  }

  void loadPlayerData(String playerId){
    /* Assign Player ID */
    this.playerId = playerId;

    /* Load Player Data from Firebase */
    Datastore dataStore = Datastore();
    dataStore.loadPlayerData(this);
    // print("Loading Player Data");


  }

  void setEquippedShip(){
    for (SpaceShipData data in SpaceShipData.spaceShips){
      if (spaceShipStates[data.shipClassName]!.isEquipped){
        equippedShip = data.shipClassName;
      }
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

    // print("XP: $xp, XP Required: $xpRequired");
    return xp/ xpRequired;
  }


}


