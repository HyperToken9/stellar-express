


import 'package:flutter/material.dart';

import 'package:star_routes/data/space_ship_state.dart';


class SpaceShipCard extends StatelessWidget {

  final SpaceShipState shipState;

  // final VoidCallback onAccept;
  const SpaceShipCard({super.key,
    required this.shipState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(.0),
      width: 380,
      height: 110,
      // color: Colors.green,
      margin: const EdgeInsets.only(top: 8.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
              fit: BoxFit.contain,
              image: AssetImage(
                  "assets/images/user_interface/ship_cards/temp_card.png"
              )
          ),
          const Positioned(
              top: 7,
              left: 10,
              child: Text.rich(

                  TextSpan(
                      children: [
                        TextSpan(
                          text: "",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'Audiowide',
                            color: Color(0xFF191919),
                            letterSpacing: -0.54,
                          ),
                        ),
                        /*space */

                        TextSpan(
                          text: "",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Audiowide',
                            color: Color(0xFF7B7B7B),
                            letterSpacing: -0.74,
                          ),
                        )
                      ]
                  )
              )
          ),
          Positioned(
              top: 32,
              left: 10,
              child: Text(
                "missionData.getDisplayEligibleShips()",
                style: const TextStyle(
                  fontSize: 13.0,
                  fontFamily: 'SpaceMono',
                  color: Color(0xFF313131),
                  letterSpacing: -0.54,
                ),
              )
          ),
          Positioned(
              top: 38,
              left: 10,
              child: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(
                            text: "missionData.sourcePlanet.toUpperCase()",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'SpaceMono',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F4F4F),
                              letterSpacing: -0.54,
                            )
                        ),
                        const TextSpan(
                            text: " ··· ",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontFamily: 'SpaceMono',
                              color: Color(0xFF757575),
                              letterSpacing: -7.54,
                            )
                        ),
                        TextSpan(
                            text:" missionData.destinationPlanet.toUpperCase()",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'SpaceMono',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F4F4F),
                              letterSpacing: -0.54,
                            )
                        )

                      ]
                  )
              )
          ),
          Positioned(
              bottom: 6,
              left: 10,
              child: Row(
                children: [
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                                text: "Reward: ".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'SpaceMono',
                                  color: Color(0xFF141414),
                                  letterSpacing: -0.54,
                                )
                            ),
                            TextSpan(
                                text: "missionData.reward.toString()",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Audiowide',
                                  color: Color(0xFF313131),
                                  letterSpacing: -0.54,
                                )
                            )
                          ]
                      )
                  ),
                  /*Image */
                  Image.asset(
                    "assets/images/user_interface/black_coin.png",
                    width: 20,
                    height: 20,
                  )
                ],
              )
          ),

        ],
      ),
    );
  }

}