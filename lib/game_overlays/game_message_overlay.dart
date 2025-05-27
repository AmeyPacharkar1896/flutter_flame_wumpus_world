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
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.08; // roughly 32px on 400 width screens

    return SafeArea(
      child: Center(
        child: Card(
          color: Colors.black87,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, // full width button inside card
                  child: ElevatedButton(
                    onPressed: onReset,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Restart",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
