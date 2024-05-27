import 'package:star_routes/data/cargo_types.dart';

class CargoTypeSizeData implements Comparable<CargoTypeSizeData> {
  final String cargoSize;
  final CargoTypes cargoType;

  const CargoTypeSizeData({
    required this.cargoSize,
    required this.cargoType,
  });

  @override
  String toString() {
    return "CargoTypeSizeData($cargoType, $cargoSize)";
  }

  @override
  bool operator ==(Object other) {
    if (other is CargoTypeSizeData) {
      return other.cargoSize == cargoSize && other.cargoType == cargoType;
    }
    return false;
  }

  @override
  int get hashCode {
    return cargoSize.hashCode ^ cargoType.hashCode;
  }

  @override
  int compareTo(CargoTypeSizeData other) {
    if (cargoType == other.cargoType) {
      return cargoSize.compareTo(other.cargoSize);
    }
    return cargoType.toString().compareTo(other.cargoType.toString());
  }
}