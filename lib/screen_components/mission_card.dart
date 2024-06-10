
import 'package:flutter/material.dart';

import 'package:star_routes/data/mission_data.dart';


class MissionCard extends StatelessWidget {

  final MissionData missionData;

  final bool isAccepted;

  // Make this function accpet a parameter Mission Data
  final void Function(MissionData) onAccept;
  final void Function(MissionData) onReject;


  // final VoidCallback onAccept;
  const MissionCard({super.key,
    required this.missionData,
    required this.onAccept,
    required this.onReject,
    required this.isAccepted,
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
          Image(
              fit: BoxFit.contain,
              image: AssetImage(
                  missionData.getDisplayBackgroundImagePath()
              )
          ),
          Positioned(
            top: 7,
            left: 10,
            child: Text.rich(

              TextSpan(
                children: [
                  TextSpan(
                    text: "${missionData.getDisplayItemName()} ",
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Audiowide',
                      color: Color(0xFF191919),
                      letterSpacing: -0.54,
                    ),
                  ),
                  /*space */

                  TextSpan(
                    text: missionData.getDisplayCargoSize(),
                    style: const TextStyle(
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
              missionData.getDisplayEligibleShips(),
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
                    text: missionData.sourcePlanet.toUpperCase(),
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
                      text: missionData.destinationPlanet.toUpperCase(),
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
                        text: missionData.reward.toString(),
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

          if (!isAccepted)
          Positioned(
            right: 10,
            bottom: 6,
            child: Row(
              children:[
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
                    minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: (){
                    print("Declining A mission");
                    onReject(missionData);
                  },
                  child: Image.asset(
                    "assets/images/user_interface/reject_button.png",
                    scale: 1,
                    fit: BoxFit.contain,
                  )

                ),
                SizedBox(width: 10,),
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
                    minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: (){
                      print("Accepting A mission");
                      onAccept(missionData);
                  },
                  child: Image.asset(
                      "assets/images/user_interface/accept_button.png",
                      scale: 0.9,
                      fit: BoxFit.contain,
                  )

                )
              ]

            )

          )
        ],
      ),
    );
  }

}