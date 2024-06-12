
import 'package:star_routes/data/space_ship_data.dart';

import 'package:flutter/material.dart';
import 'package:star_routes/data/space_ship_state.dart';

class HangarSlide extends StatelessWidget {

  final SpaceShipData shipData;
  final SpaceShipState shipState;
  void Function(SpaceShipData) onSell;
  void Function(SpaceShipData) onBuy;
  late String spritePath;
  HangarSlide({super.key, required this.shipData, required this.shipState, required this.onSell, required this.onBuy}){
    spritePath = 'assets/images/user_interface/hanger_cards/${shipData.shipClassName.toLowerCase().replaceAll(' ', '_')}.png';
  }

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
              spritePath,
              fit: BoxFit.contain,
            ),
            Column(
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
                          shipData.shipClassName.toUpperCase(),
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
                          shipData.shipClassName.toUpperCase(),
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
                      ShipSpecification(spec: "SPEED", rating: shipData.displaySpeed),
                      ShipSpecification(spec: "AGILITY", rating: shipData.displayManeuverability),
                      ShipSpecification(spec: "CARGO", rating: shipData.displayCapacity),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Stack(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
                        minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: (){
                        shipState.isOwned ? onSell(shipData): onBuy(shipData);
                      },
                      child: Image(
                        image: AssetImage('assets/images/user_interface/${
                                           shipState.isOwned ? "sell_button": "buy_button"}.png'),
                        width: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 8,
                      child: IgnorePointer(
                        child: Row(
                          children: [
                            Text(
                              (shipState.isOwned ? shipData.baseSalvageValue :
                                  shipData.baseCostValue).toString(),
                              style: const TextStyle(
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
                      ),
                    )
                  ],
                )
              ]
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
          spec.toUpperCase(),
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
          image: AssetImage('assets/images/user_interface/ratings/rating$rating.png'),
        ),
        // const SizedBox(width: 1),
      ],
    );
  }
}
