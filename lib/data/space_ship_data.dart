

import 'package:flame/components.dart';

class SpaceShipData{

  String shipClassName;
  int displayCapacity;
  int displaySpeed;
  int displayManeuverability;

  double costValue;
  double salvageValue;

  bool isOwned;
  bool isEquipped;
  bool isDamaged;
  String dockedPlanet;
  Vector2 location;

  String spriteName;


  SpaceShipData({
    required this.shipClassName,
    required this.displayCapacity,
    required this.displaySpeed,
    required this.displayManeuverability,
    required this.costValue,
    required this.salvageValue,
    required this.isOwned,
    required this.isEquipped,
    required this.isDamaged,
    required this.dockedPlanet,
    required this.location,
    required this.spriteName,
  });
}