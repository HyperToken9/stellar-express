
import 'package:flame/components.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/screens/dashboard_screen.dart';

import 'package:star_routes/states/dashboard_button.dart';

class DashboardButton extends SpriteGroupComponent<DashboardButtonStates> with HasGameRef<StarRoutes>{


  void setState(bool isDashboardOpen){
    if (isDashboardOpen){
      current = DashboardButtonStates.dashBoardOpen;
      game.overlays.add(DashboardScreen.id);
      game.miniMap.setState(false);
      game.balance.shiftForDashboard(true);

    } else {
      current = DashboardButtonStates.dashBoardClosed;
      game.overlays.remove(DashboardScreen.id);
      game.miniMap.setState(true);
      game.balance.shiftForDashboard(false);

    }
  }

  static Vector2 margin = Vector2(12, 40);
  static double dim = 50;
  @override
  Future<void> onLoad() async {

    final dashboardButton = await Sprite.load(Assets.menuButton);
    final closeDashboardButton = await Sprite.load(Assets.closeMenuButton);


    size = Vector2(dim, dim);

    position.x = gameRef.size.x - margin.x;
    position.y = margin.y;

    anchor = Anchor.topRight;

    current = DashboardButtonStates.dashBoardClosed;

    sprites = {
      DashboardButtonStates.dashBoardClosed: dashboardButton,
      DashboardButtonStates.dashBoardOpen: closeDashboardButton,
    };

    add(
        TappableRegion(
          position: Vector2(0, 0),
          size: size,
          onTap: () {
            print("Dashboard button pressed");
            if (current == DashboardButtonStates.dashBoardClosed) {
              setState(true);

              // gameRef.pauseEngine();
            } else if (current == DashboardButtonStates.dashBoardOpen){
              setState(false);

              // gameRef.resumeEngine();
            }

          },
          onRelease: () {},
          buttonEnabled: () => true
        )
    );

  }

}