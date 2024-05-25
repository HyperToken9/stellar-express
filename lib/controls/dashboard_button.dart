
import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/tappable_region.dart';

import 'package:star_routes/states/dashboard_button.dart';

class DashboardButton extends SpriteGroupComponent<DashboardButtonStates> with HasGameRef<StarRoutes>{

  @override
  Future<void> onLoad() async {

    final dashboardButton = await Sprite.load(Assets.menuButton);
    final exitOrbitButton = await Sprite.load(Assets.menuButton);


    double dim = 70;

    size = Vector2(dim, dim);

    Vector2 margin = Vector2(12, 54);
    position.x = gameRef.size.x - margin.x;
    position.y = margin.y;

    anchor = Anchor.topRight;

    current = DashboardButtonStates.idle;

    sprites = {
      DashboardButtonStates.idle: dashboardButton,
    };

    add(
        TappableRegion(
          position: Vector2(0, 0),
          size: size,
          onTap: () {
            print("Dashboard button pressed");
          },
          onRelease: () {},
          buttonEnabled: () => true
        )
    );

  }

}