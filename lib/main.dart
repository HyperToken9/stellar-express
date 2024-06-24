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
  WidgetsFlutterBinding.ensureInitialized();
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
      home: SplashScreen(game: game),
    ),
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

class SplashScreen extends StatefulWidget {
  final StarRoutes game;

  const SplashScreen({super.key, required this.game});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await widget.game.onLoad();
    await Future.delayed(const Duration(seconds: 5)); // Delay for 5 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameApp(game: widget.game)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set your splash screen background color
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo.png',
          width: 320,
        ), // Set your splash screen image
      ),
    );
  }
}
