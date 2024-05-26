
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
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Transform.rotate(
              angle: pi/3,
              child: Container(
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Image.asset("assets/images/space_ships/$spriteName.png",
                // width: 300,
                // height: 200,
                fit: BoxFit.contain,
                            ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0x3dCCCCCC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Ship Class*/
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      shipName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 27.0,
                        fontFamily: 'Audiowide',
                        color: Colors.white,

                      ),
                    ),
                  ),

                  /* Ship Specifications */
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
                    child: Column(
                      children: [
                        ShipSpecification(spec: "Capacity", rating: 1),
                        ShipSpecification(spec: "Speed", rating: 2),
                        ShipSpecification(spec: "Maneuverability", rating: 3),
                      ],
                    ),
                  ),
                  /* Buy Sell */
                  Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Image(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/user_interface/buy_button.png'),
                          ),
                      ),
                      const Positioned(
                        top: 24,
                        left: 200,
                        child: Text(
                        '3000',
                        style: TextStyle(
                          color: Color(0xFF1C1C1C),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Audiowide',

                        )
                       )
                      ),
                    ],
                  ),

                ],

              ),
            ),
          )
        ],
      ),
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
        Text(
          "$spec:".toUpperCase(),
          style: const TextStyle(
            fontFamily: 'MonoSpace',
            fontWeight: FontWeight.bold,
            color: Color(0xFFCACACA),
            fontSize: 15.0,
          ),
        ),
        Image(
          image: AssetImage('assets/images/user_interface/rating$rating.png'),
        )
      ],
    );
  }
}
