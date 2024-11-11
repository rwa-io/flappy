import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy/src/components/background.dart';
import 'package:flappy/src/components/bird.dart';
import 'package:flappy/src/components/ground.dart';
import 'package:flappy/src/components/pipe_group.dart';
import 'package:flappy/src/game/configuration.dart';
import 'package:flutter/painting.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyBirdGame({
    this.requiredScore,
    this.onSuccess,
  });

  int? requiredScore;
  void Function(int playTimeMs, int points)? onSuccess;

  late Bird bird;
  int? gameStartedTimestamp;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  late TextComponent score;
  @override
  Future<void> onLoad() async {
    FlameAudio.updatePrefix('');
    Flame.images.prefix = '';
    await addAll([
      Background(),
      Ground(),
      bird = Bird(),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup());
  }

  TextComponent buildScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          fontFamily: 'Game',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void onTap() {
    bird.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = 'Score: ${bird.score}';
  }

  void restart({bool? success}) {
    bird.reset();
    gameStartedTimestamp = DateTime.now().millisecondsSinceEpoch;
    removeWhere((component) => component is PipeGroup);
    overlays
      ..remove('gameOver')
      ..remove('success');
    resumeEngine();
  }
}
