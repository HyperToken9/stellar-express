
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/space_ship_state.dart';

import 'package:star_routes/effects/orbit_effects.dart';

import 'package:star_routes/components/planet.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/game/assets.dart';

import 'package:star_routes/states/swap_ship_button.dart';

class SwapShipButton extends SpriteGroupComponent<SwapShipButtonStates> with HasGameRef<StarRoutes> {


  late Planet planetComponent;

  SwapShipButton() : super(priority: 1);

  @override
  Future<void> onLoad() async {

    // final enterOrbitButton = await Sprite.load(Assets.enterOrbitButton);
    // final exitOrbitButton = await Sprite.load(Assets.exitOrbitButton);
    final swapShipButton = await Sprite.load(Assets.swapShipButton);

    double dim = 50;
    Vector2 margin = Vector2(45, 220);
    size = Vector2(dim, dim);

    position = gameRef.size - margin;

    anchor = Anchor.bottomRight;

    current = SwapShipButtonStates.inactive;
    opacity = 0;

    sprites = {
      SwapShipButtonStates.idle: swapShipButton,
      SwapShipButtonStates.inactive: swapShipButton,
    };

    add(
        TappableRegion(
          position: Vector2(0, 0),
          size: size,
          onTap: () {
            print("Swapping Ship");
            for (SpaceShipData shipData in SpaceShipData.spaceShips){
              SpaceShipState? shipState = game.playerData.spaceShipStates[shipData.shipClassName];
              // print("Ship State: ${shipState}");

              if (shipState == null){
                continue;
              }
              if (!shipState.isOwned){
                continue;
              }
              // print("Equipped: ${shipState.isEquipped}");
              if (shipState.isEquipped){
                continue;
              }

              if (shipState.dockedAt != planetComponent.planetData.planetName){
                continue;
              }
              print("Swapping Ship from ${game.playerData.equippedShip} to ${shipData.shipClassName}");

              /* Land Current Ship */


              double orbitRotateByAngle = atan2(game.userShip.position.y - game.userShip.orbitCenter.y,
                  game.userShip.position.x - game.userShip.orbitCenter.x);

              onDeOrbitComplete() {


                /* Unequipped Old ship */
                SpaceShipState oldShipState = game.playerData.spaceShipStates[game.playerData.equippedShip]!;
                oldShipState.dockedAt = planetComponent.planetData.planetName;
                oldShipState.isEquipped = false;

                // game.userShip.position = planetComponent.position;

                /* Equipping New Ship */
                shipState.dockedAt = "";
                shipState.isEquipped = true;
                // game.playerData.equippedShip = shipData.shipClassName;
                game.userShip.spaceShipData = shipData;
                game.userShip.loadNewShip(atPosition: planetComponent.position);

                print("Ship Position: ${game.userShip.position}");

                /* Orbit New Ship*/
                final List<Effect> orbitEffect = OrbitEffects()
                    .orbitEffect(10, game.userShip.orbitRadius, 0, (){
                  /* Reset Physics */
                  game.userShip.insertIntoOrbit();
                  game.userShip.applyPhysics = true;
                  game.userShip.offsetAngle = 0;

                  gameRef.userShip.detectShipSwapping(planetComponent);
                }, game.userShip);

                game.userShip.addAll(orbitEffect);


              }
              gameRef.swapShipButton.setState(SwapShipButtonStates.inactive);
              final List<Effect> deOrbitingEffect = OrbitEffects()
                  .deOrbitEffect(10, game.userShip.orbitRadius, orbitRotateByAngle,
                                 onDeOrbitComplete, game.userShip);

              game.userShip.applyPhysics = false;
              game.userShip.offsetAngle = - pi / 2;


              game.userShip.addAll(deOrbitingEffect);

              break;



            }
          },
          onRelease: () {},
          buttonEnabled: isEnabled,
        )
    );
  }

  void setState(SwapShipButtonStates state){

    if (SwapShipButtonStates.inactive == state){
      opacity = 0;
      current = SwapShipButtonStates.inactive;
    } else {
      opacity = 1;
      current = state;
    }

  }

  bool isEnabled() {
    if (current == SwapShipButtonStates.inactive) {
      return false;
    }
    return true;
  }

  /* Render Translucent Green */
  // @override
  // void render(Canvas canvas) {
    // canvas.drawRect(size.toRect(), Paint()..color = const Color(0x6600FF00));
    // super.render(canvas);
  // }

}