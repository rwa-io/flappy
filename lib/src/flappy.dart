import 'package:flame/game.dart';
import 'package:flappy/src/game/flappy_bird_game.dart';
import 'package:flappy/src/screens/main_menu_screen.dart';
import 'package:flappy/src/types/overlay_builder.dart';

class Flappy extends GameWidget<FlappyBirdGame> {
  Flappy({
    required OverlayBuilder successOverlayBuilder,
    required OverlayBuilder failOverlayBuilder,
    int? requiredScore,
    void Function(int playTimeMs, int points)? onSuccess,
    super.key,
  }) : super(
          game: FlappyBirdGame(
            requiredScore: requiredScore,
            onSuccess: onSuccess,
          ),
          initialActiveOverlays: const [MainMenuScreen.id],
          overlayBuilderMap: {
            'mainMenu': (context, game) => MainMenuScreen(game: game),
            'gameOver': (context, game) =>
                failOverlayBuilder(context, game.restart),
            'success': (context, game) =>
                successOverlayBuilder(context, game.restart),
          },
        );
}
