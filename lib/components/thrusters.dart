import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:star_routes/components/ship.dart';
import 'package:star_routes/game/star_routes.dart';


class Thrusters extends Component with HasGameRef<StarRoutes> {

  List<Thruster> thrusters = [];
  late Map<String, List<Thruster>> thrusterMap;

  late String currentShipThrusters;

  @override
  Future<void> onLoad() async {

    thrusterMap = {
      "Small Courier": <Thruster>[
          /* Right Mains */
          Thruster(position: Vector2(75, -5), direction: Vector2(0, 3), thrust: 3,
                   colors: [const Color(0x6FF64566), const Color(0x6FEF7D57)],
                   triggers: {"forward", "left"}, thrusterSize: 23),
          /* Left Mains */
          Thruster(position: Vector2(-69, -5), direction: Vector2(0, 3), thrust: 3,
                    colors: [const Color(0x6FF64566), const Color(0x6FEF7D57)],
                    triggers: {"forward", "right"}, thrusterSize: 23),
          /* Left Cold Gas */
          Thruster(position: Vector2(-72, -92), direction: Vector2(0, -1), thrust: 1,
                    colors: [const Color(0x6F666666), const Color(0x6FEEEEEE)],
                    triggers: {"backward", "left"}, thrusterSize: 14),
          /* Right Cold Gas */
          Thruster(position: Vector2(78, -92), direction: Vector2(0, -1), thrust: 1,
                    colors: [const Color(0x6F666666), const Color(0x6FEEEEEE)],
                    triggers: {"backward", "right"}, thrusterSize: 14),
      ],

      "Express Shuttle": <Thruster>[
        /* Right Mains */
        Thruster(position: Vector2(55, 220), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F41A6F6), const Color(0x6F73eff7)],
            triggers: {"forward", "left"}, thrusterSize: 40),
        /* Left Mains */
        Thruster(position: Vector2(-50, 220), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F41A6F6), const Color(0x6F73eff7)],
            triggers: {"forward", "right"}, thrusterSize: 40),
        /* Left Cold Gas */
        Thruster(position: Vector2(-200, 85), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6FFFFFFF), const Color(0x6F94B0C2)],
            triggers: {"backward", "left"}, thrusterSize: 23),
        /* Right Cold Gas */
        Thruster(position: Vector2(204, 85), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6FFFFFFF), const Color(0x6F94B0C2)],
            triggers: {"backward", "right"}, thrusterSize: 23),
      ],

      "Endurance Cruiser": <Thruster>[
        /* Right Mains */
        Thruster(position: Vector2(240, 150), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F9D303B), const Color(0x6FFDBF86)],
            triggers: {"forward", "left"}, thrusterSize: 70, priority: 5),
        /* Left Mains */
        Thruster(position: Vector2(-225, 150), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F9D303B), const Color(0x6FFDBF86)],
            triggers: {"forward", "right"}, thrusterSize: 70, priority: 5),
        /* Left Cold Gas */
        Thruster(position: Vector2(-230, -150), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6F7EC4C1), const Color(0x6F94B0C2)],
            triggers: {"backward", "left"}, thrusterSize: 50),
        /* Right Cold Gas */
        Thruster(position: Vector2(240, -150), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6F7EC4C1), const Color(0x6F94B0C2)],
            triggers: {"backward", "right"}, thrusterSize: 50),
      ],

      "Large Freighter": <Thruster>[
        /* Right Mains */
        Thruster(position: Vector2(170, 500), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6FD0A32E), const Color(0x6FD0CD2E)],
            triggers: {"forward", "left"}, thrusterSize: 70),
        /* Left Mains */
        Thruster(position: Vector2(-155, 500), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6FD0A32E), const Color(0x6FD0CD2E)],
            triggers: {"forward", "right"}, thrusterSize: 70),
        /* Left Cold Gas */
        Thruster(position: Vector2(-230, -120), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6FA385A4), const Color(0x6F4B335F)],
            triggers: {"backward", "left"}, thrusterSize: 50),
        /* Right Cold Gas */
        Thruster(position: Vector2(225, -120), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6FA385A4), const Color(0x6F4B335F)],
            triggers: {"backward", "right"}, thrusterSize: 50),
      ],
      "Stealth Courier" :[
        /* Right Mains */
        Thruster(position: Vector2(100, 80), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F87F8FF), const Color(0x6F3F8E7F)],
            triggers: {"forward", "left"}, thrusterSize: 30, priority: 5),
        /* Left Mains */
        Thruster(position: Vector2(-105, 80), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F87F8FF), const Color(0x6F3F8E7F)],
            triggers: {"forward", "right"}, thrusterSize: 30, priority: 5),
        /* Left Cold Gas */
        Thruster(position: Vector2(-230, -20), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6F94B0C2), const Color(0x6FF4F4F4)],
            triggers: {"backward", "left"}, thrusterSize: 20),
        /* Right Cold Gas */
        Thruster(position: Vector2(225, -20), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6F94B0C2), const Color(0x6FF4F4F4)],
            triggers: {"backward", "right"}, thrusterSize: 20),
      ],
      "Specialized Vessel" :[
        /* Right Mains */
        Thruster(position: Vector2(110, 240), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F537C44), const Color(0x6FA0B335)],
            triggers: {"forward", "left"}, thrusterSize: 38),
        /* Left Mains */
        Thruster(position: Vector2(-105, 240), direction: Vector2(0, 3), thrust: 4,
            colors: [const Color(0x6F537C44), const Color(0x6FA0B335)],
            triggers: {"forward", "right"}, thrusterSize: 38),
        /* Left Cold Gas */
        Thruster(position: Vector2(-90, -190), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6F87949B), const Color(0x6FD9D9D9)],
            triggers: {"backward", "left"}, thrusterSize: 20, priority: 5),
        /* Right Cold Gas */
        Thruster(position: Vector2(95, -190), direction: Vector2(0, -2), thrust: 2,
            colors: [const Color(0x6F87949B), const Color(0x6FD9D9D9)],
            triggers: {"backward", "right"}, thrusterSize: 20, priority: 5),
      ],

      "Heavy Hauler": <Thruster>[
        /* Right Mains */
        Thruster(position: Vector2(310, 680), direction: Vector2(2, 11.4), thrust: 3,
            colors: [const Color(0x6FFECA74), const Color(0x6FB13E53)],
            triggers: {"forward", "left"}, thrusterSize: 145),
        /* Left Mains */
        Thruster(position: Vector2(-315, 680), direction: Vector2(-2, 11.4), thrust: 3,
            colors: [const Color(0x6FFECA74), const Color(0x6FB13E53)],
            triggers: {"forward", "right"}, thrusterSize: 145),
        /* Right Secondary */
        Thruster(position: Vector2(690, 170), direction: Vector2(7, 11.4), thrust: 1.5,
            colors: [const Color(0x6FFECA74), const Color(0x6FB13E53)],
            triggers: {"forward", "left"}, thrusterSize: 115),
        /* Left Secondary */
        Thruster(position: Vector2(-695, 170), direction: Vector2(-7, 11.4), thrust: 1.5,
            colors: [const Color(0x6FFECA74), const Color(0x6FB13E53)],
            triggers: {"forward", "right"}, thrusterSize: 115),
        /* Left Cold Gas */
        Thruster(position: Vector2(-300, -500), direction: Vector2(0, -2), thrust: 12,
            colors: [const Color(0x6F94B0C2), const Color(0x6FF4F4F4)],
            triggers: {"backward", "left"}, thrusterSize: 60, priority: 5),
        /* Right Cold Gas */
        Thruster(position: Vector2(305, -500), direction: Vector2(0, -2), thrust: 12,
            colors: [const Color(0x6F94B0C2), const Color(0x6FF4F4F4)],
            triggers: {"backward", "right"}, thrusterSize: 60, priority: 5),
      ],

    };

    currentShipThrusters = gameRef.playerData.equippedShip;

    updateThrusters();

  }

  void updateThrusters(){

    thrusters = thrusterMap[currentShipThrusters] ?? [];
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print("In Thrusters Update");
    // print("No. thrusters: ${thrusters.length}");
    if (currentShipThrusters != gameRef.playerData.equippedShip){
      currentShipThrusters = gameRef.playerData.equippedShip;
      updateThrusters();
    }

    // Add particle systems for the thrusters
    if (gameRef.userShip.impulse.x > 0) {
      for (Thruster thruster in thrusters){
        if (thruster.triggers.contains("forward")){
          // print("Shuoudl be thrusting");
          _addParticles(thruster);
        }
      }
    }

    if (gameRef.userShip.impulse.x < 0) {
      for (Thruster thruster in thrusters){
        if (thruster.triggers.contains("backward")){
          _addParticles(thruster);
        }
      }
    }

    if (gameRef.userShip.impulse.y < 0) {
      for (Thruster thruster in thrusters){
        if (thruster.triggers.contains("left")){
          _addParticles(thruster);
        }
      }
    }

    if (gameRef.userShip.impulse.y > 0) {
      for (Thruster thruster in thrusters){
        if (thruster.triggers.contains("right")){
          _addParticles(thruster);
        }
      }
    }
  }


  void _addParticles(Thruster thruster){
    final List<Particle> particles = thruster.colors.map((color) {
      return createAcceleratedParticle(
        position: _calculatePosition(thruster.position),
        size: Vector2.all(thruster.thrusterSize),
        color: color,
        direction: _rotateVector(thruster.direction) * thruster.thrust,
      );
    }).toList();

    gameRef.world.add(
      ParticleSystemComponent(
        anchor: Anchor.center,
        position: gameRef.userShip.position,
        priority: thruster.priority,
        particle: ComposedParticle(
          lifespan: 0.08,
          children: particles,
        ),
      ),
    );
  }


  Particle createAcceleratedParticle({
    required Vector2 position,
    required Vector2 size,
    required Color color,
    required Vector2 direction,
  }) {
    final double velocityFactor = gameRef.userShip.linearVelocity.length / 1600;
    final Vector2 adjustedPosition = position - (size * velocityFactor / 2);
    final Vector2 scaledSize = size * (1 + velocityFactor);

    return AcceleratedParticle(
      position: adjustedPosition + Vector2(0, Random().nextDouble() * 0.2),
      acceleration: direction * (Random().nextDouble() * 100 * 0.8),
      speed: direction * (Random().nextDouble() * 100),
      child: ScalingParticle(
        to: 0.5,
        child: CircleParticle(
          radius: scaledSize.x / 2,
          paint: Paint()..color = color,
        ),
      ),
    );
  }

  Vector2 _calculatePosition(Vector2 offset) {
    final double angle = gameRef.userShip.angle;
    final double cosAngle = cos(angle);
    final double sinAngle = sin(angle);

    final double rotatedX = offset.x * cosAngle - offset.y * sinAngle;
    final double rotatedY = offset.x * sinAngle + offset.y * cosAngle;

    return Vector2(rotatedX, rotatedY);
  }

  Vector2 _rotateVector(Vector2 vector) {
    // Adjust direction based on the user ship angle
    final double angle = gameRef.userShip.angle;
    final double cosAngle = cos(angle);
    final double sinAngle = sin(angle);

    final double rotatedX = vector.x * cosAngle - vector.y * sinAngle;
    final double rotatedY = vector.x * sinAngle + vector.y * cosAngle;

    return Vector2(rotatedX, rotatedY);
  }
}

class Thruster{

  List<Color> colors;

  Set<String> triggers = {};

  Vector2 position;
  Vector2 direction;

  double thrust;
  double thrusterSize;

  int priority;

  Thruster({required this.position,
            required this.direction,
            required this.thrust,
            required this.colors,
            required this.triggers,
            required this.thrusterSize,
            this.priority = 3});



}