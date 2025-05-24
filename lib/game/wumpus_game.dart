import 'dart:async';

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

  static const int gridsize = 4;
  Timer? _perceptTimer;

  ArrowComponent? activeArrow;

  bool isGameLoaded = false; // flag to track loading

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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
    final double offsetY = (size.y - roomSize * gridSize) / 2;

    final Paint roomPaint = Paint();

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final room = grid[x][y];
        final double left = offsetX + x * roomSize;
        final double top = offsetY + y * roomSize;
        final Rect rect = Rect.fromLTWH(left, top, roomSize, roomSize);

        if (!room.isVisible) {
          roomPaint.color = Colors.black;
          canvas.drawRect(rect, roomPaint);
          continue;
        }

        roomPaint.color = const Color(0xFF444444);
        canvas.drawRect(rect, roomPaint);

        if (player != null && x == player!.gridX && y == player!.gridY) {
          roomPaint.color = Colors.greenAccent;
          canvas.drawRect(rect.deflate(2), roomPaint);
        }

        TextPainter tp(String emoji) => TextPainter(
          text: TextSpan(
            text: emoji,
            style: TextStyle(fontSize: roomSize * 0.3),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        double offsetEmojiX = left + 4;
        double offsetEmojiY = top + 4;

        if (room.hasGold) {
          tp("💰").paint(canvas, Offset(offsetEmojiX, offsetEmojiY));
          offsetEmojiY += roomSize * 0.25;
        }
        if (room.hasPit) {
          tp("🕳️").paint(canvas, Offset(offsetEmojiX, offsetEmojiY));
          offsetEmojiY += roomSize * 0.25;
        }
        if (room.hasWumpus) {
          tp("👹").paint(canvas, Offset(offsetEmojiX, offsetEmojiY));
          offsetEmojiY += roomSize * 0.25;
        }

        for (String percept in room.percepts) {
          String symbol =
              percept == "breeze"
                  ? "💨"
                  : percept == "stench"
                  ? "🦨"
                  : "❓";
          tp(symbol).paint(canvas, Offset(offsetEmojiX, offsetEmojiY));
          offsetEmojiY += roomSize * 0.2;
        }
      }
    }

    // Draw player icon
    if (player != null) {
      final playerEmoji = TextPainter(
        text: TextSpan(text: "🧍", style: TextStyle(fontSize: roomSize * 0.5)),
        textDirection: TextDirection.ltr,
      )..layout();

      playerEmoji.paint(
        canvas,
        Offset(
          offsetX + player!.gridX * roomSize + roomSize * 0.25,
          offsetY + player!.gridY * roomSize + roomSize * 0.15,
        ),
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
    overlays.remove('PerceptsOverlay');
    overlays.add('PerceptsOverlay');

    _perceptTimer?.cancel();
    _perceptTimer = Timer(const Duration(seconds: 3), () {
      overlays.remove('PerceptsOverlay');
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
