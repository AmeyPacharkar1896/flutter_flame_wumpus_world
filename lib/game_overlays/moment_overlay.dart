import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/game/wumpus_game.dart';

class MovemenentOverlay extends StatelessWidget {
  const MovemenentOverlay({super.key, required this.game});

  final WumpusGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_up, size: 40),
                onPressed: () => game.movePlayer(0, -1),
              ),
              Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_left, size: 40),
                    onPressed: () => game.movePlayer(-1, 0),
                  ),
                  const SizedBox(width: 48),
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_right, size: 40),
                    onPressed: () => game.movePlayer(1, 0),
                  ),
                ],
              ),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: () => game.movePlayer(0, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
