
import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:provider/provider.dart';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:star_routes/screens/blank_screen.dart';
import 'package:star_routes/services/authentication.dart';
import 'firebase_options.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/screens/dashboard_screen.dart';
import 'package:star_routes/screens/hangar_screen.dart';
import 'package:star_routes/screens/login_screen.dart';
import 'package:star_routes/screens/loading_screen.dart';
import 'package:star_routes/screens/main_menu_screen.dart';
import 'package:star_routes/screens/mini_map_screen.dart';

import 'package:star_routes/data/player_data.dart';

final StreamController<PlayerData> _playerDataController = StreamController<PlayerData>();

final PlayerData playerData = PlayerData();

Stream<PlayerData> getPlayerDataStream() {
  // Add the initial PlayerData to the stream
  print("Streaming");
  _playerDataController.add(playerData);
  return _playerDataController.stream;
}


void main() async {

  // TODO: This is very forced, but no time right now
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setPortraitUpOnly();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final StarRoutes game = StarRoutes(playerData: playerData);

  runApp(
      GameApp(game: game),
  );
}

class GameApp extends StatefulWidget {

  final StarRoutes game;

  const GameApp({super.key, required this.game});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {

  @override
  Widget build(BuildContext context) {
    final StarRoutes game = widget.game;
    return GameWidget(
      game: game,
      loadingBuilder: (context) => LoadingScreen(game: game),
      initialActiveOverlays: const [LoginScreen.id],
      overlayBuilderMap: {
        LoginScreen.id: (context, _) => LoginScreen(game: game),
        LoadingScreen.id: (context, _) => LoadingScreen(game: game),
        MainMenuScreen.id: (context, _) => MainMenuScreen(game: game),
        MiniMapScreen.id: (context, _) => MiniMapScreen(game: game),
        HangarScreen.id: (context, _) => HangarScreen(game: game),
        DashboardScreen.id: (context, _) => DashboardScreen(game: game),
        BlankScreen.id: (context, _) => BlankScreen(game: game),
      },
    );
  }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //
  //   if (widget.game.overlays.count) {
  //     widget.game.overlays.clear();
  //     return true;
  //   }
  //
  //   return true;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   BackButtonInterceptor.add(myInterceptor);
  // }
  //
  // @override
  // void dispose() {
  //
  //
  //   BackButtonInterceptor.remove(myInterceptor);
  //
  //   super.dispose();
  // }

}



