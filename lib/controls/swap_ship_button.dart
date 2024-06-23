
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:star_routes/data/space_ship_data.dart';
import 'package:star_routes/data/space_ship_state.dart';

import 'package:star_routes/effects/orbit_effects.dart';

import 'package:star_routes/components/planet.dart';
import 'package:star_routes/game/priorities.dart';

import 'package:star_routes/game/star_routes.dart';
import 'package:star_routes/game/tappable_region.dart';
import 'package:star_routes/game/assets.dart';
import 'package:star_routes/states/delivery_button.dart';
import 'package:star_routes/states/orbit_button.dart';

import 'package:star_routes/states/swap_ship_button.dart';

class SwapShipButton extends SpriteGroupComponent<SwapShipButtonStates> with HasGameRef<StarRoutes> {


  late Planet planetComponent;
  bool effectComplete = false;
  SwapShipButton() : super(priority: 1);

  @override
  Future<void> onLoad() async {

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
            // print("Swapping Ship");
            effectComplete = false;
            for (SpaceShipData shipData in SpaceShipData.spaceShips) {
              SpaceShipState? shipState = game.playerData.spaceShipStates[shipData.shipClassName];
              if (shipState == null || !shipState.isOwned || shipState.isEquipped || shipState.dockedAt != planetComponent.planetData.planetName) {
                continue;
              }

              // print("Swapping Ship from ${game.playerData.equippedShip} to ${shipData.shipClassName}");

              game.userShip.cargo.priority = Priorities.aheadPlanet1;

              double orbitRotateByAngle = atan2(game.userShip.position.y - game.userShip.orbitCenter.y,
                  game.userShip.position.x - game.userShip.orbitCenter.x);

              onDeOrbitComplete() async {
                SpaceShipState oldShipState = game.playerData.spaceShipStates[game.playerData.equippedShip]!;
                oldShipState.dockedAt = planetComponent.planetData.planetName;
                oldShipState.isEquipped = false;

                shipState.dockedAt = "";
                shipState.isEquipped = true;
                game.userShip.spaceShipData = shipData;
                await game.userShip.loadNewShip(atPosition: planetComponent.position);

                // print("New ship loaded");
                print("Ship Start Size: ${game.userShip.scaledSize}");
                print("Strat Size: ${game.userShip.size}");
                final List<Effect> orbitEffect = OrbitEffects().orbitEffect(10, game.userShip.orbitRadius, 0, () {
                  print("Orbit Complete");
                  game.userShip.insertIntoOrbit();
                  game.userShip.applyPhysics = true;
                  game.userShip.offsetAngle = 0;
                  game.userShip.cargo.offsetAngle = 0;
                  game.userShip.detectShipSwapping(planetComponent);
                  game.userShip.detectCargoDelivery(planetComponent);
                  game.orbitButton.setState(OrbitButtonStates.exitOrbitIdle);
                  effectComplete = true;
                  game.userShip.size = Vector2(game.userShip.spaceShipData.spriteSize[0].toDouble(),
                                                      game.userShip.spaceShipData.spriteSize[1].toDouble());
                  // print("Ship End Size: ${game.userShip.scaledSize}");
                  print("Final Scale: ${game.userShip.scale}");
                  print("Final Size: ${game.userShip.size}");

                }, game.userShip, game.userShip.cargo);
                print("Insiital Sale: ${game.userShip.scale}");
                // game.userShip.scale /= 2;
                game.userShip.applyPhysics = false;
                game.userShip.offsetAngle = -pi / 2;
                game.userShip.cargo.offsetAngle = -pi / 2;

                // print("Ship Offset Angle: ${game.userShip.offsetAngle}");
                // print("Cargo Offset Angle: ${game.userShip.cargo.offsetAngle}");

                game.userShip.addAll(orbitEffect);
                // game.userShip.add(s)

              }

              game.swapShipButton.setState(SwapShipButtonStates.inactive);
              game.orbitButton.setState(OrbitButtonStates.inactive);
              game.deliveryButton.setState(DeliveryButtonStates.inactive);

              final List<Effect> deOrbitingEffect = OrbitEffects().deOrbitEffect(10, game.userShip.orbitRadius, orbitRotateByAngle,
                  onDeOrbitComplete, game.userShip, game.userShip.cargo);

              game.userShip.applyPhysics = false;
              game.userShip.offsetAngle = -pi / 2;
              game.userShip.cargo.offsetAngle = -pi / 2;
              // print("is in ship ${game.userShip.cargo.isInUserShip}");
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