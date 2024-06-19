

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:hive/hive.dart';


import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/data/player_data.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/space_ship_state.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/config.dart';
import 'package:star_routes/main.dart';


class Datastore {



  final CollectionReference playerCollection = FirebaseFirestore.instance.collection('players');

  final Map<String, dynamic> defaultPlayerData = {
    'coin': 100,
    'totalExperience': 0,
    'shipSpawnLocation': [0, 0],
    'spaceShipStates': {
      'Small Courier': SpaceShipState(isOwned: true, isEquipped: true).toJson(),
      'Express Shuttle': SpaceShipState(isOwned: false, isEquipped: false).toJson(),
      'Heavy Hauler': SpaceShipState(isOwned: false, isEquipped: false).toJson(),
      'Large Freighter': SpaceShipState(isOwned: false, isEquipped: false).toJson(),
      'Endurance Cruiser': SpaceShipState(isOwned: false, isEquipped: false).toJson(),
      'Specialized Vessel': SpaceShipState(isOwned: false, isEquipped: false).toJson(),
      'Stealth Courier': SpaceShipState(isOwned: false, isEquipped: false).toJson(),
    },
    'archivedMissions': <MissionData>[],
    'completedMissions': <MissionData>[],
    'initiatedMissions': <MissionData>[],
    'acceptedMissions': <MissionData>[],
    // 'availableMissions': [],

  };

  final Map<String, dynamic> overrideCustomData = {
    'coin': 696969,
    // 'totalExperience': 0,
    // 'shipSpawnLocation': [2141.0* Config.spaceScaleFactor, 3863.0 * Config.spaceScaleFactor],
    // 'spaceShipStates': {
    //   'Small Courier': SpaceShipState(isOwned: true, isEquipped: true, dockedAt: "").toJson(),
    //   'Express Shuttle': SpaceShipState(isOwned: true, isEquipped: true, dockedAt: "").toJson(),
    //   'Large Freighter': SpaceShipState(isOwned: true, isEquipped: false, dockedAt: "Icarion").toJson(),
    //   'Endurance Cruiser': SpaceShipState(isOwned: false, isEquipped: true).toJson(),
    //   'Stealth Courier': SpaceShipState(isOwned: true, isEquipped: false, dockedAt: "Marid").toJson(),
    //   'Specialized Vessel': SpaceShipState(isOwned: true, isEquipped: false, dockedAt: "Ratha").toJson(),
    //   'Heavy Hauler': SpaceShipState(isOwned: true, isEquipped: false, dockedAt: "Pyros").toJson(),
    // },
    // 'availableMissions': [],
    // 'initiatedMissions': <MissionData>[],
    // 'acceptedMissions' : <MissionData>[],
  };


  Map<String, dynamic> playerDocument = {};

  Future<void> _loadDataFromFireBase(PlayerData playerDataObj) async {
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
      _playerDocumentToPlayerData(playerDataObj);
    } catch (e) {
      print('Error loading player data: $e');
    }
  }

  /* Proceess Player Document into the player data object */
  void _playerDocumentToPlayerData(PlayerData playerData){

    playerData.coin = playerDocument['coin'].toInt();
    playerData.totalExperience = playerDocument['totalExperience'].toInt();
    playerData.shipSpawnLocation = Vector2(playerDocument['shipSpawnLocation'][0].toDouble(),
                                      playerDocument['shipSpawnLocation'][1].toDouble());
    // print("Loading Ship Spawn Location: ${playerDocument['shipSpawnLocation']}");

    playerData.spaceShipStates = (playerDocument['spaceShipStates'] ?? defaultPlayerData['spaceShipStates'])
                                      .cast<String, dynamic>()
                                      .map<String, SpaceShipState>((String key, dynamic value) {
                                        print("Loading Ship State: $key");
                                    return MapEntry(key, SpaceShipState.fromJson(Map<String, dynamic>.from(value)));
                                  });

    for (SpaceShipData shipData in SpaceShipData.spaceShips){
      if (!playerData.spaceShipStates.containsKey(shipData.shipClassName)){
        // print("Loading Additionaonals: ${shipData.shipClassName}");
        playerData.spaceShipStates[shipData.shipClassName] = SpaceShipState(isOwned: false, isEquipped: false);
      }
    }

    playerData.archivedMissions = (playerDocument['archivedMissions'] ??
                                      defaultPlayerData['archivedMissions'])
                                    .map<MissionData>((data) => MissionData.fromJson(Map<String, dynamic>.from(data))).toList();
    playerData.completedMissions = (playerDocument['completedMissions'] ??
                                      defaultPlayerData['completedMissions'])
                                    .map<MissionData>((data) => MissionData.fromJson(Map<String, dynamic>.from(data))).toList();
    playerData.initiatedMissions = (playerDocument['initiatedMissions'] ??
                                      defaultPlayerData['initiatedMissions'])
                                    .map<MissionData>((data) => MissionData.fromJson(Map<String, dynamic>.from(data))).toList();
    playerData.acceptedMissions = (playerDocument['acceptedMissions'] ??
                                      defaultPlayerData['acceptedMissions'])
                                  .map<MissionData>((data) => MissionData.fromJson(Map<String, dynamic>.from(data))).toList();

  }


  void _playerDataToPlayerDocument(StarRoutes game){

    PlayerData playerData = game.playerData;

    playerDocument['coin'] = playerData.coin;
    playerDocument['totalExperience'] = playerData.totalExperience;
    playerDocument['shipSpawnLocation'] = [game.userShip.position.x,
                                           game.userShip.position.y];
    // print("Saving Ship Spawn Location: ${playerDocument['shipSpawnLocation']}");
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

  Future<void> _saveDataToFireBase(StarRoutes game) async {

    _playerDataToPlayerDocument(game);

    PlayerData playerData = game.playerData;
    DocumentReference playerDoc = playerCollection.doc(playerData.playerId);

    // print("Saving Player Data $playerDocument");
    await playerDoc.set(playerDocument);
  }

  void saveDataLocally(StarRoutes game){

    /* Save To Document */
    _playerDataToPlayerDocument(game);

    final Box<dynamic> playerDataBox = Hive.box("playerData");

    playerDataBox.put('data', playerDocument);
    print("Player Data Saved Locally");

  }

  void loadDataLocally(PlayerData playerData){
    final Box<dynamic> playerDataBox = Hive.box("playerData");
    print("Loading Data Locally");
    playerDocument = Map<String, dynamic>.from(playerDataBox.get('data')
                                            ?? defaultPlayerData);


    for (String key in overrideCustomData.keys){
      playerDocument[key] = overrideCustomData[key];
    }
    _playerDocumentToPlayerData(playerData);
  }

}