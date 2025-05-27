import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ArrowOverlay extends StatelessWidget {
  const ArrowOverlay({super.key, required this.arrowLeft, required this.arrow});

  final int arrowLeft;
  final Sprite arrow;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize =
        screenWidth *
        0.08; // responsive icon size (e.g., ~32px on 400px screen)

    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(arrowLeft, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: RawImage(
                  image: arrow.image,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
