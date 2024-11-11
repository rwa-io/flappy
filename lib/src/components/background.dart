import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy/gen/assets.gen.dart';
import 'package:flappy/src/game/flappy_bird_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background =
        await Flame.images.load(Assets.images.background.keyName);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
