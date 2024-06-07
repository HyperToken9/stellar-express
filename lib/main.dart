

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/screens/dashboard_screen.dart';
import 'package:star_routes/screens/hangar_screen.dart';
import 'package:star_routes/screens/login_screen.dart';
import 'package:star_routes/screens/loading_screen.dart';
import 'package:star_routes/screens/main_menu_screen.dart';
import 'package:star_routes/screens/mini_map_screen.dart';



void main() async {

  // TODO: This is very forced, but no time right now
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setPortraitUpOnly();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final StarRoutes game = StarRoutes();

  runApp(
    GameWidget(
      game: game,
      loadingBuilder: (context) => LoadingScreen(game: game),
      initialActiveOverlays: const [LoginScreen.id],
      // initialActiveOverlays: const [MainMenuScreen.id],
      overlayBuilderMap: {
        LoginScreen.id: (context, _) => LoginScreen(game: game),
        LoadingScreen.id: (context, _) => LoadingScreen(game: game),
        MainMenuScreen.id: (context, _) => MainMenuScreen(game: game),
        MiniMapScreen.id: (context, _) => MiniMapScreen(game: game),
        HangarScreen.id: (context, _) => HangarScreen(game: game),
        DashboardScreen.id: (context, _) => DashboardScreen(game: game),
      },
    ),
  );
}

