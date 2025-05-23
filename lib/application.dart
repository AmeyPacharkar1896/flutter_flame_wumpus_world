import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/game/wumpus_game.dart';
import 'package:wumpus_world_flame/game_overlays/game_message_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/moment_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/percepts_overlay.dart';

class Application extends StatelessWidget {
  Application({super.key});

  final game = WumpusGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: {
        'GameOverOverlay':
            (context, _) => GameMessageOverlay(
              message: "Game Over!",
              onReset: () {
                game.reset();
                game.overlays.remove('GameOverOverlay');
              },
            ),
        'VictoryOverlay':
            (context, _) => GameMessageOverlay(
              message: 'You Win!',
              onReset: () {
                game.reset();
                game.overlays.remove('VictoryOverlay');
              },
            ),
        'ControlsOverlay':
            (context, game) => MovemenentOverlay(game: game as WumpusGame),
        'PerceptsOverlay':
            (context, _) =>
                PerceptsOverlay(percepts: game.getCurrentPercepts()),
      },
      initialActiveOverlays: const ['ControlsOverlay', 'PerceptsOverlay'],
    );
  }
}
