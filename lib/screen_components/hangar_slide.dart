
import 'dart:math';

import 'package:flutter/material.dart';

class HangarSlide extends StatelessWidget {
  final String spriteName;
  final String shipName;
  final String description;

  HangarSlide({
    required this.spriteName,
    required this.shipName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const SizedBox(height: 280),
        Stack(
          // fit: StackFit.expand,
          // clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: <Widget>[
            Image.asset(
              'assets/images/user_interface/hanger_cards/${shipName.toLowerCase().replaceAll(' ', '_')}.png',
              fit: BoxFit.contain,
            ),
            Container(
              // margin: const EdgeInsets.only(top: 10, bottom: 300),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Border text
                  const SizedBox(height: 10.0),
                  Stack(
                    children: [
                      // Fill text
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            shipName.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SpaceMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              color: Colors.black,
                              letterSpacing: -2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: const Offset(1, 5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            shipName.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SpaceMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              letterSpacing: -2,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1
                                ..color = const Color(0xFFA9A9A9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Column(
                      children: [
                        ShipSpecification(spec: "SPEED", rating: 1),
                        ShipSpecification(spec: "AGILITY", rating: 2),
                        ShipSpecification(spec: "CARGO", rating: 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  Stack(
                    children: [
                      TextButton(
                        onPressed: (){
                          print("Buy");
                        },
                        child: const Image(
                          image: AssetImage('assets/images/user_interface/buy_button.png'),
                          width: 300,
                        ),
                      ),
                      Positioned(
                        right: 52,
                        top: 20,
                        child: Row(
                          children: [

                            const Text(
                              "500",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Audiowide',
                                color: Color(0xFF2A2A2A),
                                letterSpacing: -0.54,
                              )
                            ),
                            const SizedBox(width: 5),
                            /*Image */
                            Image.asset(
                              "assets/images/user_interface/black_coin.png",
                              width: 25,

                            )
                          ],
                        ),
                      )
                    ],
                  )
                ]
              ),
            ),

          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}


class ShipSpecification extends StatelessWidget {

  String spec;
  int rating;

  ShipSpecification({super.key, required this.spec, required this.rating});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const SizedBox(width: 1),
        Text(
          "$spec".toUpperCase(),
          style: const TextStyle(
            fontFamily: 'MonoSpace',
            fontWeight: FontWeight.normal,
            color: Color(0xFFD0D0D0),
            fontSize: 24.0,
            letterSpacing: -2,
          ),
        ),
        // const SizedBox(width: 50),
        Image(
          image: AssetImage('assets/images/user_interface/rating$rating.png'),
        ),
        // const SizedBox(width: 1),
      ],
    );
  }
}
