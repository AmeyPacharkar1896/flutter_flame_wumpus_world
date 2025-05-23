import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/overlay_builder.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayBuilder(),
    );
  }
}
