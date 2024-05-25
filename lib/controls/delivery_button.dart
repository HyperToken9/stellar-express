
import 'package:flame/components.dart';
import 'package:star_routes/components/cargo_ship.dart';

import 'package:star_routes/game/assets.dart';
import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/states/delivery_button.dart';
import 'package:star_routes/game/tappable_region.dart';

class DeliveryButton extends SpriteGroupComponent<DeliveryButtonStates> with HasGameRef<StarRoutes>{

  Vector2 margin = Vector2(120, 45);
  DeliveryButton() : super(priority: 1);

  @override
  Future<void> onLoad() async {

    final deliveryButton = await Sprite.load(Assets.blankButton);

    double dim = 70;

    size = Vector2(dim, dim);

    position = gameRef.size - margin;

    anchor = Anchor.bottomRight;

    current = DeliveryButtonStates.inactive;
    opacity = 0;

    sprites = {
      DeliveryButtonStates.inactive: deliveryButton,
      DeliveryButtonStates.idle: deliveryButton,
    };

    add(
      TappableRegion(
        position: Vector2(0, 0),
        size: size,
        onTap: () {
          CargoShip cargoShip = CargoShip();
          gameRef.world.add(cargoShip);
        },
        onRelease: () {},
        buttonEnabled: isEnabled,
      )
    );


  }

  void setState(DeliveryButtonStates state){

    if (DeliveryButtonStates.inactive == state){
      opacity = 0;
      current = DeliveryButtonStates.inactive;
    } else {
      opacity = 1;
      current = state;
    }

  }

  bool isEnabled(){

    if (DeliveryButtonStates.inactive == current){
      return false;
    }
    return true;

  }

}