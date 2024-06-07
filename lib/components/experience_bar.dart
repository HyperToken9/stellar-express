

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:star_routes/controls/dashboard_button.dart';

import 'package:star_routes/game/star_routes.dart';

class ExperienceBar extends PositionComponent with HasGameRef<StarRoutes> {

  late ui.Image barBackground;
  late ui.Image barFill;
  late ui.Image barBorder;
  late Path barMask;

  Paint fillBrush = Paint()..color = const Color(0xFFFFFFFF);
  Paint translucentBrush = Paint()..color = const Color(0xC0FFFFFF);

  double fractionComplete = 0.1;
  int playerLevel = 5;

  @override
  Future<void> onLoad() async {
    barBackground = await gameRef.images.load('user_interface/experience_bar_background.png');
    barBorder = await gameRef.images.load('user_interface/experience_bar_border.png');
    barFill = await gameRef.images.load('user_interface/experience_bar_fill.png');

    size = Vector2(140, 25);
    anchor = Anchor.centerRight;
    position = Vector2(game.size.x, 0)
             - Vector2(DashboardButton.margin.x, -DashboardButton.margin.y - DashboardButton.dim/2)
             - Vector2(50, 0);

    double radius = 4;
    barMask = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.x, size.y),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ));

    playerLevel = game.playerData.getPlayerLevel();
    fractionComplete = game.playerData.getExperienceLevelProgress();


  }

  @override
  void render(Canvas canvas) {

    super.render(canvas);

    canvas.clipPath(barMask);

    /* Draw Bar Background */
    Rect srcRect = Rect.fromLTWH(0, 0, barBackground.width.toDouble(), barBackground.height.toDouble());
    Rect dstRect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawImageRect(barBackground, srcRect, dstRect, translucentBrush);


    double percentage = fractionComplete;

    /* Draw Bar Fill */
    srcRect = Rect.fromLTWH(0, 0, barFill.width.toDouble(), barFill.height.toDouble());
    dstRect = Rect.fromLTWH(0, 0, size.x * percentage, size.y);
    canvas.drawImageRect(barFill, srcRect, dstRect, fillBrush);

    /* Draw Bar Border */
    srcRect = Rect.fromLTWH(0, 0, barBorder.width.toDouble(), barBorder.height.toDouble());
    dstRect = Rect.fromLTWH(0, 0, size.x + 0.2, size.y + 0.2);
    canvas.drawImageRect(barBorder, srcRect, dstRect, fillBrush);

    /* Draw Text */
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'LVL $playerLevel'.toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'AudioWide',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(10, (size.y - textPainter.height)/2));

  }


}