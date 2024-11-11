import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy/gen/assets.gen.dart';
import 'package:flappy/src/game/bird_movement.dart';
import 'package:flappy/src/game/configuration.dart';
import 'package:flappy/src/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  double velocity = 0;

  @override
  Future<void> onLoad() async {
    final birdMidFlap =
        await gameRef.loadSprite(Assets.images.birdMidflap.keyName);
    final birdUpFlap =
        await gameRef.loadSprite(Assets.images.birdUpflap.keyName);
    final birdDownFlap =
        await gameRef.loadSprite(Assets.images.birdDownflap.keyName);

    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity = min(50, velocity + Config.gravity * 0.1);
    position.y += velocity * 0.2;
    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    velocity = -Config.gravity * 2.5;
    add(
      MoveByEffect(
        Vector2(0, -Config.gravity * 2.5),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    FlameAudio.play(Assets.audio.fly);
    current = BirdMovement.up;
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
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    velocity = 0;
    score = 0;
  }

  void gameOver() {
    FlameAudio.play(Assets.audio.collision);
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }
}
