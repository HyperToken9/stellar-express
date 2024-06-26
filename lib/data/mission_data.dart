
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:star_routes/data/cargo_types.dart';
import 'package:star_routes/data/planet_data.dart';
import 'package:star_routes/data/world_data.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/player_data.dart';
import 'package:star_routes/data/cargo_items.dart';
import 'package:star_routes/data/cargo_type_size_data.dart';

// enum MissionStatus{
//   pending,
//   inProgress,
//   completed,
//   failed,
// }

class MissionData{

  int missionId;

  String sourcePlanet;
  String destinationPlanet;

  List<String> eligibleShips;

  CargoTypeSizeData cargoTypeSizeData;
  String cargoCategoryName;
  String cargoItemName;

  double difficulty;
  int reward;
  int experiencePoints;

  MissionData({
    required this.missionId,
    required this.sourcePlanet,
    required this.destinationPlanet,
    required this.eligibleShips,

    /* Cargo Info */
    required this.cargoTypeSizeData,
    required this.cargoCategoryName,
    required this.cargoItemName,

    required this.difficulty,
    required this.reward,
    required this.experiencePoints,
  });

  static MissionData? makeMission(PlayerData playerData){

    Set<CargoTypeSizeData> validCargoTypes = {};
    try {
      for (SpaceShipData spaceShipData in SpaceShipData.spaceShips) {
        if (!playerData.isShipOwned(spaceShipData.shipClassName)) {
          continue;
        }

        for (CargoTypeSizeData validCargo in spaceShipData.eligibleCargo()) {
          validCargoTypes.add(validCargo);
        }
      }
      if (validCargoTypes.isEmpty) {
        return null;
      }

      // print("Valid Cargo Types: $validCargoTypes");
      Random random = Random();
      int randomIndex = random.nextInt(validCargoTypes.length);

      CargoTypeSizeData cargoTypeAndSize = validCargoTypes
          .toList()[randomIndex];
      // print("Cargo Type and Size: $cargoTypeAndSize");

      List validCategoryPool = [];
      for (ItemCategory itemCategory in CargoItems.itemCategories) {
        if (itemCategory.types.contains(cargoTypeAndSize.cargoType)) {
          validCategoryPool.add(itemCategory);
        }
      }

      /* Selecting Item Category */
      randomIndex = random.nextInt(validCategoryPool.length);
      ItemCategory selectedItemCategory = validCategoryPool[randomIndex];

      /* Selecting Item */
      randomIndex = random.nextInt(selectedItemCategory.items.length);
      Item selectedItem = selectedItemCategory.items[randomIndex];


      /* Selecting Source Planet */
      randomIndex = random.nextInt(selectedItem.exportingPlanets.length);
      String sourcePlanet = selectedItem.exportingPlanets[randomIndex];

      /* Selecting Destination Planet */
      final List<String> validDestinationPlanets =
      selectedItem.importingPlanets.where(
              (element) => element != sourcePlanet
      ).toList();
      randomIndex = random.nextInt(validDestinationPlanets.length);
      String destinationPlanet = validDestinationPlanets[randomIndex];


      List<String> eligibleShips = [];
      for (SpaceShipData spaceShipData in SpaceShipData.spaceShips) {
        if (!spaceShipData.cargoTypes.contains(cargoTypeAndSize.cargoType)) {
          continue;
        }

        if (!spaceShipData.cargoCapacities.contains(
            cargoTypeAndSize.cargoSize)) {
          continue;
        }
        eligibleShips.add(spaceShipData.shipClassName);
      }

      double hDifficulty = 0;
      /* Get Planet Data */
      PlanetData sourcePlanetData = WorldData.planets.singleWhere((element) => element.planetName == sourcePlanet);
      PlanetData destinationPlanetData = WorldData.planets.singleWhere((element) => element.planetName == destinationPlanet);

      /* Distance between the two planets */
      double distance = sourcePlanetData.location.distanceTo(destinationPlanetData.location);
      hDifficulty = distance / 100;


      return MissionData(
        missionId: random.nextInt(9999999), // TODO: Make sure there is no collision
        sourcePlanet: sourcePlanet,
        destinationPlanet: destinationPlanet,
        eligibleShips: eligibleShips,
        cargoTypeSizeData: cargoTypeAndSize,
        cargoCategoryName: selectedItemCategory.name,
        cargoItemName: selectedItem.name,
        difficulty: hDifficulty,
        reward: 1000,
        experiencePoints: 100,
      );


    }catch (e) {
      print("Mission Making Error: $e");
      return null;
    }


  }

