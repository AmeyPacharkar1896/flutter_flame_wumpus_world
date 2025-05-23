import 'package:flutter/material.dart';

class PerceptsOverlay extends StatefulWidget {
  final List<String> percepts;

  const PerceptsOverlay({super.key, required this.percepts});

  @override
  State<PerceptsOverlay> createState() => _PerceptsOverlayState();
}

class _PerceptsOverlayState extends State<PerceptsOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _translate(String percept) {
    switch (percept) {
      case 'breeze':
        return '💨 Breeze (Pit nearby)';
      case 'stench':
        return '🦨 Stench (Wumpus nearby)';
      default:
        return '❓ Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.percepts.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: const EdgeInsets.only(top: 16),
          child: Text(
            widget.percepts.map(_translate).join('   '),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
