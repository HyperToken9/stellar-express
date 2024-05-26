

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Active Missions */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Active",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Audiowide',
                    color: Color(0xFFF8F8F8),
                    letterSpacing: -0.96,
                  ),
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
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Audiowide',
                    color: Color(0xFFF8F8F8),
                    letterSpacing: -0.96,
                  ),
                ),
        
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
        
                  height: 55.0,
                ),

                // const SizedBox(height: 8.0),

              ],
            ),

            const SizedBox(height: 12.0),
        
            /* Available Missions */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Available",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Audiowide',
                    color: Color(0xFFF8F8F8),
                    letterSpacing: -0.96,
                  ),
                ),
        
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  // height: 55.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      /* Mission Details */
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 0.0, top: 10.0, bottom: 5),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.,
                          children: <Widget>[
                            /* Location & Cargo */
                            Row(
                              children: <Widget>[
                                /* Location */
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:<Widget>[
                                      Text(
                                        "Location".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11.0,
                                          fontFamily: 'SpaceMono',
                                          color: Color(0xFF313131),
                                          letterSpacing: -0.54,
                                        )
                                      ),

                                      /*Pick Up */
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "PickUp: ".toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              fontFamily: 'SpaceMono',
                                              color: Color(0xFF313131),
                                              letterSpacing: -0.48,
                                            )
                                          ),
                                          Text(
                                              "zeloris".toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceMono',
                                                color: Color(0xFF000000),
                                                letterSpacing: -0.60,
                                              )
                                          ),
                                        ]
                                      ),

                                      /* Drop Off*/
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              "Drop Off: ".toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                fontFamily: 'SpaceMono',
                                                color: Color(0xFF313131),
                                                letterSpacing: -0.48,
                                              )
                                          ),
                                          Text(
                                              "targalon".toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceMono',
                                                color: Color(0xFF000000),
                                                letterSpacing: -0.60,
                                              ),
                                          )
                                        ]
                                      ),
                                    ]
                                  ),
                                ),
                                /* Cargo */
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cargo".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11.0,
                                          fontFamily: 'SpaceMono',
                                          color: Color(0xFF313131),
                                          letterSpacing: -0.54,
                                        )
                                      ),
                                      Text(
                                        "A Small Shipment of Raw Energy".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SpaceMono',
                                          color: Color(0xFF000000),
                                          letterSpacing: -0.60,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            /* Eligible Ships & Reward */
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /* Eligible Ships */
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:<Widget>[
                                        Text(
                                          "Eligible Ships".toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 11.0,
                                              fontFamily: 'SpaceMono',
                                              color: Color(0xFF313131),
                                              letterSpacing: -0.54,
                                            )
                                        ),
                                  
                                        /* Ship Classes */
                                        Text(
                                          "SC HD STH".toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'SpaceMono',
                                            color: Color(0xFF000000),
                                            letterSpacing: -0.60,
                                          ),
                                        ),
                                      ]
                                  ),
                                ),

                                /* Reward */
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Max Reward: ".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11.0,
                                          fontFamily: 'SpaceMono',
                                          color: Color(0xFF313131),
                                          letterSpacing: -0.54,
                                        ),
                                      ),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "3 000".toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SpaceMono',
                                                color: Color(0xFF000000),
                                                letterSpacing: -0.60,
                                              ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          const Image(
                                            image: AssetImage('assets/images/user_interface/black_coin.png'),
                                            height: 20.0,
                                            // width: 20.0,
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ),
                      ),

                      /* Interactions */
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          /* Accept Button */
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                print("Mission Accepted");
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(bottom:8), // Remove padding
                                minimumSize: Size(0, 0), // Remove minimum size constraints
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
                                padding: const EdgeInsets.only(bottom:8), // Remove padding
                                minimumSize: Size(0, 0), // Remove minimum size constraints
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove additional padding
                                alignment: Alignment.center,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/user_interface/reject_button.svg',
                                height: 23.0,
                              ),
                            ),
                          ),
                        ]

                      ),

                    ]
                  )


                )
        
              ],
            ),
          ]
        
        ),
      ),
    );
  }
}
