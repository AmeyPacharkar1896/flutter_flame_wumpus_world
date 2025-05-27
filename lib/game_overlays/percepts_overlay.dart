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
      case 'glitter':
        return '✨ Glitter (Gold nearby)';
      default:
        return ''; // or return null and filter it out
    }
  }

  @override
  Widget build(BuildContext context) {
    // translate & filter out any empty strings
    final messages =
        widget.percepts.map(_translate).where((s) => s.isNotEmpty).toList();
    if (messages.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              messages.join('   '),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
