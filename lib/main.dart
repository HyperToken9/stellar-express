
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/screens/dashboard_screen.dart';
import 'package:star_routes/screens/hangar_screen.dart';

import 'package:star_routes/screens/loading_screen.dart';
import 'package:star_routes/screens/main_menu_screen.dart';
import 'package:star_routes/screens/mini_map_screen.dart';

void main() {

  final StarRoutes game = StarRoutes();

  runApp(
    GameWidget(
      game: game,
      loadingBuilder: (context) => LoadingScreen(game: game),
      // initialActiveOverlays: const [MainMenuScreen.id],
      initialActiveOverlays: [DashboardScreen.id],
      overlayBuilderMap: {
        LoadingScreen.id: (context, _) => LoadingScreen(game: game),
        MainMenuScreen.id: (context, _) => MainMenuScreen(game: game),
        MiniMapScreen.id: (context, _) => MiniMapScreen(game: game),
        HangarScreen.id: (context, _) => HangarScreen(game: game),
        DashboardScreen.id: (context, _) => DashboardScreen(game: game),
      },
    ),
  );
}

