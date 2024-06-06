
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/config.dart';

import 'package:star_routes/data/planet_data.dart';
import 'package:star_routes/data/world_data.dart';

class MiniMapScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "miniMap";

  MiniMapScreen({super.key, required this.game});


  @override
  State<MiniMapScreen> createState() => _MiniMapScreenState();
}

class _MiniMapScreenState extends State<MiniMapScreen> {


  bool _isPlanetFocused = false;

  PlanetData? _focusedPlanet;

  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Use MediaQuery to get the size of the screen or parent container
    final size = MediaQuery.of(context).size;

    // Size of the visible area (InteractiveViewer container)
    final visibleWidth = size.width;
    final visibleHeight = size.height;

    // Point to center on within the child widget
    double centerX = widget.game.userShip.position.x - Config.worldBoundaryLeft;
    double centerY = widget.game.userShip.position.y - Config.worldBoundaryTop;

    print("User Ship Position: ${widget.game.userShip.position}");
    print("CenterX: $centerX, CenterY: $centerY");

    // Calculate the initial translation to center the view on (centerX, centerY)
    double initialX = visibleWidth / 2 - centerX;
    double initialY = visibleHeight / 2 - centerY;

    _transformationController.value = Matrix4.identity()..translate(initialX, initialY);
  }

  void _closeMiniMap() {
    widget.game.overlays.remove(MiniMapScreen.id);
    widget.game.resumeEngine();
  }

  @override
  Widget build(BuildContext context) {

    bool isNavigating = widget.game.navigationPointer.isNavigating();
    // PlanetData fakePlanetData = PlanetData(
    //   planetName: 'Fake Temp Planet',
    //   location: Vector2(300, 300) + Vector2(Config.worldBoundaryLeft, Config.worldBoundaryTop),
    //   radius: 150,
    //   mass: 5,
    //   population: 0,
    //   occupations: [],
    //   exports: [],
    //   imports: [],
    //   spriteName: 'does not exist',
    //   spriteSize: Vector2.zero(),
    //   numSprites: 0,
    // );

    Vector2 shipPosition = widget.game.userShip.position;
    Vector2 shipSize = widget.game.userShip.size;

    final List<PlanetData> planets = WorldData.planets;
    // planets.add(fakePlanetData);

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Stack(
          children: [
            InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.1,
              onInteractionStart: (details) {
                setState(() {
                  _isPlanetFocused = false;
                });
              },
              transformationController: _transformationController,
              child: SizedBox(
                width: Config.worldBoundaryRight - Config.worldBoundaryLeft + 2 * Config.miniMapMargin,
                height: Config.worldBoundaryBottom - Config.worldBoundaryTop + 2 * Config.miniMapMargin,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: GridPainter(
                        gridSize: 300,
                        gridColor: const Color(0xA0FFFFFF),
                        strokeWidth: 3,
                      ),
                    ),
                    CustomPaint(
                      size: Size.infinite,
                      painter: GridPainter(
                        gridSize: 60,
                        gridColor: const Color(0x30FFFFFF),
                        strokeWidth: 2,
                      ),
                    ),
                    Positioned(
                        left: shipPosition.x - Config.worldBoundaryLeft - shipSize.x / 2,
                        top: shipPosition.y - Config.worldBoundaryTop - shipSize.y / 2,
                        child: Transform.rotate(
                          angle: widget.game.userShip.angle,
                          child: Icon(
                              Icons.navigation,
                              color: Color(0xEEFFFFFF),
                              size: shipSize.x),
                        )
                    ),
                    ...planets.map((planet) {
                      return Positioned(
                        left: planet.location.x - Config.worldBoundaryLeft - planet.radius,
                        top: planet.location.y - Config.worldBoundaryTop - planet.radius,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {

                                setState(() {
                                  _isPlanetFocused = true;
                                  _focusedPlanet = planet;
                                });
                              },
                              child: Icon(
                                Icons.circle,
                                color: planet.miniMapColor,
                                size: planet.radius * 2,
                              ),
                            ),
                            Text(
                              planet.planetName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeInOut,
              bottom: 90,
              right: 20,
              duration: Duration(milliseconds: 3000),
              child: Container(
                // width: 200,
                // height: 150,
                // color: Colors.transparent,
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // SizedBox(height: 10),
                    if (_isPlanetFocused || isNavigating)
                    FilledButton.icon(
                      onPressed: () {

                        if (_isPlanetFocused){
                          widget.game.navigationPointer.setNavigationTarget(_focusedPlanet!.location);
                          setState(() {
                          });
                          _closeMiniMap();
                        }
                        else{
                          widget.game.navigationPointer.setNavigationTarget(null);
                          setState(() {
                          });
                        }

                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF606060)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),

                      ),
                      icon: const Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                      label: Text(
                          _isPlanetFocused ? "Navigate" : "End Nav",
                          style: const TextStyle(
                            fontFamily: "SpaceMono",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                      ),
                    ),



                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _closeMiniMap,
        backgroundColor: const Color(0xFFDDDDDD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Make the button boxy with rounded corners
        ),
        child: const Icon(
          Icons.close,
          color: Color(0xA4000000),
          weight: 900,
          size: 30.0, // Increase the size if you want the cross to be thicker
        ),
      ),
    );
  }
}


class GridPainter extends CustomPainter {
  final double gridSize;
  final Color gridColor;
  final double strokeWidth;

  GridPainter({required this.gridSize,
               required this.gridColor,
               required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = strokeWidth;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }


}