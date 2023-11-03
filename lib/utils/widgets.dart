import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world/utils/shared.dart';

class W extends StatelessWidget {
  const W({super.key, required this.color, required this.letter});
  final Color color;
  final String letter;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 1.seconds,
      width: 80,
      margin: const EdgeInsets.only(left: 16),
      height: 80,
      decoration: BoxDecoration(color: color.withOpacity(.3), borderRadius: BorderRadius.circular(5)),
      child: Center(child: Text(letter, style: const TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold))),
    );
  }
}
