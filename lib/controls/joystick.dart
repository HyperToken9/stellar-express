

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';

class Joystick extends JoystickComponent {
  @override
  final StarRoutes game;
  // bool isActive = true;

  Joystick({required this.game}) : super(
    background: CircleComponent(radius: 75, paint: Paint()..color = const Color(0xFF1D1D1D).withAlpha(210)),
    knob: CircleComponent(radius: 30, paint: Paint()..color = const Color(0xE6797979).withAlpha(210)),
    margin: const EdgeInsets.only(left: 50, bottom: 60),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(100, 100);
    /*Print parent component */
    // print("Parent Component ${parent}");
  }

  void onChange(){
    Vector2 impulse = (delta.normalized() * intensity)..rotate(pi/2 - game.userShip.angle);
    // impulse = Vector2(1, 0);
    game.userShip.setImpulse(impulse);
  }

  @override
  void update(double dt){
    super.update(dt);
    onChange();
  }

  void setState(bool state){
    if (!state){
      print("Trying to remove Joystick");
    }
    // print("Parent Component ${parent}");
    if (state && !game.camera.viewport.children.contains(this)){
      game.camera.viewport.add(this);
    } else if (!state && game.camera.viewport.children.contains(this)){
      game.camera.viewport.remove(this);
      // print("Removed Joystick");
    }


  }


}