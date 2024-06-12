


import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';

import 'package:star_routes/data/space_ship_state.dart';


class SpaceShipCard extends StatelessWidget {

  final String shipName;
  final SpaceShipState shipState;

  // final VoidCallback onAccept;
  const SpaceShipCard({super.key,
    required this.shipName,
    required this.shipState,
  });

  @override
  Widget build(BuildContext context) {

    if (shipState.isOwned == false) {
      return Container();
    }

    return Container(
      // padding: EdgeInsets.all(.0),
      width: 380,
      height: 110,
      // color: Colors.green,
      margin: const EdgeInsets.only(top: 8.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
              fit: BoxFit.contain,
              image: AssetImage(
                  "assets/images/user_interface/ship_cards/${shipName.toLowerCase().replaceAll(' ', '_')}.png"
              )
          ),
          Positioned(
            top: 7,
            left: 115,
            child: Container(
              // color: const Color(0x4400FF00),
              width: 183,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text.rich(
                    // textAlign: TextAlign.left,
                    TextSpan(
                        children: [
                          TextSpan(
                            text: shipName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Audiowide',
                              color: Color(0xFF222222),
                              letterSpacing: -0.54,
                            ),
                          )
                        ]
                    )
                ),
              ),
            )
          ),
          Positioned(
            top: 40,
            left: 125,
            child: Text.rich(
                TextSpan(
                    children: [
                      TextSpan(
                        text: shipState.displayLocationStatus(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'SpaceMono',
                          color: Color(0xFF313131),
                          letterSpacing: -0.54,
                        )
                      ),
                      const TextSpan(text:"\n"),
                      TextSpan(
                        text: shipState.displayMissionStatus(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'SpaceMono',
                          color: Color(0xFF313131),
                          letterSpacing: -0.54,
                        ),
                      )
                    ]
                )
            )
          ),
          Positioned(
            bottom: 7,
            left: 135,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: "CRASHES ",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'SpaceMono',
                        color: Color(0xFF313131),
                        letterSpacing: -0.54,
                      )
                  ),
                  TextSpan(
                      text: shipState.displayCrashes(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SpaceMono',
                        color: Color(0xFF313131),
                        letterSpacing: -0.54,
                      )
                  ),
                  const TextSpan(
                      text: "  ",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'SpaceMono',
                        color: Color(0xFF313131),
                        letterSpacing: -0.54,
                      )
                  ),
                  const TextSpan(
                      text: "MISSIONS ",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'SpaceMono',
                        color: Color(0xFF313131),
                        letterSpacing: -0.54,
                      )
                  ),
                  TextSpan(
                      text: shipState.displayMissionCount(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SpaceMono',
                        color: Color(0xFF313131),
                        letterSpacing: -0.54,
                      )
                  )
                ]
              ),

            )
          )
          // Positioned(
          //     top: 32,
          //     left: 10,
          //     child: Text(
          //       "missionData.getDisplayEligibleShips()",
          //       style: const TextStyle(
          //         fontSize: 13.0,
          //         fontFamily: 'SpaceMono',
          //         color: Color(0xFF313131),
          //         letterSpacing: -0.54,
          //       ),
          //     )
          // ),
          // Positioned(
          //     top: 38,
          //     left: 10,
          //     child: Text.rich(
          //         TextSpan(
          //             children: [
          //               TextSpan(
          //                   text: "missionData.sourcePlanet.toUpperCase()",
          //                   style: const TextStyle(
          //                     fontSize: 20.0,
          //                     fontFamily: 'SpaceMono',
          //                     fontWeight: FontWeight.bold,
          //                     color: Color(0xFF4F4F4F),
          //                     letterSpacing: -0.54,
          //                   )
          //               ),
          //               const TextSpan(
          //                   text: " ··· ",
          //                   style: TextStyle(
          //                     fontSize: 30.0,
          //                     fontFamily: 'SpaceMono',
          //                     color: Color(0xFF757575),
          //                     letterSpacing: -7.54,
          //                   )
          //               ),
          //               TextSpan(
          //                   text:" missionData.destinationPlanet.toUpperCase()",
          //                   style: const TextStyle(
          //                     fontSize: 20.0,
          //                     fontFamily: 'SpaceMono',
          //                     fontWeight: FontWeight.bold,
          //                     color: Color(0xFF4F4F4F),
          //                     letterSpacing: -0.54,
          //                   )
          //               )
          //
          //             ]
          //         )
          //     )
          // ),
          // Positioned(
          //     bottom: 6,
          //     left: 10,
          //     child: Row(
          //       children: [
          //         Text.rich(
          //             TextSpan(
          //                 children: [
          //                   TextSpan(
          //                       text: "Reward: ".toUpperCase(),
          //                       style: const TextStyle(
          //                         fontSize: 13.0,
          //                         fontFamily: 'SpaceMono',
          //                         color: Color(0xFF141414),
          //                         letterSpacing: -0.54,
          //                       )
          //                   ),
          //                   TextSpan(
          //                       text: "missionData.reward.toString()",
          //                       style: const TextStyle(
          //                         fontSize: 16.0,
          //                         fontFamily: 'Audiowide',
          //                         color: Color(0xFF313131),
          //                         letterSpacing: -0.54,
          //                       )
          //                   )
          //                 ]
          //             )
          //         ),
          //         /*Image */
          //         Image.asset(
          //           "assets/images/user_interface/black_coin.png",
          //           width: 20,
          //           height: 20,
          //         )
          //       ],
          //     )
          // ),

        ],
      ),
    );
  }

}