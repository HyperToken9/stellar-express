

import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:star_routes/game/star_routes.dart';

class LoadingScreen extends StatefulWidget {

  final StarRoutes game;
  static const String id = "loading";

  /* Pre load image */
  // final image = Image.asset('assets/images/user_interface/title.png');

  AssetImage image = AssetImage('assets/images/user_interface/title.png');

  LoadingScreen({super.key, required this.game});

  @override
  State<LoadingScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    // print("Loading Screen Built");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Load an image
            Container(
              child: Image(
                image: widget.image,
              ),
            ),

            AnimatedProgressBar(),

          ],
        ),
      ),
    );
  }
}


class AnimatedProgressBar extends StatefulWidget {
  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..addListener(() {
      setState(() {});
    });
    _controller!.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: _controller!.value,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_controller!.isAnimating) {
              _controller!.stop();
            } else {
              _controller!.repeat(reverse: false);
            }
          },
          child: Text(_controller!.isAnimating ? 'Pause' : 'Resume'),
        ),
      ],
    );
  }
}
