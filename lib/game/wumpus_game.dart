import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/data/world_generator.dart';
import 'package:wumpus_world_flame/game/player_component.dart';
import 'package:wumpus_world_flame/models/room_model.dart';

class WumpusGame extends FlameGame {
  late PlayerComponent player;
  late List<List<RoomModel>> grid;

  static const int gridsize = 4;
  Timer? _perceptTimer;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Initialize a 4x4 grid of rooms
    grid = List.generate(gridsize, (x) {
      return List.generate(gridsize, (y) => RoomModel(x, y));
    });

    // Populate the world with hazards, gold, percepts
    generateWorld(grid);

    player = PlayerComponent(startX: 0, startY: 0);
    add(player);

    grid[0][0].isVisible = true;
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

        // Room background
        if (!room.isVisible) {
          roomPaint.color = Colors.black;
          canvas.drawRect(rect, roomPaint);
          continue; // skip drawing content
        }

        roomPaint.color = const Color(0xFF444444);
        canvas.drawRect(rect, roomPaint);

        // Highlight player position
        if (x == player.gridX && y == player.gridY) {
          roomPaint.color = Colors.greenAccent;
          canvas.drawRect(rect.deflate(2), roomPaint);
        }

        // Draw contents
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
    final playerEmoji = TextPainter(
      text: TextSpan(text: "🧍", style: TextStyle(fontSize: roomSize * 0.5)),
      textDirection: TextDirection.ltr,
    )..layout();

    playerEmoji.paint(
      canvas,
      Offset(
        offsetX + player.gridX * roomSize + roomSize * 0.25,
        offsetY + player.gridY * roomSize + roomSize * 0.15,
      ),
    );
  }

  void movePlayer(int dx, int dy) {
    int newX = player.gridX + dx;
    int newY = player.gridY + dy;

    if (newX < 0 || newX >= gridsize || newY < 0 || newY >= gridsize) {
      debugPrint("Blocked: Wall");
      return;
    }

    player.moveBy(dx, dy);
    RoomModel room = grid[player.gridX][player.gridY];

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
      // Clear and regenerate world
      grid = List.generate(
        gridsize,
        (x) => List.generate(gridsize, (y) => RoomModel(x, y)),
      );
      generateWorld(grid);

      // Reset and safely update player
      if (player.parent != null) remove(player);
      player = PlayerComponent(startX: 0, startY: 0);
      add(player);

      // Reveal the starting room
      grid[0][0].isVisible = true;

      // Resume the game loop
      resumeEngine();
    } catch (e, stacktrace) {
      debugPrint("Game reset failed: $e\n$stacktrace");
    }
  }

  List<String> getCurrentPercepts() {
    if (!isLoaded || grid.isEmpty) return [];
    final room = grid[player.gridX][player.gridY];
    return room.percepts.toList();
  }

  void showPerceptsTemporarily() {
    overlays.remove('PerceptsOverlay');
    overlays.add('PerceptsOverlay');

    _perceptTimer?.cancel(); // Cancel any existing timer
    _perceptTimer = Timer(const Duration(seconds: 3), () {
      overlays.remove('PerceptsOverlay');
    });
  }
}
