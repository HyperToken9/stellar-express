

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart';

import 'package:star_routes/screens/blank_screen.dart';
import 'package:star_routes/screens/options_screen.dart';
import 'package:star_routes/screens/dashboard_screen.dart';
import 'package:star_routes/screens/hangar_screen.dart';
import 'package:star_routes/screens/login_screen.dart';
import 'package:star_routes/screens/loading_screen.dart';
import 'package:star_routes/screens/main_menu_screen.dart';
import 'package:star_routes/screens/mini_map_screen.dart';
import 'package:star_routes/screens/message_screen.dart';

import 'package:star_routes/game/star_routes.dart';

import 'package:star_routes/data/player_data.dart';



void main() async {

  /* Today's Date if more than 25 June 2023 do not open the app */
  // DateTime today = DateTime.now();
  // DateTime lastDate = DateTime(2023, 6, 25);
  // if (today.isAfter(lastDate)){
  //   return;
  // }

  WidgetsFlutterBinding.ensureInitialized();
  // TODO: This is very forced, but no time right now
  Flame.device.setPortraitUpOnly();

  await Hive.initFlutter();
  await Hive.openBox('playerData');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final PlayerData playerData = PlayerData();
  final StarRoutes game = StarRoutes(playerData: playerData);

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GameApp(game: game),
      )
      // )GameApp(game: game),
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
        OptionsScreen.id: (context, _) => OptionsScreen(game: game),
        MessageScreen.id: (context, _) => MessageScreen(game: game),
      },
    );
  }

}

