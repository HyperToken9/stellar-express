
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String backgroundImage;
  final String iconImage;
  final String text;
  final VoidCallback onPressed;

  const Button({
    super.key,
    required this.backgroundImage,
    required this.iconImage,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    BorderRadius buttonShape = const BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(2),
      bottomLeft: Radius.circular(2),
    );

    return FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
             RoundedRectangleBorder(borderRadius: buttonShape),
          ),
          /*White base background */
          backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          /*Gradient Background */
          backgroundBuilder: (BuildContext context, Set<WidgetState> state, Widget? child) {
            return Container(
              /*Round the container */
              width: 280,
              // height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFFFFFF),
                  width: 2,
                ),
                borderRadius: buttonShape,
                gradient: const LinearGradient(
                  colors: <Color>[
                    /*84E07C to 396534*/
                    Color(0xA884E07C),
                    Color(0xA8396534),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,

                ),
              ),

              child: child,
            );
          },

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/user_interface/google_play_icon.png',
              // alignment: Alignment.centerLeft,
            ),
            /* 2 Text elements with different fonts "Sign in with" + "Play Games" in one line Text Span */
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Sign in with ',
                    style: TextStyle(
                      color: Color(0xFF121721),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                  TextSpan(
                    text: 'Play Games',
                    style: TextStyle(
                      color: Color(0xFF121721),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AudioWide',
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),



          ],
        ),

    );
  }
}