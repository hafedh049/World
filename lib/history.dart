import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:world/game_card.dart';
import 'package:world/utils/shared.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(FontAwesomeIcons.chevronLeft, size: 15)),
                const Spacer(),
                Center(
                  child: games != null && games!.isNotEmpty
                      ? SingleChildScrollView(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 20,
                            children: <Widget>[
                              for (final Map<dynamic, dynamic> game in games!) GameCard(data: game, image: Random().nextInt(7) + 1),
                            ],
                          ),
                        )
                      : const Text("No Games Yet.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
