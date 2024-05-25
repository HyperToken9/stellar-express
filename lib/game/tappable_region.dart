

import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';

class TappableRegion extends PositionComponent with TapCallbacks {

  TappableRegion({
    required Vector2 position,
    required Vector2 size,
    required this.onTap,
    required this.onRelease,
    required this.buttonEnabled,
  }) : super(position: position, size: size);

  final VoidCallback onTap;
  final VoidCallback onRelease;
  final bool Function() buttonEnabled;


  @override
  void onTapDown(TapDownEvent event){
    if (buttonEnabled()){
      onTap();
    }
  }

  @override
  void onTapCancel(TapCancelEvent event){
    if (buttonEnabled()){
      onRelease();
    }
  }

  @override
  void onTapUp(TapUpEvent event){
    if (buttonEnabled()){
      onRelease();
    }
  }

  /*Give it a translucent green on render*/
  // @override
  // void render(Canvas canvas){
  //   Paint paint = Paint()..color = const Color(0x4000FF00);
  //   canvas.drawRect(size.toRect(), paint);
  // }

}