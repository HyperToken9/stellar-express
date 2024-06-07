import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:star_routes/controls/dashboard_button.dart';
import 'package:star_routes/game/star_routes.dart';

class Balance extends PositionComponent with HasGameRef<StarRoutes> {
  late ui.Image currencyIconShadedLight;
  // late ui.Image currencyIconShadedDark;
  // late ui.Image currencyIconLight;
  // late ui.Image currencyIconDark;

  Paint fillBrush = Paint()..color = const Color(0xFFFFFFFF);

  Vector2 iconRatio = Vector2(4, 5);
  double iconScale = 7.5;

  bool shiftForDash = false;

  @override
  Future<void> onLoad() async {
    currencyIconShadedLight = await gameRef.images.load('user_interface/currency_shaded_light.png');

    size = Vector2(140, 25);
    anchor = Anchor.topRight;

    position = Vector2(gameRef.size.x - DashboardButton.margin.x * 1.8,
        DashboardButton.margin.y + DashboardButton.dim);
  }

  void shiftForDashboard(bool shift) {
    shiftForDash = shift;
    if (shift) {
      anchor = Anchor.topLeft;
      position = Vector2(DashboardButton.margin.x * 2,
                         DashboardButton.margin.y * 1.35);
    } else {
      anchor = Anchor.topRight;
      position = Vector2(gameRef.size.x - DashboardButton.margin.x * 1.8,
                         DashboardButton.margin.y + DashboardButton.dim);
    }
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);

    // Draw Text
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: game.playerData.formattedCoin(),
        style: const TextStyle(
          color: Color(0xE9FFFFFF),
          fontSize: 18,
          fontFamily: 'AudioWide',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Calculate the position of the text and icon dynamically
    double totalWidth = textPainter.width + iconRatio.x * iconScale + 10; // 10 for padding between text and icon
    double startX;
    if (shiftForDash){
      startX = 0;
    }else{
      startX = (size.x - totalWidth);
    }

    // Text offset
    Offset textOffset = Offset(startX, (size.y - textPainter.height) / 2);
    textPainter.paint(canvas, textOffset);

    // Icon offset
    Rect srcRect = Rect.fromLTWH(0, 0, currencyIconShadedLight.width.toDouble(), currencyIconShadedLight.height.toDouble());
    Rect dstRect = Rect.fromLTWH(startX + textPainter.width + 10, (size.y - iconRatio.y * iconScale) / 2,
        iconRatio.x * iconScale, iconRatio.y * iconScale);

    canvas.drawImageRect(currencyIconShadedLight, srcRect, dstRect, fillBrush);
  }
}