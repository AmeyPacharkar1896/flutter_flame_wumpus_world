import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform; // For detecting mobile platforms
import 'package:flutter/foundation.dart' show kIsWeb; // Detect web

class MainMenuOverlay extends StatelessWidget {
  const MainMenuOverlay({super.key, required this.onStart});

  final VoidCallback onStart;

  void _handleExit(BuildContext context) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      SystemNavigator.pop(); // Exit on mobile
    } else {
      // Show farewell message for web/desktop
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Thanks for playing!"),
          content: const Text("You're on a platform where the app can't be closed programmatically."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.black87,
        margin: const EdgeInsets.all(40),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Wumpus World',
                style: TextStyle(color: Colors.white, fontSize: 36),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onStart,
                child: const Text('Start Game'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _handleExit(context),
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
