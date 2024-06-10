

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:star_routes/data/cargo_types.dart';
import 'package:star_routes/data/mission_data.dart';

import 'package:star_routes/data/player_data.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/cargo_type_size_data.dart';
import 'package:star_routes/game/star_routes.dart';


class Datastore {



  final CollectionReference playerCollection = FirebaseFirestore.instance.collection('players');

  final Map<String, dynamic> defaultPlayerData = {
    'coin': 100,
    'totalExperience': 0,
    'shipSpawnLocation': [0, 0],
    'equippedShip': 'Small Courier',
    'spaceShipStates': {
      'Small Courier': {'isOwned': true, 'isCarryingCargo': false},
      'Express Shuttle': {'isOwned': false, 'isCarryingCargo': false},
      'Heavy Hauler': {'isOwned': false, 'isCarryingCargo': false},
      'Large Freighter': {'isOwned': false, 'isCarryingCargo': false},
      'Long Range Transport': {'isOwned': false, 'isCarryingCargo': false},
      'Specialized Vessel': {'isOwned': false, 'isCarryingCargo': false},
      'Stealth Courier': {'isOwned': false, 'isCarryingCargo': false}
    },
    'archivedMissions': <MissionData>[],
    'completedMissions': <MissionData>[],
    'initiatedMissions': <MissionData>[],
    'acceptedMissions': <MissionData>[],
    // 'availableMissions': [],

  };

  Map<String, dynamic> playerDocument = {};

  Future<void> loadPlayerData(PlayerData playerDataObj) async {
    // await FirebaseFirestore.instance.disableNetwork();

    DocumentReference playerDoc = playerCollection.doc(playerDataObj.playerId);

    try {
      DocumentSnapshot docSnapshot = await playerDoc.get();

      if (docSnapshot.exists) {
        // print('Document Exists');
        // Document exists, retrieve the data
        Map<String, dynamic>? playerData = docSnapshot.data() as Map<String, dynamic>?;
        // Process the data as needed
        // print('Player data: $playerData');
        playerDocument = playerData!;
      } else {
        // Document does not exist, initialize some data
        playerDocument = defaultPlayerData;

        // Add other fields as needed
        await playerDoc.set(defaultPlayerData);

        // print('Initialized player data: $playerDocument');
      }
      playerDocumentToPlayerData(playerDataObj);
    } catch (e) {
      print('Error loading player data: $e');
    }
  }

  /* Proceess Player Document into the player data object */
  void playerDocumentToPlayerData(PlayerData playerData){
    playerData.coin = playerDocument['coin'].toInt();
    playerData.totalExperience = playerDocument['totalExperience'].toInt();
    playerData.shipSpawnLocation = Vector2(playerDocument['shipSpawnLocation'][0].toDouble(),
                                      playerDocument['shipSpawnLocation'][1].toDouble());
    playerData.equippedShip = playerDocument['equippedShip'];
    print(playerDocument['spaceShipStates']);
    playerData.spaceShipStates = (playerDocument['spaceShipStates'] ??
                                  defaultPlayerData['spaceShipStates'])
                                  .map<String, SpaceShipState>((String key, dynamic value) {
                                    return MapEntry(key, SpaceShipState.fromJson(value));
                                  });
    playerData.archivedMissions = (playerDocument['archivedMissions'] ??
                                      defaultPlayerData['archivedMissions'])
                                    .map<MissionData>((data) => MissionData.fromJson(data)).toList();
    playerData.completedMissions = (playerDocument['completedMissions'] ??
                                      defaultPlayerData['completedMissions'])
                                    .map<MissionData>((data) => MissionData.fromJson(data)).toList();
    playerData.initiatedMissions = (playerDocument['initiatedMissions'] ??
                                      defaultPlayerData['initiatedMissions'])
                                    .map<MissionData>((data) => MissionData.fromJson(data)).toList();
    playerData.acceptedMissions = (playerDocument['acceptedMissions'] ??
                                      defaultPlayerData['acceptedMissions'])
                                  .map<MissionData>((data) => MissionData.fromJson(data)).toList();

    // MissionData sampleToRemove = MissionData(missionId: 6139686,
    //     sourcePlanet: "Pyros",
    //     destinationPlanet: "Cryon",
    //     eligibleShips: ["Small Courier", "Specialized Vessel"],
    //     cargoTypeSizeData: CargoTypeSizeData(cargoType: CargoTypes.specialCargo, cargoSize: "Small"),
    //     cargoCategoryName: "Research",
    //     cargoItemName: "Military Data",
    //     reward: 1000);
    // print("Initiated Missions: ${playerData.initiatedMissions}");
    // playerData.initiatedMissions.remove(sampleToRemove);
    // print("Initiated Missions: ${playerData.initiatedMissions}");
  }


  void playerDataToPlayerDocument(StarRoutes game){

    PlayerData playerData = game.playerData;

    playerDocument['coin'] = playerData.coin;
    playerDocument['totalExperience'] = playerData.totalExperience;
    playerDocument['shipSpawnLocation'] = [game.userShip.position.x,
                                           game.userShip.position.y];
    playerDocument['equippedShip'] = playerData.equippedShip;
    playerDocument['spaceShipStates'] = playerData.spaceShipStates.map(
                                          (key, value) => MapEntry(key, value.toJson()));
    playerDocument['archivedMissions'] = playerData.archivedMissions.map(
                                          (mission) => mission.toJson()).toList();
    playerDocument['completedMissions'] = playerData.completedMissions.map(
                                          (mission) => mission.toJson()).toList();
    playerDocument['initiatedMissions'] = playerData.initiatedMissions.map(
                                          (mission) => mission.toJson()).toList();
    playerDocument['acceptedMissions'] = playerData.acceptedMissions.map(
                                          (mission) => mission.toJson()).toList();
    // playerDocument['availableMissions'] = playerData.availableMissions;
  }

  Future<void> savePlayerData(StarRoutes game) async {
    PlayerData playerData = game.playerData;
    DocumentReference playerDoc = playerCollection.doc(playerData.playerId);
    playerDataToPlayerDocument(game);

    // print("Saving Player Data $playerDocument");
    await playerDoc.set(playerDocument);
  }

}