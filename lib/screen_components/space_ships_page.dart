import 'package:flutter/material.dart';

import 'package:star_routes/data/space_ship_state.dart';

import 'package:star_routes/screen_components/space_ship_card.dart';

class SpaceShipsPage extends StatelessWidget {

  final Map<String, SpaceShipState> spaceShipStates;

  const SpaceShipsPage({super.key, required this.spaceShipStates});

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...spaceShipStates.keys.map((String shipName) {
                  return SpaceShipCard(
                    shipName: shipName,
                    shipState: spaceShipStates[shipName]!,
                  );
                }
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFDDDDDD),
                //     borderRadius: BorderRadius.circular(4.0),
                //   ),
                //   height: 55.0,
                // ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
