// PauseMenuOverlay.dart
import 'package:flutter/material.dart';

class PauseMenuOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;

  const PauseMenuOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.black87,
        margin: const EdgeInsets.all(30),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Paused',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: onResume, child: const Text('Resume')),
              ElevatedButton(
                onPressed: onRestart,
                child: const Text('Restart'),
              ),
              ElevatedButton(
                onPressed: onMainMenu,
                child: const Text('Main Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
