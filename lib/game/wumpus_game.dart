import 'dart:async' as async;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/game/world_generator.dart';
import 'package:wumpus_world_flame/game/player_component.dart';
import 'package:wumpus_world_flame/models/room_model.dart';
import 'package:wumpus_world_flame/game/arrow_component.dart';
import 'package:wumpus_world_flame/utils/directions_util.dart';

class WumpusGame extends FlameGame {
  PlayerComponent? player; // made nullable
  late List<List<RoomModel>> grid;
  String? transientMessage;
  bool gameStarted = false;
  async.Timer? _perceptTimer;

  static const int gridsize = 4;

  ArrowComponent? activeArrow;

  bool isGameLoaded = false; // flag to track loading

  //sprites
  Sprite? roomSprite;
  Sprite? goldSprite;
  Sprite? pitSprite;
  Sprite? arrowSprite;
  Sprite? playerSprite;
  Sprite? wumpusSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- ASSET LOADING ---
    roomSprite ??= await loadSprite('tiles/room.png');
    goldSprite ??= await loadSprite('props/gold.png');
    pitSprite ??= await loadSprite('props/pit.png');
    arrowSprite ??= await loadSprite('props/arrow.png');
    playerSprite ??= await loadSprite('sprites/player_idle.png');
    wumpusSprite ??= await loadSprite('sprites/wumpus_idle.png');

    // --- END ASSET LOADING ---

