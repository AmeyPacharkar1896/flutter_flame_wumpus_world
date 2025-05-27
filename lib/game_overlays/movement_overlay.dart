import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/game/wumpus_game.dart';
import 'package:wumpus_world_flame/utils/directions_util.dart'; // import Direction here

class MovementOverlay extends StatelessWidget {
  const MovementOverlay({super.key, required this.game});

  final WumpusGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shoot arrow label
          Column(
            children: [
              const Text(
                'Shoot Arrow:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    color: Colors.orangeAccent,
                    onPressed: () => game.shootArrow(Direction.up),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: Colors.orangeAccent,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => game.shootArrow(Direction.left),
                  ),
                  const SizedBox(width: 48),
                  IconButton(
                    color: Colors.orangeAccent,
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => game.shootArrow(Direction.right),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: Colors.orangeAccent,
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () => game.shootArrow(Direction.down),
                  ),
                ],
              ),
            ],
          ),

          // const SizedBox(height: 24),
          // Movement buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'Movement',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
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
                    icon: const Icon(Icons.keyboard_arrow_down, size: 40),
                    onPressed: () => game.movePlayer(0, 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
