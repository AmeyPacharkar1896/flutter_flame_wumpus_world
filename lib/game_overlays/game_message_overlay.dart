import 'package:flutter/material.dart';

class GameMessageOverlay extends StatelessWidget {
  const GameMessageOverlay({
    super.key,
    required this.message,
    required this.onReset,
  });

  final String message;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.black87,
        margin: const EdgeInsets.all(30),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: onReset, child: const Text("Restart")),
            ],
          ),
        ),
      ),
    );
  }
}
