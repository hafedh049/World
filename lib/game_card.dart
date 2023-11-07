import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world/utils/shared.dart';

class GameCard extends StatefulWidget {
  const GameCard({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 500.ms,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/${Random().nextInt(7) + 1}.png"), fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: white.withOpacity(.3), borderRadius: BorderRadius.circular(2)),
            ),
          ],
        ),
      ),
    );
  }
}
