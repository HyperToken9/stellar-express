
import 'package:star_routes/data/cargo_types.dart';

class Item {
  final String name;
  final List<String> importingPlanets;
  final List<String> exportingPlanets;

  const Item({
    required this.name,
    required this.importingPlanets,
    required this.exportingPlanets,
  });

  @override
  String toString() {
    return "Item($name)";
  }
}

class ItemCategory {
  final String name;
  final Set<CargoTypes> types;
  final List<Item> items;

  const ItemCategory(this.name, this.types, this.items);

  @override
  String toString() {
    return 'ItemCategory($name)';
  }
}

class CargoItems{

  // Define the items and categories
  static const List<Item> energyItems = [
    Item(name: "Raw Energy", importingPlanets: ["Zeloris", "Targalon", "Ratha", "Dracona", "Marid"], exportingPlanets: ["Pyros"]),
    Item(name: "Gas", importingPlanets: ["Zeloris", "Icarion", "Dracona", "Marid"], exportingPlanets: ["Zephyros", "Chronus"]),
    Item(name: "Cell", importingPlanets: ["Icarion", "Targalon", "Noridia", "Ratha"], exportingPlanets: ["Cryon", "Elysara", "Pyros"])
  ];

  static const List<Item> wastesItems = [
    Item(name: "Industry Wastes", importingPlanets: ["Elysara"], exportingPlanets: ["Zeloris", "Noridia", "Cryon"]),
    Item(name: "Salvaged Parts", importingPlanets: ["Zeloris", "Elysara", "Dracona"], exportingPlanets: ["Pyros", "Ratha", "Zephyros"]),
    Item(name: "Raw Wastes", importingPlanets: ["Elysara"], exportingPlanets: ["Icarion", "Ratha", "Dracona"])
  ];

  static const List<Item> rawMaterialsItems = [
    Item(name: "Rare Elements", importingPlanets: ["Cryon", "Elysara", "Marid"], exportingPlanets: ["Zeloris", "Targalon", "Noridia", "Pyros", "Ratha"]),
    Item(name: "Minerals", importingPlanets: ["Cryon", "Elysara", "Ratha"], exportingPlanets: ["Zeloris", "Targalon", "Noridia", "Pyros"]),
    Item(name: "Crops & Produce", importingPlanets: ["Cryon", "Pyros", "Dracona", "Marid", "Zephyros"], exportingPlanets: ["Zeloris", "Elysara", "Ratha"]),
    Item(name: "Ores", importingPlanets: ["Cryon", "Elysara", "Pyros"], exportingPlanets: ["Zeloris", "Targalon", "Noridia", "Dracona", "Marid"]),
    Item(name: "Gases (Breathing kind)", importingPlanets: ["Noridia", "Pyros", "Dracona", "Marid"], exportingPlanets: ["Elysara", "Zephyros", "Chronus"])
  ];

  static const List<Item> refinedGoodsItems = [
    Item(name: "Metals", importingPlanets: ["Zeloris", "Cryon", "Ratha", "Dracona", "Marid", "Zephyros"], exportingPlanets: ["Cryon", "Elysara", "Pyros"]),
    Item(name: "Clothes", importingPlanets: ["Zeloris", "Icarion", "Cryon", "Pyros", "Dracona"], exportingPlanets: ["Targalon", "Cryon", "Elysara", "Ratha", "Dracona", "Marid"]),
    Item(name: "Food", importingPlanets: ["Zeloris", "Icarion", "Targalon", "Pyros", "Dracona", "Marid", "Zephyros", "Chronus"], exportingPlanets: ["Icarion", "Targalon", "Elysara", "Ratha"]),
    Item(name: "Pharmaceuticals", importingPlanets: ["Zeloris", "Icarion", "Pyros", "Dracona", "Zephyros", "Chronus"], exportingPlanets: ["Icarion", "Targalon", "Cryon", "Elysara", "Ratha", "Marid"]),
    Item(name: "Luxury Goods", importingPlanets: ["Cryon", "Elysara"], exportingPlanets: ["Icarion", "Targalon", "Elysara", "Ratha", "Marid"])
  ];