    if (gameStarted) {
      initializeGameWorld();
    }
  }

  void initializeGameWorld() {
    // Initialize a 4x4 grid of rooms
    grid = List.generate(gridsize, (x) {
      return List.generate(gridsize, (y) => RoomModel(x, y));
    });

    // Populate the world with hazards, gold, percepts
    generateWorld(grid);

    player = PlayerComponent(startX: 0, startY: 0);
    add(player!);

    grid[0][0].isVisible = true;

    isGameLoaded = true; // mark game as loaded
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    const int gridSize = 4;
    final double roomSize =
        size.x < size.y ? size.x / gridSize : size.y / gridSize;
    final double offsetX = (size.x - roomSize * gridSize) / 2;
    final double offsetY = (size.y - roomSize * gridSize) / 2 - 70;

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final room = grid[x][y];
        final dx = offsetX + x * roomSize;
        final dy = offsetY + y * roomSize;
        final rect = Rect.fromLTWH(dx, dy, roomSize, roomSize);

        // 1) draw the room background for every cell
        roomSprite?.render(
          canvas,
          position: Vector2(dx, dy),
          size: Vector2(roomSize, roomSize),
        );

        if (!room.isVisible) {
          // 2) if hidden, draw a dark overlay
          Paint p = Paint()..color = Colors.black.withOpacity(0.8);
          canvas.drawRect(rect, p);
          continue;
        }

        // 3) if this is the player’s cell, tint it or draw a highlight
        if (player != null && x == player!.gridX && y == player!.gridY) {
          Paint p = Paint()..color = Colors.greenAccent.withOpacity(0.4);
          canvas.drawRect(rect, p);
        }

        // 4) draw gold/pit/wumpus if present
        if (room.hasGold) {
          goldSprite?.render(
            canvas,
            position: Vector2(dx + roomSize * 0.2, dy + roomSize * 0.2),
            size: Vector2(roomSize * 0.6, roomSize * 0.6),
          );
        }
        if (room.hasPit) {
          pitSprite?.render(
            canvas,
            position: Vector2(dx + roomSize * 0.2, dy + roomSize * 0.2),
            size: Vector2(roomSize * 0.6, roomSize * 0.6),
          );
        }
        if (room.hasWumpus) {
          wumpusSprite?.render(
            canvas,
            position: Vector2(dx + roomSize * 0.1, dy + roomSize * 0.1),
            size: Vector2(roomSize * 0.8, roomSize * 0.8),
          );
        }
      }
    }

    // 5) draw the player sprite on top last
    if (player != null) {
      playerSprite?.render(
        canvas,
        position: Vector2(
          offsetX + player!.gridX * roomSize + roomSize * 0.1,
          offsetY + player!.gridY * roomSize + roomSize * 0.1,
        ),
        size: Vector2(roomSize * 0.8, roomSize * 0.8),
      );
    }
  }

  void movePlayer(int dx, int dy) {
    if (player == null) return; // safe guard

    int newX = player!.gridX + dx;
    int newY = player!.gridY + dy;

    if (newX < 0 || newX >= gridsize || newY < 0 || newY >= gridsize) {
      debugPrint("Blocked: Wall");
      return;
    }

    player!.moveBy(dx, dy);
    RoomModel room = grid[player!.gridX][player!.gridY];

    // Reveal the room
    room.isVisible = true;
    showPerceptsTemporarily();

    if (room.hasPit || room.hasWumpus) {
      overlays.add('GameOverOverlay');
      pauseEngine();
      return;
    }

    if (room.hasGold) {
      room.hasGold = false;
      overlays.add('VictoryOverlay');
      pauseEngine();
    }
  }

  void reset() {
    try {
      grid = List.generate(
        gridsize,
        (x) => List.generate(gridsize, (y) => RoomModel(x, y)),
      );
      generateWorld(grid);

      if (player?.parent != null) remove(player!);
      player = PlayerComponent(startX: 0, startY: 0);
      add(player!);

      grid[0][0].isVisible = true;

      transientMessage = null;
      _perceptTimer?.cancel();
      isGameLoaded = true; // mark game loaded after reset
      resumeEngine();
      showPerceptsTemporarily();
    } catch (e, stacktrace) {
      debugPrint("Game reset failed: $e\n$stacktrace");
    }
  }

  List<String> getCurrentPercepts() {
    if (!isGameLoaded || grid.isEmpty || player == null) return [];
    final room = grid[player!.gridX][player!.gridY];
    return room.percepts.toList();
  }

  void showPerceptsTemporarily() {
    // 1) Cancel any pending hide-timer
    _perceptTimer?.cancel();

    // 2) Remove the overlay immediately
    overlays.remove('PerceptsOverlay');

    // 3) Schedule re-adding it on the next frame:
    Future.delayed(Duration.zero, () {
      // Add the overlay back in
      overlays.add('PerceptsOverlay');

      // 4) Start the 3-second timer to hide it again
      _perceptTimer = async.Timer(const Duration(seconds: 3), () {
        overlays.remove('PerceptsOverlay');
      });
    });
  }

  // Animate arrow flying one tile at a time, shooting in direction dir
  Future<void> shootArrow(Direction dir) async {
    if (player == null) return;
    if (player!.arrow <= 0) {
      // note property name arrows, update if different in your PlayerComponent
      showTransientMessage("No arrows left!");
      return;
    }
    player!.arrow--;
    showTransientMessage("Arrow shot! Arrows left: ${player!.arrow}");

    int x = player!.gridX;
    int y = player!.gridY;

    while (true) {
      switch (dir) {
        case Direction.up:
          y -= 1;
          break;
        case Direction.down:
          y += 1;
          break;
        case Direction.left:
          x -= 1;
          break;
        case Direction.right:
          x += 1;
          break;
      }

      if (x < 0 || x >= gridsize || y < 0 || y >= gridsize) {
        showTransientMessage("Arrow missed!");
        break;
      }

      final room = grid[x][y];
      if (room.hasWumpus) {
        room.hasWumpus = false;
        showTransientMessage("Wumpus killed! You win!");
        overlays.add("VictoryOverlay");
        pauseEngine();
        break;
      }

      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void showTransientMessage(String message) {
    transientMessage = message;
    overlays.add('TransientMessageOverlay');

    Future.delayed(const Duration(seconds: 2), () {
      transientMessage = null;
      overlays.remove('TransientMessageOverlay');
    });
  }
}
