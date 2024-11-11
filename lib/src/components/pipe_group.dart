import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy/gen/assets.gen.dart';
import 'package:flappy/src/components/pipe.dart';
import 'package:flappy/src/game/configuration.dart';
import 'package:flappy/src/game/flappy_bird_game.dart';
import 'package:flappy/src/game/pipe_position.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = _random.nextDouble() * 100 + 180;
    final centerY =
        _random.nextDouble() * (heightMinusGround - 2 * spacing) + spacing;

    await addAll([
      Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 2),
      Pipe(
        pipePosition: PipePosition.bottom,
        height: heightMinusGround - (centerY + spacing / 2),
      ),
    ]);
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.audio.point);

    final requiredScore = gameRef.requiredScore;

    if (requiredScore != null && requiredScore <= gameRef.bird.score) {
      gameRef.overlays.add('success');
      final startedAt = gameRef.gameStartedTimestamp;
      final playTimeMs = startedAt == null
          ? 0
          : DateTime.now().millisecondsSinceEpoch - startedAt;
      gameRef.onSuccess?.call(playTimeMs, requiredScore);
      gameRef
        ..requiredScore = null
        ..onSuccess = null
        ..pauseEngine();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -50) {
      removeFromParent();
      updateScore();
    }
  }
}
