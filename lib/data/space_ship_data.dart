
import 'dart:math';

import 'package:flame/components.dart';
import 'package:star_routes/data/cargo_types.dart';
import 'package:star_routes/data/cargo_type_size_data.dart';

class SpaceShipData{

  final String shipClassName;
  final String shipClassNameShorthand;
  final int displayCapacity;
  final int displaySpeed;
  final int displayManeuverability;
  final int unlockLevel;

  final double maxVelocity;
  final double maxAngularVelocity;
  final double linearAcceleration;
  final double angularAcceleration;

  final int baseCostValue;
  final int baseSalvageValue;

  /* Cargo Stats*/
  final Set<String> cargoCapacities;
  final Set<CargoTypes> cargoTypes;

  final String spriteName;
  final List<int> spriteSize;
  final double zoomPercentage;

  const SpaceShipData({
    required this.shipClassName,
    required this.shipClassNameShorthand,
    required this.displayCapacity,
    required this.displaySpeed,
    required this.displayManeuverability,
    required this.baseCostValue,
    required this.baseSalvageValue,
    required this.spriteName,
    required this.cargoCapacities,
    required this.cargoTypes,
    required this.spriteSize,
    required this.unlockLevel,
    this.maxVelocity = 1000,
    this.maxAngularVelocity = 8,
    this.zoomPercentage = 30,  //20.0,
    this.linearAcceleration = 2,
    this.angularAcceleration = 0.01,
  });


  List<CargoTypeSizeData> eligibleCargo(){

    List<CargoTypeSizeData> result = [];
    Random random = Random();
    for (CargoTypes cargoType in cargoTypes){
      for (String cargoSize in cargoCapacities){

        if (random.nextDouble() > 1){
          continue;
        }
        result.add(CargoTypeSizeData(cargoSize: cargoSize, cargoType: cargoType));
      }
    }
    return result;
  }

  /* Space Ship Data */
  static const List<SpaceShipData> spaceShips = [
    SpaceShipData(
      shipClassName: "Small Courier",
      shipClassNameShorthand: "SC",
      displayCapacity: 1,
      displaySpeed: 3,
      displayManeuverability: 3,
      baseCostValue: 3000,
      baseSalvageValue: 999500,
      cargoCapacities: {"Small"},
      cargoTypes: {CargoTypes.parcels, CargoTypes.specialCargo, CargoTypes.timeSensitive},
      spriteName: "small_courier",
      spriteSize: [294, 429],
      unlockLevel: 1,
      maxVelocity: 250,
      linearAcceleration: 1.5,
      maxAngularVelocity: 7,
      angularAcceleration: 0.002,
      // zoomPercentage: 70.0,
    ),
    SpaceShipData(
      shipClassName: "Express Shuttle",
      shipClassNameShorthand: "ES",
      displayCapacity: 2,
      displaySpeed: 4,
      displayManeuverability: 4,
      baseCostValue: 7000,
      baseSalvageValue: 3500,
      cargoCapacities: {"Small", "Medium"},
      cargoTypes: {CargoTypes.parcels, CargoTypes.highValue, CargoTypes.timeSensitive},
      spriteName: "express_shuttle",
      spriteSize: [459, 543],
      unlockLevel: 5,
      maxVelocity: 450,
      linearAcceleration: 4.0,
      maxAngularVelocity: 10,
      angularAcceleration: 0.007,
      // zoomPercentage: 70.0,
    ),
    SpaceShipData(
      shipClassName: "Endurance Cruiser",
      shipClassNameShorthand: "EC",
      displayCapacity: 3,
      displaySpeed: 2,
      displayManeuverability: 3,
      baseCostValue: 15000,
      baseSalvageValue: 7500,
      cargoCapacities: {"Medium", "Large"},
      cargoTypes: {CargoTypes.bulkGoods, CargoTypes.parcels, CargoTypes.specialCargo},
      spriteName: "endurance_cruiser",
      spriteSize: [695, 681],
      unlockLevel: 10, // Suggest level 10
    ),
    SpaceShipData(
      shipClassName: "Large Freighter",
      shipClassNameShorthand: "LF",
      displayCapacity: 4,
      displaySpeed: 2,
      displayManeuverability: 2,
      baseCostValue: 20000,
      baseSalvageValue: 10000,
      cargoCapacities: {"Large"},
      cargoTypes: {CargoTypes.bulkGoods, CargoTypes.parcels},
      spriteName: "large_freighter",
      spriteSize: [639, 1000],
      unlockLevel: 15, // Suggest level 15
    ),
    SpaceShipData(
      shipClassName: "Stealth Courier",
      shipClassNameShorthand: "STC",
      displayCapacity: 2,
      displaySpeed: 5,
      displayManeuverability: 4,
      baseCostValue: 25000,
      baseSalvageValue: 12500,
      cargoCapacities: {"Small", "Medium"},
      cargoTypes: {CargoTypes.parcels, CargoTypes.timeSensitive},
      spriteName: "stealth_courier",
      spriteSize: [694, 359],
      unlockLevel: 20, // Suggest level 20
    ),
    SpaceShipData(
      shipClassName: "Specialized Vessel",
      shipClassNameShorthand: "SV",
      displayCapacity: 3,
      displaySpeed: 3,
      displayManeuverability: 3,
      baseCostValue: 35000,
      baseSalvageValue: 15000,
      cargoCapacities: {"Small", "Medium"},
      cargoTypes: {CargoTypes.specialCargo},
      spriteName: "specialized_vessel",
      spriteSize: [359, 700],
      unlockLevel: 25, // Suggest level 25
    ),
    SpaceShipData(
      shipClassName: "Heavy Hauler",
      shipClassNameShorthand: "HH",
      displayCapacity: 5,
      displaySpeed: 1,
      displayManeuverability: 1,
      baseCostValue: 50000,
      baseSalvageValue: 20000,
      cargoCapacities: {"Large", "Very Large"},
      cargoTypes: {CargoTypes.bulkGoods, CargoTypes.parcels},
      spriteName: "heavy_hauler",
      spriteSize: [1606, 1898],
      unlockLevel: 30, // Suggest level 30
      // maxAngularVelocity:
    ),

  ];


}