
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:star_routes/data/mission_data.dart';
import 'package:star_routes/screen_components/accepted_mission_card.dart';

class MissionsPage extends StatelessWidget {

  List<MissionData> availableMissions;

  MissionsPage({super.key, required this.availableMissions});

  @override
  Widget build(BuildContext context) {

    const headerTextStyle = TextStyle(
      fontSize: 20.0,
      fontFamily: 'Audiowide',
      color: Color(0xFFF8F8F8),
      letterSpacing: -0.96,
    );




    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 12.0),
      child: SingleChildScrollView(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Active Missions */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Active",
                  style: headerTextStyle,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFeeeeee),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  height: 55.0,
                )
              ],
            ),
            const SizedBox(height: 12.0),
            /* Accepted Missions */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Accepted",
                  style: headerTextStyle,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  height: 55.0,
                ),
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
                  return AcceptedMissionCard(missionData: mission);
                  }
                )


              ],
            ),
          ],
        ),
      ),
    );
  }
}
