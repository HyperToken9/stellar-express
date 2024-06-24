
import 'dart:math';

import 'package:flame/components.dart';

import 'package:star_routes/components/ship.dart';

import 'package:star_routes/data/planet_data.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/space_ship_state.dart';
import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/data/world_data.dart';
import 'package:star_routes/game/config.dart';

class PlayerData{

  String playerId = "";

  int coin = 0;

  int totalExperience = 165;

  /*TODO: Should be removed */
  // String equippedShip  = "";

  Vector2 shipSpawnLocation = Vector2(3766.0, -2102.0) + Vector2(0, 300);

  Map<String, SpaceShipState> spaceShipStates = {};

  List<MissionData> archivedMissions = [];

  List<MissionData> completedMissions = [];

  List<MissionData> initiatedMissions = [];

  List<MissionData> acceptedMissions = [];

  List<MissionData> availableMissions = [];

  static const List<int> missionSlotUnlockLevels = [5, 20, 50, 100];

  PlayerData(){

    for (SpaceShipData shipData in SpaceShipData.spaceShips){
      if (!spaceShipStates.containsKey(shipData.shipClassName)){
        // print("Loading Additionaonals: ${shipData.shipClassName}");
        spaceShipStates[shipData.shipClassName] = SpaceShipState(isOwned: false, isEquipped: false);
      }
    }

  }


  void loadPlayerData(String playerId){
    /* Assign Player ID */
    this.playerId = playerId;


    /* Load Player Data from Firebase */

    // dataStore.loadDataFromFireBase(this);
    // print("Loading Player Data");


    /* Initializes Mission States*/
    while (availableMissions.length < getMissionSlotsAvailable()+ 10){
      MissionData? mission = MissionData.sampleMissionByDifficulty(this, Random().nextDouble());

      if (mission != null){
        availableMissions.add(mission);
        // print("Adding Mission");
      }
      // print("Dinf addmisison");

    }
    // dataStore.saveDataLocally();
    // setEquippedShip();

  }

  /* Getter function for equipped ship */
  String get equippedShip{
    for (SpaceShipData data in SpaceShipData.spaceShips){
      SpaceShipState shipState = spaceShipStates[data.shipClassName]!;

      if (shipState.isEquipped){
        return data.shipClassName;
      }
    }
    // assert(false, "No Equipped Ship Found");
    return "";
  }

  // void setEquippedShip(){
  //   // print("Setting Equipped Ship");
  //   for (SpaceShipData data in SpaceShipData.spaceShips){
  //     SpaceShipState shipState = spaceShipStates[data.shipClassName]!;
  //
  //     if (!shipState.isOwned)
  //     {
  //       continue;
  //     }
  //     if (shipState.isEquipped){
  //       equippedShip = data.shipClassName;
  //       return;
  //     }
  //   }
  // }

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

  static int expRequired(int level) {

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

  int getMissionSlotsAvailable(){
    int level = getPlayerLevel();
    int slots = 1;

    for (int i in missionSlotUnlockLevels){
      if (level >= i){
        slots++;
      }else{
        break;
      }
    }
    return slots;
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

  bool sellShip(SpaceShipData shipData, void Function(String) displayMessage)
  {
    SpaceShipState shipState = spaceShipStates[shipData.shipClassName]!;

    if (shipState.isCarryingCargo){
      displayMessage("Denied:\nShip is on A Mission");
      return false;
    }

    /* Update ship state */
    shipState.isOwned = false;
    shipState.isEquipped = false;
    shipState.dockedAt = "";
    shipState.currentMission = null;

    /* Add amount to wallet */
    coin += shipData.baseSalvageValue;

    displayMessage("Ship Sold");
    return true;

  }

  bool buyShip(SpaceShipData shipData,
               void Function(String) displayMessage,
               Ship userShip)
  {
    SpaceShipState shipState = spaceShipStates[shipData.shipClassName]!;
    if (coin < shipData.baseCostValue){
      displayMessage("Insufficient Funds");
      return false;
    }

    /* Update ship state */
    shipState.isOwned = true;
    shipState.isCarryingCargo = false;
    shipState.isEquipped = false;
    List<String> possibleDockedPlanets = WorldData.portablePlanets;

    /* Iterate through each owned ship */
    for (SpaceShipState state in spaceShipStates.values){

      if (!state.isOwned || state.dockedAt == ""){
        continue;
      }
      // print("Removing ${state.dockedAt} from possible docked planets");
      possibleDockedPlanets.remove(state.dockedAt);
    }

    /* Does the player have an equipped ship */
    String equippedShip = this.equippedShip;


    /*Pick a random planet from possibleDockedPlanets */
    Random random = Random();
    shipState.dockedAt = possibleDockedPlanets[random.nextInt(possibleDockedPlanets.length)];

    shipState.currentMission = null;

    if (equippedShip == ""){
      // possibleDockedPlanets.remove(spaceShipStates[equippedShip]!.dockedAt);
      print("No Equipped Ship");
      PlanetData planetData = WorldData.planets.where((element) => element.planetName == shipState.dockedAt).first;
      userShip.position = planetData.location * Config.spaceScaleFactor;
      Vector2 offsetPosition = Vector2.random(random).normalized() * planetData.radius * Config.radiusScaleFactor;
      userShip.position += offsetPosition;


      shipState.isEquipped = true;
      shipState.dockedAt = "";
      print("Ship Spawn: $shipSpawnLocation");
      displayMessage("Ship Purchased\n Parked at ${planetData.planetName}");
      return true;
    }

    /* Deduct amount from wallet */
    coin -= shipData.baseCostValue;

    displayMessage("Ship Purchased\nDocked at ${shipState.dockedAt}");

    return true;
  }


}


