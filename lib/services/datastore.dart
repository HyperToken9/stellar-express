

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';

import 'package:star_routes/data/player_data.dart';
import 'package:star_routes/data/space_ship_data.dart';


class Datastore {
  final CollectionReference playerCollection = FirebaseFirestore.instance.collection('players');

  Map<String, dynamic> playerDocument = {};

  Future<void> loadPlayerData(String playerId) async {
    DocumentReference playerDoc = playerCollection.doc(playerId);

    try {
      DocumentSnapshot docSnapshot = await playerDoc.get();

      if (docSnapshot.exists) {
        // Document exists, retrieve the data
        Map<String, dynamic>? playerData = docSnapshot.data() as Map<String, dynamic>?;
        // Process the data as needed
        print('Player data: $playerData');
        playerDocument = playerData!;
      } else {
        // Document does not exist, initialize some data

        Map<String, dynamic> defaultShipStates = {};

        for (SpaceShipData shipData in SpaceShipData.spaceShips) {
          if (shipData.shipClassName == "Small Courier") {
            defaultShipStates[shipData.shipClassName] = {
              'isOwned': true,
              'isCarryingCargo': false,
            };
          } else {
            defaultShipStates[shipData.shipClassName] = {
              'isOwned': false,
              'isCarryingCargo': false,
            };
          }
        }

        Map<String, dynamic> initialData = {
          'coin': 100,
          'totalExperience': 0,
          'shipLocation': [0, 0],
          'equippedShip': 'Small Courier',
          'spaceShipStates': defaultShipStates,
          'archivedMissions': [],
          'completedMissions': [],
          'initiatedMissions': [],
          'acceptedMissions': [],
          'availableMissions': [],

        };

        // Add other fields as needed
        await playerDoc.set(initialData);
        print('Initialized player data: $initialData');
      }
    } catch (e) {
      print('Error loading player data: $e');
    }
  }
}