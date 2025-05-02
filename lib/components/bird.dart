import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import 'package:sky_quest/game/assets.dart';
import 'package:sky_quest/game/bird_movement.dart';
import 'package:sky_quest/game/config.dart';
import 'package:sky_quest/game/flappy_game.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  @override
  Future<void> onLoad() async {
    final birdMid = await game.loadSprite(Assets.birdMidFlap);
    final birdUp = await game.loadSprite(Assets.birdUpFlap);
    final birdDown = await game.loadSprite(Assets.birdDownFlap);

    size = Vector2(50, 40);
    position = Vector2(50, game.size.y / 2 - size.y / 2);

    sprites = {
      BirdMovement.middle: birdMid,
      BirdMovement.up: birdUp,
      BirdMovement.down: birdDown,
    };

    current = BirdMovement.middle;

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Config.birdVelocity * dt;

    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, -Config.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    current = BirdMovement.up;
    FlameAudio.play(Assets.flying);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void reset() {
    position = Vector2(50, game.size.y / 2 - size.y / 2);
    score = 0;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    game.isCollided = true;
    game.overlays.add('gameOver');
    game.pauseEngine();
  }
}
