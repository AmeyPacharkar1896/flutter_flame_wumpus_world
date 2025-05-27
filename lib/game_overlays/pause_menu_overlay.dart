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
    return SafeArea(
      child: Center(
        child: Card(
          color: Colors.black87,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Game Paused',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onResume,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Resume'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Restart'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onMainMenu,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Main Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
