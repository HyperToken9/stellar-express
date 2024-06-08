

enum CargoTypes{
  parcels,
  bulkGoods,
  specialCargo,
  timeSensitive,
  highValue,

}

String cargoTypeToString(CargoTypes cargoType) {
  return cargoType.toString().split('.').last;
}

CargoTypes stringToCargoType(String cargoTypeString) {
  return CargoTypes.values.firstWhere((e) => e.toString().split('.').last == cargoTypeString);
}