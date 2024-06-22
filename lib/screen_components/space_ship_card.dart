import 'package:flutter/material.dart';
import 'package:star_routes/data/space_ship_state.dart';

class SpaceShipCard extends StatelessWidget {
  final String shipName;
  final SpaceShipState shipState;

  const SpaceShipCard({
    super.key,
    required this.shipName,
    required this.shipState,
  });

  @override
  Widget build(BuildContext context) {
    if (shipState.isOwned == false) {
      return Container();
    }

    // Define the ratio of height to width
    const double heightToWidthRatio = 0.3591; // You can adjust this ratio as needed

    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double calculatedHeight = availableWidth * heightToWidthRatio;

        return Container(
          width: availableWidth,
          height: calculatedHeight,
          margin: const EdgeInsets.only(top: 8.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image(
                fit: BoxFit.contain,
                image: AssetImage(
                  "assets/images/user_interface/ship_cards/${shipName.toLowerCase().replaceAll(' ', '_')}.png",
                ),
              ),
              Positioned(
                top: calculatedHeight * 0.06,
                left: availableWidth * 0.33,
                child: Container(
                  // color: const Color(0x4400FF00),
                  width: availableWidth * 0.60, // Adjust the width calculation here
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: calculatedHeight * 0.36,
                left: availableWidth * 0.33,
                child: SizedBox(
                  width: availableWidth * 0.60,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
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
                            ),
                          ),
                          const TextSpan(text: "\n"),
                          TextSpan(
                            text: shipState.displayMissionStatus(),
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'SpaceMono',
                              color: Color(0xFF313131),
                              letterSpacing: -0.54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: calculatedHeight * 0.06,
                left: availableWidth * 0.33,
                child: SizedBox(
                  width: availableWidth * 0.60,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
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
                            ),
                          ),
                          TextSpan(
                            text: shipState.displayCrashes(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SpaceMono',
                              color: Color(0xFF313131),
                              letterSpacing: -0.54,
                            ),
                          ),
                          const TextSpan(
                            text: "  ",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'SpaceMono',
                              color: Color(0xFF313131),
                              letterSpacing: -0.54,
                            ),
                          ),
                          const TextSpan(
                            text: "MISSIONS ",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'SpaceMono',
                              color: Color(0xFF313131),
                              letterSpacing: -0.54,
                            ),
                          ),
                          TextSpan(
                            text: shipState.displayMissionCount(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SpaceMono',
                              color: Color(0xFF313131),
                              letterSpacing: -0.54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
