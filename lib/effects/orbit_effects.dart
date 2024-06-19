
import 'dart:math';
import 'dart:ui';
import 'package:flame/extensions.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class OrbitEffects{

  List<Effect> orbitEffect(double duration, double scaleBy, double rotateBy,
                     void Function()? onComplete, Component target){

    Path path = makeOrbitPath();

    path = scalePath(path, scaleBy);
    path = rotatePath(path, rotateBy);

    Effect moveEffect = MoveAlongPathEffect(
      path,
      EffectController(
        duration: duration,
        // speed: 2,
        curve: Curves.easeInOut,
      ),
      onComplete: onComplete,
      oriented: true,
    );

    Effect spritePriorityEffect = SequenceEffect(
        [ ScaleEffect.by(
          Vector2.all(1),
          EffectController(
              duration: duration/3,
          ),
          onComplete: () {
            target.priority = 4;
          }
        ),
          ScaleEffect.by(
              Vector2.all(1),
              EffectController(duration: duration/3),

          ),
          ScaleEffect.by(
            Vector2.all(1),
            EffectController(duration: duration/3),
          ),
        ]
    );

    ScaleEffect scaleEffect = ScaleEffect.by(
      Vector2.all(2),
      EffectController(duration: duration),
    );

    return [moveEffect, spritePriorityEffect];
    return [moveEffect, spritePriorityEffect, scaleEffect];


  }

  List<Effect> deOrbitEffect(double duration, double scaleBy, double rotateBy,
                       void Function()? onComplete, Component target){

    Path path = makeDeOrbitPath();
    path = scalePath(path, scaleBy);
    path = rotatePath(path, rotateBy - atan2(102.033, -106.922) + pi/2);


    Effect moveEffect = MoveAlongPathEffect(
      path,
      EffectController(
        duration: duration,
        // speed: 2,
        curve: Curves.easeInOut,
      ),
      onComplete: onComplete,
      oriented: true,
    );

    Effect spritePriorityEffect = SequenceEffect(
        [ ScaleEffect.by(
          Vector2.all(1),
          EffectController(duration: duration/3),
        ),
          ScaleEffect.by(
              Vector2.all(1),
              EffectController(duration: duration/3),
              onComplete: () {
                target.priority = 1;
              }
          ),
          ScaleEffect.by(
            Vector2.all(1),
            EffectController(duration: duration/3),
          ),
        ]
    );

    return [moveEffect, spritePriorityEffect];
  }

  Path scalePath(Path path, double by)
  {
    Matrix4 scalingMatrix = Matrix4.identity()..scale(by);

    /*Scale Size of Path */
    path = path.transform(scalingMatrix.storage);

    return path;
  }

  Path rotatePath(Path path, double by)
  {
    Matrix4 rotationMatrix = Matrix4.identity()..rotateZ(by);

    /*Scale Size of Path */
    path = path.transform(rotationMatrix.storage);

    return path;
  }

  Path flipPath(Path path)
  {
    Matrix4 flipMatrix = Matrix4.identity()..rotateY(pi);

    return path.transform(flipMatrix.storage);
  }

  // Path makeIntermediateSegment()
  // {
  //   Path path = Path();
  //   path.cubicTo(0, 0, 2.499, -58, 18.999, -95.5); // First Bézier curve
  //   path.cubicTo(35.499, -133, 66.658, -202.609, 84.658, -162.109); // Second Bézier curve
  //   path.cubicTo(98.672, -130.578, 80.464, -35.943, 71.713, 4.425); // Third Bézier curve
  //   path.cubicTo(69.031, 16.794, 64.405, 28.616, 58.297, 39.7); // Fourth Bézier curve
  //   path.lineTo(39.104, 74.532); // Line
  //   path.cubicTo(14.846, 118.556, -30.7678, 146.375, -80.8566, 150.575); // Fifth Bézier curve
  //   path.cubicTo(-84.3525, 150.868, -87.9046, 151.176, -91.5007, 151.5); // Sixth Bézier curve
  //   path.cubicTo(-141.5007, 156, -107.0014, 104.5, -84.5012, 79.5); // Seventh Bézier curve
  //   path.cubicTo(-62.001, 54.5, -1.5, 1, -1.5, 1); // Eighth Bézier curve
  //   return path;
  // }

  Path makeDeOrbitPath(){

    Path path = Path();
    // path.moveTo(-106.922, 102.033);
    // path.cubicTo(-62.7768, 152.277, 8.952, 126.173, 41.962, 68.003);
    // path.lineTo(57.639, 40.378);
    // path.cubicTo(64.18, 28.849, 69.101, 16.519, 71.9, 3.561);
    // path.cubicTo(80.72, -37.278, 98.573, -130.8008, 84.658, -162.109);
    // path.cubicTo(66.658, -202.609, 35.999, -133, 19.499, -95.5);
    // path.cubicTo(2.499, -58, 0, 0, 0, 0);
    path.moveTo(0, 0);
    path.cubicTo(44.1452, 50.244, 115.874, 24.14, 148.884, -34.03);
    path.lineTo(164.561, -61.655);
    path.cubicTo(171.102, -73.184, 176.023, -85.514, 178.922, -98.472);
    path.cubicTo(187.642, -139.311, 205.495, -232.834, 191.58, -264.142);
    path.cubicTo(173.58, -304.642, 142.921, -235.033, 126.421, -197.533);
    path.cubicTo(109.421, -160.033, 106.922, -102.033, 106.922, -102.033);


    /* Normalize Path */
    Offset startPoint = const Offset(-106.922, 102.033);
    Offset endPoint = const Offset(0, 0);
    double pathRadius = (startPoint - endPoint).distance;
    path = OrbitEffects().flipPath(path);
    path = OrbitEffects().scalePath(path, 1/ pathRadius);

    return path;

  }


  Path makeOrbitPath(){
    Path path = Path();
    path.moveTo(0, 0); // Move to the initial point
    path.cubicTo(0, 0, 2.499, -58, 19.499, -95.5);
    path.cubicTo(35.999, -133, 66.658, -202.609, 84.658, -162.109);
    path.cubicTo(98.573, -130.8008, 80.72, -37.278, 71.9, 3.561);
    path.cubicTo(69.101, 16.519, 64.18, 28.849, 57.639, 40.378);
    path.lineTo(41.962, 68.003);
    path.cubicTo(8.952, 126.173, -62.7768, 152.277, -106.922, 102.033);
    // path.cubicTo(-115.515, 92.252, -124.01, 81.126, -132.052, 68.5);
    // path.cubicTo(-159.291, 16.528, -152.1344, -47.536, -113.1234, -92.9966);
    // path.lineTo(-105.6218, -101.5458);
    // path.cubicTo(-48.9858, -166.0918, 51.3652, -166.5182, 108.548, -102.456);
    // path.lineTo(116.7, -93.323);
    // path.cubicTo(128.101, -80.5509, 137.044, -65.783, 143.079, -49.762);
    // path.cubicTo(154.923, -18.322, 154.979, 16.343, 143.237, 47.821);
    // path.lineTo(140.094, 56.248);
    // path.cubicTo(124.544, 99.407, 88.64, 132.169, 44.191, 144.258);
    // path.lineTo(38.345, 145.848);
    // path.cubicTo(-23.8592, 162.766, -89.6912, 135.974, -122.404, 80.429);
    // path.lineTo(-125.8955, 74.5);
    // path.cubicTo(-148.1287, 39.985, -153.7922, -2.653, -141.3438, -41.777);
    // path.lineTo(-140, -46);


    /* Normalize Path */
    Offset startPoint = const Offset(0, 0);
    Offset endPoint = const Offset(-106.922, 102.033);
    double pathRadius = (startPoint - endPoint).distance;

    path = OrbitEffects().scalePath(path, 1/ pathRadius);

    return path;
  }


}