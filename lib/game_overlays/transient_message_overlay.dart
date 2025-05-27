import 'dart:async';

import 'package:flutter/material.dart';

class TransientMessageOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onRemove;

  const TransientMessageOverlay({
    Key? key,
    required this.message,
    required this.onRemove,
  }) : super(key: key);

  @override
  _TransientMessageOverlayState createState() =>
      _TransientMessageOverlayState();
}

class _TransientMessageOverlayState extends State<TransientMessageOverlay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onRemove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
