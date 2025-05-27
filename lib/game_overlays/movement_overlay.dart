import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/game/wumpus_game.dart';
import 'package:wumpus_world_flame/utils/directions_util.dart';

class MovementOverlay extends StatelessWidget {
  const MovementOverlay({super.key, required this.game});

  final WumpusGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IntrinsicWidth(
            // ensures no hard overflow
            child: Row(
              children: [
                // Shoot Arrow buttons Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Shoot Arrow:',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.none,
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
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.orangeAccent,
                          onPressed: () => game.shootArrow(Direction.left),
                        ),
                        const SizedBox(width: 48),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          color: Colors.orangeAccent,
                          onPressed: () => game.shootArrow(Direction.right),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          color: Colors.orangeAccent,
                          onPressed: () => game.shootArrow(Direction.down),
                        ),
                      ],
                    ),
                  ],
                ),
                // Movement buttons Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Movement',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up, size: 40),
                      color: Colors.white,
                      onPressed: () => game.movePlayer(0, -1),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left, size: 40),
                          color: Colors.white,
                          onPressed: () => game.movePlayer(-1, 0),
                        ),
                        const SizedBox(width: 48),
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_right,
                            size: 40,
                          ),
                          color: Colors.white,
                          onPressed: () => game.movePlayer(1, 0),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, size: 40),
                      color: Colors.white,
                      onPressed: () => game.movePlayer(0, 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
