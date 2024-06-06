
import 'dart:math';

import 'package:star_routes/data/world_data.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/player_data.dart';
import 'package:star_routes/data/cargo_items.dart';
import 'package:star_routes/data/cargo_type_size_data.dart';

enum MissionStatus{
  pending,
  inProgress,
  completed,
  failed,
}

class MissionData{

  int missionId;

  String sourcePlanet;
  String destinationPlanet;

  List<String> eligibleShips;

  CargoTypeSizeData cargoTypeSizeData;
  String cargoCategoryName;
  String cargoItemName;

  int reward;

  MissionData({
    required this.missionId,
    required this.sourcePlanet,
    required this.destinationPlanet,
    required this.eligibleShips,

    /* Cargo Info */
    required this.cargoTypeSizeData,
    required this.cargoCategoryName,
    required this.cargoItemName,

    required this.reward,
  });

  static MissionData makeMission(PlayerData playerData){

    Set<CargoTypeSizeData> validCargoTypes = {};
    for (SpaceShipData spaceShipData in SpaceShipData.spaceShips){

      if (!playerData.isShipOwned(spaceShipData.shipClassName)){
        continue;
      }

      for (CargoTypeSizeData validCargo in spaceShipData.eligibleCargo()){
        validCargoTypes.add(validCargo);
      }
    }

    // print("Valid Cargo Types: $validCargoTypes");
    Random random = Random();
    int randomIndex = random.nextInt(validCargoTypes.length);

    CargoTypeSizeData cargoTypeAndSize = validCargoTypes.toList()[randomIndex];
    // print("Cargo Type and Size: $cargoTypeAndSize");

    List validCategoryPool = [];
    for (ItemCategory itemCategory in CargoItems.itemCategories)
    {
      if (itemCategory.types.contains(cargoTypeAndSize.cargoType)){
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
    for (SpaceShipData spaceShipData in SpaceShipData.spaceShips){

      if (!spaceShipData.cargoTypes.contains(cargoTypeAndSize.cargoType)){
        continue;
      }

      if (!spaceShipData.cargoCapacities.contains(cargoTypeAndSize.cargoSize)){
        continue;
      }
      eligibleShips.add(spaceShipData.shipClassName);

    }


    return MissionData(
      missionId: random.nextInt(9999999), // TODO: Make sure there is no collision
      sourcePlanet: sourcePlanet,
      destinationPlanet: destinationPlanet,
      eligibleShips: eligibleShips,
      cargoTypeSizeData: cargoTypeAndSize,
      cargoCategoryName: selectedItemCategory.name,
      cargoItemName: selectedItem.name,
      reward: 1000,
    );

  }

  String formattedEligibleShips(){

    String result = "";
    for (SpaceShipData spaceShipData in SpaceShipData.spaceShips){
      if (eligibleShips.contains(spaceShipData.shipClassName)){
        result += "${spaceShipData.shipClassNameShorthand} ";
      }
    }
    return result;
  }

  String formattedCargoDetails()
  {
    if (cargoTypeSizeData.cargoSize == "Medium"){
      return "A Shipment of $cargoItemName";
    }
    return "A ${cargoTypeSizeData.cargoSize} Shipment of $cargoItemName";
  }


  @override
  String toString() {
    return
"""MissionData
($sourcePlanet -> $destinationPlanet)
Eligible Ships: $eligibleShips
Cargo Category: $cargoCategoryName
Cargo Item: $cargoItemName
Cargo Type: $cargoTypeSizeData
Reward: $reward
""";
  }

}
