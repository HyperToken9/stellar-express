
import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/screens/dashboard_screen.dart';

import 'package:star_routes/states/dashboard_button.dart';

class DashboardButton extends SpriteGroupComponent<DashboardButtonStates> with HasGameRef<StarRoutes>{

  @override
  Future<void> onLoad() async {

    final dashboardButton = await Sprite.load(Assets.menuButton);
    final closeDashboadButton = await Sprite.load(Assets.closeMenuButton);


    double dim = 50;

    size = Vector2(dim, dim);

    Vector2 margin = Vector2(12, 40);
    position.x = gameRef.size.x - margin.x;
    position.y = margin.y;

    anchor = Anchor.topRight;

    current = DashboardButtonStates.dashBoardClosed;

    sprites = {
      DashboardButtonStates.dashBoardClosed: dashboardButton,
      DashboardButtonStates.dashBoardOpen: closeDashboadButton,
    };

    add(
        TappableRegion(
          position: Vector2(0, 0),
          size: size,
          onTap: () {
            print("Dashboard button pressed");
            if (current == DashboardButtonStates.dashBoardClosed) {
              current = DashboardButtonStates.dashBoardOpen;
              game.overlays.add(DashboardScreen.id);
              // gameRef.pauseEngine();
            } else if (current == DashboardButtonStates.dashBoardOpen){
              current = DashboardButtonStates.dashBoardClosed;
              game.overlays.remove(DashboardScreen.id);
              // gameRef.resumeEngine();
            }

          },
          onRelease: () {},
          buttonEnabled: () => true
        )
    );

  }

}