  static const List<Item> equipmentItems = [
    Item(name: "Mining", importingPlanets: ["Zeloris", "Targalon", "Noridia", "Pyros", "Chronus"], exportingPlanets: ["Zeloris", "Cryon", "Elysara"]),
    Item(name: "Research", importingPlanets: ["Zeloris", "Icarion", "Noridia", "Dracona"], exportingPlanets: ["Cryon", "Elysara", "Marid", "Zephyros"]),
    Item(name: "Medical", importingPlanets: ["Zeloris", "Icarion", "Targalon", "Noridia", "Pyros", "Ratha", "Dracona"], exportingPlanets: ["Cryon", "Elysara", "Marid", "Zephyros"]),
    Item(name: "Navigation", importingPlanets: ["Icarion", "Targalon", "Noridia", "Cryon", "Chronus"], exportingPlanets: ["Elysara", "Pyros", "Ratha", "Dracona", "Zephyros"]),
    Item(name: "Communication Devices", importingPlanets: ["Icarion", "Targalon", "Noridia", "Elysara", "Chronus"], exportingPlanets: ["Cryon", "Pyros", "Ratha", "Dracona", "Zephyros"])
  ];

  static const List<Item> warItems = [
    Item(name: "Food Rations", importingPlanets: ["Icarion", "Cryon", "Pyros", "Dracona"], exportingPlanets: ["Elysara", "Ratha"]),
    Item(name: "Weapons", importingPlanets: ["Zeloris", "Icarion", "Targalon", "Elysara", "Ratha", "Chronus"], exportingPlanets: ["Cryon", "Pyros", "Dracona", "Zephyros"]),
    Item(name: "Soldiers", importingPlanets: ["Icarion", "Cryon", "Ratha", "Zephyros"], exportingPlanets: ["Zeloris", "Elysara", "Dracona"]),
    Item(name: "Equipment", importingPlanets: ["Zeloris", "Targalon", "Elysara", "Chronus"], exportingPlanets: ["Cryon", "Pyros", "Dracona"])
  ];

  static const List<Item> researchItems = [
    Item(name: "Environmental Data", importingPlanets: ["Zeloris", "Cryon", "Elysara", "Marid", "Zephyros"], exportingPlanets: ["Icarion", "Noridia", "Cryon", "Elysara", "Pyros", "Ratha", "Zephyros", "Chronus"]),
    Item(name: "Military Data", importingPlanets: ["Cryon", "Elysara", "Zephyros"], exportingPlanets: ["Icarion", "Pyros", "Dracona"]),
    Item(name: "Energy Data", importingPlanets: ["Cryon", "Elysara", "Dracona", "Marid", "Zephyros"], exportingPlanets: ["Icarion", "Noridia", "Pyros", "Zephyros", "Chronus"]),
    Item(name: "Industry Data", importingPlanets: ["Zeloris", "Targalon", "Cryon", "Elysara", "Pyros", "Marid", "Zephyros"], exportingPlanets: ["Zeloris", "Cryon", "Elysara", "Chronus"])
  ];

// Define the categories
  static const List<ItemCategory> itemCategories = [
    ItemCategory("Energy", {CargoTypes.bulkGoods, CargoTypes.specialCargo}, energyItems),
    ItemCategory("Wastes", {CargoTypes.bulkGoods}, wastesItems),
    ItemCategory("Raw Materials", {CargoTypes.bulkGoods, CargoTypes.parcels}, rawMaterialsItems),
    ItemCategory("Refined Goods", {CargoTypes.parcels, CargoTypes.bulkGoods}, refinedGoodsItems),
    ItemCategory("Equipment", {CargoTypes.bulkGoods, CargoTypes.highValue}, equipmentItems),
    ItemCategory("War", {CargoTypes.specialCargo, CargoTypes.highValue, CargoTypes.timeSensitive}, warItems),
    ItemCategory("Research", {CargoTypes.parcels, CargoTypes.specialCargo}, researchItems),
    ItemCategory("Package", {CargoTypes.parcels, CargoTypes.specialCargo, CargoTypes.timeSensitive},
        [ Item(
            name: "Packages",
            importingPlanets: ['Zeloris', 'Icarion', 'Targalon', 'Noridia', 'Cryon', 'Elysara', 'Pyros', 'Ratha', 'Dracona', 'Marid', 'Zephyros', 'Chronus'],
            exportingPlanets: ['Zeloris', 'Icarion', 'Targalon', 'Noridia', 'Cryon', 'Elysara', 'Pyros', 'Ratha', 'Dracona', 'Marid', 'Zephyros', 'Chronus'])
        ])
  ];

}


