import 'package:flutter/material.dart';

class ArrowOverlay extends StatelessWidget {
  const ArrowOverlay({super.key, required this.arrowLeft});

  final int arrowLeft;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        color: Colors.black54,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < arrowLeft; i++)
              const Icon(Icons.arrow_upward_sharp, color: Colors.orangeAccent),
          ],
        ),
      ),
    );
  }
}
