import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappy/gen/assets.gen.dart';
import 'package:flappy/src/game/configuration.dart';
import 'package:flappy/src/game/flappy_bird_game.dart';
import 'package:flappy/src/game/pipe_position.dart';
import 'package:flutter/widgets.dart';

class Pipe extends PositionComponent with HasGameRef<FlappyBirdGame> {
  Pipe({
    required this.pipePosition,
    required this.height,
  });

  @override
  final double height;
  final PipePosition pipePosition;

  @override
  Future<void> onLoad() async {
    final pipe = await Flame.images.load(Assets.images.pipe.keyName);
    size = Vector2(50, height);

    switch (pipePosition) {
      case PipePosition.top:
        position.y = 0;
      case PipePosition.bottom:
        position.y = gameRef.size.y - size.y - Config.groundHeight - 2;
    }

    add(RectangleHitbox());
    add(
      ParallaxComponent(
        parallax: Parallax([
          ParallaxLayer(
            ParallaxImage(
              pipe,
              repeat: ImageRepeat.repeatY,
              fill: LayerFill.none,
              alignment: switch (pipePosition) {
                PipePosition.top => Alignment.bottomCenter,
                PipePosition.bottom => Alignment.topCenter,
              },
            ),
          ),
        ]),
      ),
    );
  }
}
