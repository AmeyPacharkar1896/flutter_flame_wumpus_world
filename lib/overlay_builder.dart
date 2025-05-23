import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/game/wumpus_game.dart';
import 'package:wumpus_world_flame/game_overlays/arrow_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/game_message_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/movement_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/percepts_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/transient_message_overlay.dart';

class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder({super.key});

  @override
  State<OverlayBuilder> createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  late final WumpusGame game;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    game = WumpusGame();

    // Wait for game to finish loading before showing overlays
    game.onLoad().then((_) {
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? GameWidget(
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
                (context, game) => MovementOverlay(game: game as WumpusGame),
            'PerceptsOverlay':
                (context, _) =>
                    PerceptsOverlay(percepts: game.getCurrentPercepts()),
            'ArrowOverlay': (context, game) {
              final player = (game as WumpusGame).player;
              return ArrowOverlay(arrowLeft: player?.arrow ?? 0);
            },
            'TransientMessageOverlay':
                (context, _) => TransientMessageOverlay(
                  message: game.transientMessage ?? 'Arrow Status not found',
                ),
          },
          initialActiveOverlays: const [
            'ControlsOverlay',
            'PerceptsOverlay',
            'ArrowOverlay',
          ],
        )
        : const Center(child: CircularProgressIndicator());
  }
}
