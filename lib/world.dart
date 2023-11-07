import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:world/drawer.dart';
import 'package:world/error.dart';
import 'package:world/utils/methods.dart';
import 'package:world/utils/shared.dart';
import 'package:world/wait.dart';

class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _WorldState();
}

class _WorldState extends State<World> {
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent value) => rawKeyboard(value, context),
      child: Scaffold(
        drawer: const DDrawer(),
        key: drawerKey,
        body: SingleChildScrollView(
          child: StatefulBuilder(
              key: gameKey,
              builder: (BuildContext context, void Function(void Function()) _) {
                return FutureBuilder<void>(
                    future: load(),
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.hasData && games!.isNotEmpty) {
                        showSnack(context, "NOTE", "See your previous games", ContentType.help);
                      }
                      return snapshot.hasError
                          ? EError(error: snapshot.error.toString())
                          : snapshot.connectionState == ConnectionState.waiting
                              ? const Wait()
                              : Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 80,
                                      child: Row(
                                        children: <Widget>[
                                          const SizedBox(width: 20),
                                          IconButton(
                                            onPressed: () => drawerKey.currentState!.openDrawer(),
                                            icon: const Icon(FontAwesomeIcons.list, size: 25),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: StatefulBuilder(
                                              key: saveStateKey,
                                              builder: (BuildContext context, void Function(void Function()) _) {
                                                return AnimatedOpacity(opacity: save ? 1 : 0, duration: 1000.ms, child: const CircularProgressIndicator(color: white));
                                              },
                                            ),
                                          ),
                                          const Spacer(),
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(text: gameTitle[0], style: const TextStyle(color: white, fontSize: 40, fontWeight: FontWeight.bold)),
                                                TextSpan(text: gameTitle.substring(1).toLowerCase(), style: const TextStyle(color: blue, fontSize: 35, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Divider(color: white.withOpacity(.3), height: 1, thickness: 1, indent: 25, endIndent: 25),
                                    const SizedBox(height: 30),
                                    SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(mainAxisSize: MainAxisSize.min, children: buidGrid())),
                                    const SizedBox(height: 30),
                                    StatefulBuilder(
                                      key: keyboardKey,
                                      builder: (BuildContext context, void Function(void Function()) _) {
                                        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(mainAxisSize: MainAxisSize.min, children: buidKeyboard(context)));
                                      },
                                    ),
                                  ],
                                );
                    });
              }),
        ),
      ),
    );
  }
}
