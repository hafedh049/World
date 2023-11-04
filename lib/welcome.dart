import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world/utils/shared.dart';
import 'package:world/utils/widgets.dart';
import 'package:world/world.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  final GlobalKey<State> _wordsKey = GlobalKey<State>();
  late final Timer? _timer;
  int _iter = 0;
  @override
  void initState() {
    _timer = Timer.periodic(
      700.ms,
      (Timer timer) {
        if (_iter < gameLetters.length) {
          _wordsKey.currentState!.setState(() => gameLetters[_iter++][1] = blue);
        } else {
          _timer!.cancel();
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const World()));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StatefulBuilder(
              key: _wordsKey,
              builder: (context, snapshot) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [for (final List<dynamic> entry in gameLetters) W(color: entry[1], letter: entry[0])],
                );
              },
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: blue),
          ],
        ),
      ),
    );
  }
}
