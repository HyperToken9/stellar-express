

import 'package:flame/components.dart';

class ExperienceBar extends PositionComponent {


  ExperienceBar() {
    size = Vector2(200, 20);
    anchor = Anchor.topRight;
    position = Vector2(0, 0);
  }

  @override
  Future<void> onLoad() async {
    // sprite = await Sprite.load('experience_bar.png');
  }
}