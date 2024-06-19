
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/screens/login_screen.dart';

import 'package:star_routes/screens/main_menu_screen.dart';

import 'package:star_routes/services/authentication.dart';

class OptionsScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "options";

  const OptionsScreen({super.key, required this.game});

  @override
  State<OptionsScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<OptionsScreen> {

  /* Authentication */
  final Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 45.0, 0.0, 0.0),

            child: Row(
              children: [
                TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
                      minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      widget.game.overlays.remove(OptionsScreen.id);
                      widget.game.overlays.add(MainMenuScreen.id);
                    },
                    child: Image.asset(
                      "assets/images/user_interface/back_button_icon.png",
                      scale: 1,
                      fit: BoxFit.contain,
                    )

                ),
                const SizedBox(width: 10),
                Text(
                  'Options'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              // color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
                      minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      _authentication.signOut();
                      widget.game.overlays.remove(OptionsScreen.id);
                      widget.game.overlays.add(LoginScreen.id);
                    },
                    child: Image.asset('assets/images/user_interface/sign_out_button.png'),
                  )
                ],
              ),
            )

          ),
        ],
      ),
    );
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.game.overlays.remove(OptionsScreen.id);
    widget.game.overlays.add(MainMenuScreen.id);
    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(myInterceptor);

  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


}
