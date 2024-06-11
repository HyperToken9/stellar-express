
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

  final double baseCostValue;
  final double baseSalvageValue;

  /* Cargo Stats*/
  final Set<String> cargoCapacities;
  final Set<CargoTypes> cargoTypes;

  final String spriteName;
  final List<int> spriteSize;

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
      displayManeuverability: 2,
      baseCostValue: 3000,
      baseSalvageValue: 1500,
      cargoCapacities: {"Small"},
      cargoTypes: {CargoTypes.parcels, CargoTypes.specialCargo, CargoTypes.timeSensitive},
      spriteName: "small_courier",
      spriteSize: [249, 429],
    ),
    SpaceShipData(
      shipClassName: "Express Shuttle",
      shipClassNameShorthand: "ES",
      displayCapacity: 2,
      displaySpeed: 4,
      displayManeuverability: 4,
      baseCostValue: 10000,
      baseSalvageValue: 4500,
      cargoCapacities: {"Small", "Medium"},
      cargoTypes: {CargoTypes.parcels, CargoTypes.highValue, CargoTypes.timeSensitive},
      spriteName: "express_shuttle",
      spriteSize: [459, 543],
    ),
    SpaceShipData(
      shipClassName: "Heavy Hauler",
      shipClassNameShorthand: "HH",
      displayCapacity: 4,
      displaySpeed: 2,
      displayManeuverability: 1,
      baseCostValue: 20000,
      baseSalvageValue: 10000,
      cargoCapacities: {"Large", "Very Large"},
      cargoTypes: {CargoTypes.bulkGoods, CargoTypes.parcels},
      spriteName: "heavy_hauler",
      spriteSize: [1606, 1898],
    ),
    SpaceShipData(
      shipClassName: "Large Freighter",
      shipClassNameShorthand: "LF",
      displayCapacity: 4,
      displaySpeed: 2,
      displayManeuverability: 1,
      baseCostValue: 20000,
      baseSalvageValue: 10000,
      cargoCapacities: {"Large"},
      cargoTypes: {CargoTypes.bulkGoods, CargoTypes.parcels},
      spriteName: "large_freighter",
      spriteSize: [639, 1000],
    ),
    SpaceShipData(
      shipClassName: "Endurance Cruiser",
      shipClassNameShorthand: "EC",
      displayCapacity: 4,
      displaySpeed: 2,
      displayManeuverability: 1,
      baseCostValue: 20000,
      baseSalvageValue: 10000,
      cargoCapacities: {"Medium", "Large"},
      cargoTypes: {CargoTypes.bulkGoods, CargoTypes.parcels, CargoTypes.specialCargo},
      spriteName: "endurance_cruiser",
      spriteSize: [515, 473],
    ),
    SpaceShipData(
      shipClassName: "Specialized Vessel",
      shipClassNameShorthand: "SV",
      displayCapacity: 4,
      displaySpeed: 2,
      displayManeuverability: 1,
      baseCostValue: 20000,
      baseSalvageValue: 10000,
      cargoCapacities: {"Small", "Medium"},
      cargoTypes: {CargoTypes.specialCargo},
      spriteName: "specialized_vessel",
      spriteSize: [359, 700],
    ),
    SpaceShipData(
      shipClassName: "Stealth Courier",
      shipClassNameShorthand: "STC",
      displayCapacity: 4,
      displaySpeed: 2,
      displayManeuverability: 1,
      baseCostValue: 20000,
      baseSalvageValue: 10000,
      cargoCapacities: {"Small", "Medium"},
      cargoTypes: {CargoTypes.parcels, CargoTypes.timeSensitive},
      spriteName: "stealth_courier",
      spriteSize: [694, 359],
    ),


  ];


}