  static MissionData? sampleMissionByDifficulty(PlayerData playerData, double difficulty)
  {

    /* Difficulty must be between 0 and 1 */
    assert(difficulty >= 0 && difficulty <= 1);

    int samples = 5000;
    List<MissionData> sampleMissions = [];

    for (int i = 0; i < samples; i++)
    {
      MissionData? missionData = makeMission(playerData);
      if (missionData == null){
        continue;
      }
      sampleMissions.add(missionData);
    }
    sampleMissions.sort((a, b) => a.difficulty.compareTo(b.difficulty));

    if (sampleMissions.isEmpty){
      return null;
    }
    print("Difficulty: $difficulty");
    int missionIndex = (max(difficulty * sampleMissions.length - 1, 0)).toInt();
    print("Mission Index: $missionIndex");
    // print("Number of Missions: ${sampleMissions.length}");
    // print("Mission Index: $missionIndex");
    MissionData selectedMission = sampleMissions[missionIndex];

    /* Assign Reward */
    int maxReward = 100 + ((2000 - 100) * difficulty).toInt();

    /* Penalties */
    double penaltyPercentage = 0;
    /* 1. No. of Ships Owned */
    int shipOwned = playerData.spaceShipStates.values.where((element) => element.isOwned).length;
    int totalShips = SpaceShipData.spaceShips.length;
    penaltyPercentage += (totalShips - shipOwned) * 14;

    /* 2. Eligible Ships */

    /* 3. Cargo Type */

    /* 4. Cargo Size */

    /* 5. Cargo Category */
    penaltyPercentage += (CargoItems.itemCategories.where((category)
                          => category.name == selectedMission.cargoCategoryName)
                            .toList()[0].categoryPenalty)* 2;
    /* 6. Salt */
    /*Between 0 and 2 percent */
    penaltyPercentage += Random().nextDouble() * 2;

    maxReward = (maxReward * (1 - penaltyPercentage / 100)).toInt();

    /* Clamp between 100 and 2000 */
    maxReward = max(maxReward, 100);
    maxReward = min(maxReward, 2000);

    /* Last digit must be 0 */
    maxReward = maxReward ~/ 10 * 10;

    int minExperiencePoints =  max(PlayerData.expRequired(playerData.getPlayerLevel()) * 0.02 ~/ 10 * 10, 1);
    int maxExperiencePoints = PlayerData.expRequired(playerData.getPlayerLevel()) * 0.1 ~/ 10 * 10;

    // print("Penalty Percentage: $penaltyPercentage");
    // print("Min exp: $minExperiencePoints");
    // print("Mex exp: $maxExperiencePoints");
    /* Given penalty percentage and min & max Exp determine the exp of the mission */
    int experiencePoints = minExperiencePoints + ((maxExperiencePoints - minExperiencePoints) * penaltyPercentage / 100).toInt();

    /* add a little noise to the exp */
    // experiencePoints += Random().nextInt(10) - 5;

    sampleMissions[missionIndex].experiencePoints = experiencePoints;
    sampleMissions[missionIndex].reward = maxReward;
    return selectedMission;

  }


  String formattedCargoDetails()
  {
    if (cargoTypeSizeData.cargoSize == "Medium"){
      return "A Shipment of $cargoItemName";
    }
    return "A ${cargoTypeSizeData.cargoSize} Shipment of $cargoItemName";
  }

  // Convert a MissionData object to JSON
  Map<String, dynamic> toJson() {
    return {
      'missionId': missionId,
      'sourcePlanet': sourcePlanet,
      'destinationPlanet': destinationPlanet,
      'eligibleShips': eligibleShips,
      'cargoTypeSizeData': cargoTypeSizeData.toJson(), // Assuming CargoTypeSizeData has a toJson() method
      'cargoCategoryName': cargoCategoryName,
      'cargoItemName': cargoItemName,
      'difficulty': difficulty,
      'reward': reward,
      'experiencePoints': experiencePoints,
    };
  }

  // Create a MissionData object from JSON
  factory MissionData.fromJson(Map<String, dynamic> json) {

    return MissionData(
      missionId: json['missionId'],
      sourcePlanet: json['sourcePlanet'],
      destinationPlanet: json['destinationPlanet'],
      eligibleShips: List<String>.from(json['eligibleShips']),
      cargoTypeSizeData: CargoTypeSizeData.fromJson(Map<String, dynamic>.from(json['cargoTypeSizeData'])),
      cargoCategoryName: json['cargoCategoryName'],
      cargoItemName: json['cargoItemName'],
      reward: json['reward'],
      difficulty: json['difficulty'],
      experiencePoints: json['experiencePoints'] ?? 20,
    );
  }

  String getDisplayItemName(){
    if (cargoCategoryName == "Research")
    {
      return "Research Data".toUpperCase();
    }
    return cargoItemName.toUpperCase();
  }
  String getDisplayCargoSize(){
    return cargoTypeSizeData.cargoSize.toUpperCase();
  }

  String getDisplayEligibleShips(){
    String result = "";
    for (SpaceShipData spaceShipData in SpaceShipData.spaceShips){
      if (eligibleShips.contains(spaceShipData.shipClassName)){
        result += "${spaceShipData.shipClassNameShorthand} ";
      }
    }
    return result;
  }
  String getDisplayBackgroundImagePath(){
    if (sourcePlanet == ""){
      return "assets/images/user_interface/mission_cards/locked_slot.png";
    }
    return "assets/images/user_interface/mission_cards/${cargoCategoryName.toLowerCase().replaceAll(' ', '_')}.png";
  }

  @override
  String toString() {
    return "MissionData(missionID: $missionId)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is MissionData) {
      return missionId == other.missionId &&
          sourcePlanet == other.sourcePlanet &&
          destinationPlanet == other.destinationPlanet &&
          eligibleShips.length == other.eligibleShips.length &&
          const ListEquality().equals(eligibleShips, other.eligibleShips) &&
          cargoTypeSizeData == other.cargoTypeSizeData &&
          cargoCategoryName == other.cargoCategoryName &&
          cargoItemName == other.cargoItemName &&
          reward == other.reward;
    }
    return false;
  }
  @override
  int get hashCode {
    return missionId.hashCode ^
    sourcePlanet.hashCode ^
    destinationPlanet.hashCode ^
    eligibleShips.hashCode ^
    cargoTypeSizeData.hashCode ^
    cargoCategoryName.hashCode ^
    cargoItemName.hashCode ^
    reward.hashCode;
  }


  /* Constructor for blank mission */
  MissionData.blank() : missionId = 0,
    sourcePlanet = "",
    destinationPlanet = "",
    eligibleShips = [],
    cargoTypeSizeData = const CargoTypeSizeData(
                                cargoType: CargoTypes.specialCargo,
                                cargoSize: "Small"),
    cargoCategoryName = "",
    cargoItemName = "",
    difficulty = 0,
    reward = 0,
    experiencePoints = 0;
}
