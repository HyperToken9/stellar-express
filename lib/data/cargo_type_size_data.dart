import 'package:star_routes/data/cargo_types.dart';

class CargoTypeSizeData implements Comparable<CargoTypeSizeData> {
  final String cargoSize;
  final CargoTypes cargoType;

  const CargoTypeSizeData({
    required this.cargoSize,
    required this.cargoType,
  });

  Map<String, dynamic> toJson() {
    return {
      'cargoSize': cargoSize,
      'cargoType': cargoTypeToString(cargoType),
    };
  }

  // Create a CargoTypeSizeData object from JSON
  factory CargoTypeSizeData.fromJson(Map<String, dynamic> json) {
    return CargoTypeSizeData(
      cargoSize: json['cargoSize'],
      cargoType: stringToCargoType(json['cargoType']),
    );
  }


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