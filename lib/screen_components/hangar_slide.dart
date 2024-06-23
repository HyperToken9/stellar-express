import 'package:flutter/material.dart';
import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/space_ship_state.dart';

class HangarSlide extends StatelessWidget {
  final SpaceShipData shipData;
  final SpaceShipState shipState;
  final void Function(SpaceShipData) onSell;
  final void Function(SpaceShipData) onBuy;
  late String spritePath;

  HangarSlide({
    super.key,
    required this.shipData,
    required this.shipState,
    required this.onSell,
    required this.onBuy,
  }) {
    spritePath = 'assets/images/user_interface/hanger_cards/${shipData.shipClassName.toLowerCase().replaceAll(' ', '_')}.png';
  }

  @override
  Widget build(BuildContext context) {
    // Define the ratio of height to width
    const double heightToWidthRatio = 0.92; // Adjust this ratio as needed
    // double availableWidth;
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double calculatedHeight = availableWidth * heightToWidthRatio;

        return Container(
          width: availableWidth,
          height: calculatedHeight,
          margin: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Image.asset(
                    spritePath,
                    fit: BoxFit.contain,
                    width: availableWidth * 0.9,
                    height: calculatedHeight,
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: calculatedHeight * 0.12),
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: availableWidth * 0.1),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                shipData.shipClassName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SpaceMono',
                                  fontWeight: FontWeight.bold,
                                  fontSize: availableWidth * 0.1,
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
                            padding: EdgeInsets.symmetric(horizontal: availableWidth * 0.1),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                shipData.shipClassName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SpaceMono',
                                  fontWeight: FontWeight.bold,
                                  fontSize: availableWidth * 0.1,
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
                      SizedBox(height: calculatedHeight * 0.07),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: availableWidth * 0.12),
                        child: Column(
                          children: [
                            ShipSpecification(spec: "SPEED", rating: shipData.displaySpeed),
                            ShipSpecification(spec: "AGILITY", rating: shipData.displayManeuverability),
                            ShipSpecification(spec: "CARGO", rating: shipData.displayCapacity),
                          ],
                        ),
                      ),
                      SizedBox(height: calculatedHeight * 0.07),
                      Stack(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
                              minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              shipState.isOwned ? onSell(shipData) : onBuy(shipData);
                            },
                            child: Image(
                              image: AssetImage('assets/images/user_interface/${shipState.isOwned ? "sell_button" : "buy_button"}.png'),
                              width: availableWidth * 0.66,
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
                                    (shipState.isOwned ? shipData.baseSalvageValue : shipData.baseCostValue).toString(),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Audiowide',
                                      color: Color(0xFF2A2A2A),
                                      letterSpacing: -0.54,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset(
                                    "assets/images/user_interface/black_coin.png",
                                    width: availableWidth * 0.06,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

class ShipSpecification extends StatelessWidget {
  final String spec;
  final int rating;

  ShipSpecification({super.key, required this.spec, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        Image(
          image: AssetImage('assets/images/user_interface/ratings/rating$rating.png'),
        ),
      ],
    );
  }
}
