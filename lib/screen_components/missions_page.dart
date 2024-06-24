
import 'package:flutter/material.dart';

import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/data/player_data.dart';
import 'package:star_routes/screen_components/mission_card.dart';

class MissionsPage extends StatelessWidget {

  final List<MissionData> initiatedMissions;
  final List<MissionData> availableMissions;
  final List<MissionData> acceptedMissions;

  final void Function(MissionData) onAccept;
  final void Function(MissionData) onReject;

  final int playerLevel;

  const MissionsPage({super.key,
                      required this.initiatedMissions,
                      required this.availableMissions,
                      required this.acceptedMissions,
                      required this.onAccept,
                      required this.onReject,
                      required this.playerLevel,
                    });

  @override
  Widget build(BuildContext context) {

    const headerTextStyle = TextStyle(
      fontSize: 20.0,
      fontFamily: 'Audiowide',
      color: Color(0xFFF8F8F8),
      letterSpacing: -0.96,
    );

    int nextUnlockLevel = 0;

    for (int i in PlayerData.missionSlotUnlockLevels){
      if (playerLevel < i){
        nextUnlockLevel = i;
        break;
      }
    }


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 12.0),
      child: SingleChildScrollView(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Initiated",
                  style: headerTextStyle,
                ),
                ...initiatedMissions.map((mission) {
                  return MissionCard(
                    missionData: mission,
                    onAccept: onAccept,
                    onReject: onReject,
                    isAccepted: true,
                  );
                }
                )
                // Container(
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFDDDDDD),
                //     borderRadius: BorderRadius.circular(4.0),
                //   ),
                //   height: 55.0,
                // ),
              ],
            ),
            const SizedBox(height: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Accepted",
                  style: headerTextStyle,
                ),
                ...acceptedMissions.map((mission) {
                  return MissionCard(
                      missionData: mission,
                      onAccept: onAccept,
                      onReject: onReject,
                      isAccepted: true,
                    );
                  }
                )
                // Container(
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFDDDDDD),
                //     borderRadius: BorderRadius.circular(4.0),
                //   ),
                //   height: 55.0,
                // ),
              ],
            ),
            const SizedBox(height: 12.0),
            /* Available Missions */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Available",
                  style: headerTextStyle,
                ),
                ...availableMissions.map((mission) {
                  return MissionCard(
                      missionData: mission,
                      onAccept: onAccept,
                      onReject: onReject,
                      isAccepted: false,
                    );
                  }
                )


              ],
            ),
            // const SizedBox(height: 12.0),
            /*Locked Mission Slots */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (nextUnlockLevel != 0)
                  MissionCard(
                    missionData: MissionData.blank(),
                    onAccept: (MissionData data) {},
                    onReject: (MissionData data) {},
                    isAccepted: false,
                    unlockLevel: nextUnlockLevel,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
