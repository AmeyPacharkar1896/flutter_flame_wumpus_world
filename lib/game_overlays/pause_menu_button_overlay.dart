import 'package:flutter/material.dart';

class PauseMenuButtonOverlay extends StatelessWidget {
  const PauseMenuButtonOverlay({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Icon(Icons.menu),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white, // icon color
          padding: const EdgeInsets.all(12),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
