

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:change_case/change_case.dart';

import 'package:star_routes/data/mission_data.dart';

class MissionCard extends StatelessWidget {

  final MissionData missionData;

  final isAccepted;

  // Make this function accpet a parameter Mission Data
  final void Function(MissionData) onAccept;


  // final VoidCallback onAccept;
  const MissionCard({super.key,
                     required this.missionData,
                     required this.onAccept,
                     required this.isAccepted,
                    });


  @override
  Widget build(BuildContext context) {

    const smallHeaderTextStyle = TextStyle(
      fontSize: 12.0,
      fontFamily: 'SpaceMono',
      color: Color(0xFF313131),
      letterSpacing: -0.54,
    );

    const detailTextStyle = TextStyle(
      fontSize: 12.0,
      fontFamily: 'SpaceMono',
      color: Color(0xFF313131),
      letterSpacing: -0.48,
    );

    const boldDetailTextStyle = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'SpaceMono',
      color: Color(0xFF000000),
      letterSpacing: -0.60,
    );

    const rewardTextStyle = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Audiowide',
      color: Color(0xFF000000),
      letterSpacing: -0.60,
    );


    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          /* Mission Details */
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 0.0, top: 10.0, bottom: 5),
            child: Column(
              children: <Widget>[
                /* Location & Cargo */
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /* Location */
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Location".toUpperCase(),
                            style: smallHeaderTextStyle,
                          ),
                          /*Pick Up */
                          Row(
                            children: <Widget>[
                              Text(
                                "PickUp: ".toUpperCase(),
                                style: detailTextStyle,
                              ),
                              Text(
                                missionData.sourcePlanet.toUpperCase(),
                                style: boldDetailTextStyle,
                              ),
                            ],
                          ),
                          /* Drop Off*/
                          Row(
                            children: <Widget>[
                              Text(
                                "Drop Off: ".toUpperCase(),
                                style: detailTextStyle,
                              ),
                              Text(
                                missionData.destinationPlanet.toUpperCase(),
                                style: boldDetailTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    /* Cargo */
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cargo".toUpperCase(),
                              style: smallHeaderTextStyle,
                            ),
                            Text(
                              missionData.formattedCargoDetails().toTitleCase(),
                              style: boldDetailTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                /* Eligible Ships & Reward */
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /* Eligible Ships */
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Eligible Ships".toUpperCase(),
                            style: smallHeaderTextStyle,
                          ),
                          /* Ship Classes */
                          Text(
                            missionData.formattedEligibleShips().toUpperCase(),
                            style: boldDetailTextStyle,
                          ),
                        ],
                      ),
                    ),
                    /* Reward */
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Max Reward: ".toUpperCase(),
                            style: smallHeaderTextStyle,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                missionData.reward.toString().toUpperCase(),
                                style: rewardTextStyle,
                              ),
                              const SizedBox(width: 4.0),
                              const Image(
                                image: AssetImage('assets/images/user_interface/black_coin.png'),
                                height: 20.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          /* Interactions */
          if (!isAccepted)
            Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /* Accept Button */
              Expanded(
                child: TextButton(
                  onPressed: () {
                    onAccept(missionData);
                    // print("Mission Accepted");
                    /* Add this mission to  */

                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(bottom: 8), // Remove padding
                    minimumSize: const Size(0, 0), // Remove minimum size constraints
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove additional padding
                    alignment: Alignment.center,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/user_interface/accept_button.svg',
                    height: 23.0,
                  ),
                ),
              ),
              /* Reject Button */
              Expanded(
                child: TextButton(
                  onPressed: () {
                    print("Mission Rejected");
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(bottom: 8), // Remove padding
                    minimumSize: const Size(0, 0), // Remove minimum size constraints
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove additional padding
                    alignment: Alignment.center,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/user_interface/reject_button.svg',
                    height: 23.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
