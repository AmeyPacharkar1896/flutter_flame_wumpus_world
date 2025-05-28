import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/game/wumpus_game.dart';
import 'package:wumpus_world_flame/game_overlays/arrow_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/game_message_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/main_menu_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/movement_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/pause_menu_button_overlay.dart';
import 'package:wumpus_world_flame/game_overlays/pause_menu_overlay.dart';
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
  bool showMainMenu = true;
  late Sprite arrow;

  @override
  void initState() {
    super.initState();
    game = WumpusGame();
    game.pauseEngine();

    game.onLoad().then((_) {
      setState(() {
        arrow = game.arrowSprite!;
        loaded = true;
      });
    });
  }

  void startGame() {
    setState(() {
      showMainMenu = false;
    });

    game.reset();
    game.resumeEngine();
    // *** show the very first percept (even if empty) ***
    game.showPerceptsTemporarily();
    game.overlays.addAll([
      'ControlsOverlay',
      'ArrowOverlay',
      'PerceptsOverlay',
      'PauseMenuButtonOverlay',
    ]);
    print('Overlays added: ${game.overlays.toString()}');
  }

  void goToMainMenu() {
    game.reset();
    game.pauseEngine();
    game.overlays.clear();

    setState(() {
      showMainMenu = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Stack(
          children: [
            // Always keep GameWidget in the tree
            Offstage(
              offstage: showMainMenu, // only hide visually
              child: SizedBox.expand(
                child: GameWidget(
                  game: game,
                  overlayBuilderMap: {
                    'GameOverOverlay':
                        (context, _) => GameMessageOverlay(
                          resultMessage: "Game Over!",
                          moves: game.player?.moves ?? 0,
                          arrowsLeft: game.player?.arrow ?? 0,
                          hasGold: game.player?.hasGold ?? false,
                          isDead: game.isPlayerDead(),
                          finalScore: game.calculateScore(),

                          // Add two restart options here
                          onRestartSame: () {
                            game.reset(sameMap: true);
                            game.overlays
                              ..remove('GameOverOverlay')
                              ..addAll([
                                'ControlsOverlay',
                                'ArrowOverlay',
                                'PerceptsOverlay',
                                'PauseMenuButtonOverlay',
                              ]);
                            game.resumeEngine();
                            game.showPerceptsTemporarily();
                          },
                          onRestartNew: () {
                            game.reset(sameMap: false);
                            game.overlays
                              ..remove('GameOverOverlay')
                              ..addAll([
                                'ControlsOverlay',
                                'ArrowOverlay',
                                'PerceptsOverlay',
                                'PauseMenuButtonOverlay',
                              ]);
                            game.resumeEngine();
                            game.showPerceptsTemporarily();
                          },
                        ),

                    'VictoryOverlay':
                        (context, _) => GameMessageOverlay(
                          resultMessage: "You Win!",
                          moves: game.player?.moves ?? 0,
                          arrowsLeft: game.player?.arrow ?? 0,
                          hasGold: game.player?.hasGold ?? false,
                          isDead: game.isPlayerDead(),
                          finalScore: game.calculateScore(),
                          onRestartSame: () {
                            game.reset(sameMap: true);
                            game.overlays
                              ..remove('VictoryOverlay')
                              ..addAll([
                                'ControlsOverlay',
                                'ArrowOverlay',
                                'PerceptsOverlay',
                                'PauseMenuButtonOverlay',
                              ]);
                            game.showPerceptsTemporarily();
                          },
                          onRestartNew: () {
                            game.reset(sameMap: false);
                            game.overlays
                              ..remove('VictoryOverlay')
                              ..addAll([
                                'ControlsOverlay',
                                'ArrowOverlay',
                                'PerceptsOverlay',
                                'PauseMenuButtonOverlay',
                              ]);
                            game.showPerceptsTemporarily();
                          },
                        ),

                    'ControlsOverlay':
                        (context, game) =>
                            MovementOverlay(game: game as WumpusGame),
                    'PerceptsOverlay':
                        (context, _) => PerceptsOverlay(
                          percepts: game.getCurrentPercepts(),
                        ),
                    'ArrowOverlay': (context, game) {
                      final player = (game as WumpusGame).player;

                      return ArrowOverlay(
                        arrowLeft: player?.arrow ?? 0,
                        arrow: arrow,
                      );
                    },
                    'TransientMessageOverlay':
                        (context, _) => TransientMessageOverlay(
                          message:
                              game.transientMessage ?? 'Arrow Status not found',
                          onRemove:
                              () => game.overlays.remove(
                                'TransientMessageOverlay',
                              ),
                        ),

                    'PauseMenuButtonOverlay':
                        (context, _) => PauseMenuButtonOverlay(
                          onPressed: () {
                            game.pauseEngine();
                            game.overlays.add('PauseMenuOverlay');
                          },
                        ),
                    'PauseMenuOverlay':
                        (context, _) => PauseMenuOverlay(
                          onResume: () {
                            game.overlays.remove('PauseMenuOverlay');
                            game.resumeEngine();
                          },
                          onRestart: () {
                            game.reset();
                            game.overlays
                              ..remove('PauseMenuOverlay')
                              ..remove('ControlsOverlay')
                              ..remove('PerceptsOverlay')
                              ..remove('ArrowOverlay')
                              ..remove('PauseMenuButtonOverlay');
                            game.overlays.addAll([
                              'ControlsOverlay',
                              'PerceptsOverlay',
                              'ArrowOverlay',
                              'PauseMenuButtonOverlay',
                            ]);
                            game.resumeEngine();
                            game.showPerceptsTemporarily();
                          },
                          onMainMenu: () {
                            goToMainMenu();
                          },
                        ),
                  },
                  initialActiveOverlays: const [],
                ),
              ),
            ),

            if (showMainMenu) MainMenuOverlay(onStart: startGame),
          ],
        )
        : const Center(child: CircularProgressIndicator());
  }
}
