
import 'package:flutter/material.dart';
import 'package:star_routes/game/star_routes.dart';


class MessageScreen extends StatefulWidget {
  final StarRoutes game;
  static const String id = "message";

  const MessageScreen({super.key, required this.game});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    widget.game.isShowingMessage = true;
    showMessage(widget.game.overlayDisplayMessage, const Duration(seconds: 3));

  }

  void showMessage(String message, Duration duration) {
    setState(() {
      _message = message;
    });

    _controller.reset();
    _controller.forward();

    Future.delayed(duration, () {
      _controller.reverse().then((_) {
        widget.game.overlayDisplayMessage = '';
        widget.game.overlays.remove(MessageScreen.id);
        widget.game.isShowingMessage = false;
        // print('Message dismissed');
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _message = '';
    print("Trinf to dispose message screen");
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  _message.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'SpaceMono',
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      ),
                    ],

                  ),
                ),
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}