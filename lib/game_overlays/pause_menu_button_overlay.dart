import 'package:flutter/material.dart';

class PauseMenuButtonOverlay extends StatelessWidget {
  const PauseMenuButtonOverlay({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.all(12), // margin from screen edges
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white, // icon color
              padding: const EdgeInsets.all(16), // slightly bigger tap target
              shape: const CircleBorder(),
              elevation: 4, // subtle shadow for better visibility
            ),
            child: const Icon(Icons.menu),
          ),
        ),
      ),
    );
  }
}
