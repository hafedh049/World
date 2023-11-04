import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world/drawer.dart';
import 'package:world/utils/methods.dart';
import 'package:world/utils/shared.dart';

class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _WorldState();
}

class _WorldState extends State<World> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  late final AnimationController _menuProgress;
  bool _menuState = false;

  @override
  void initState() {
    _menuProgress = AnimationController(vsync: this, duration: 1.seconds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: load(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return snapshot.hasError
              ? EError()
              : snapshot.connectionState == ConnectionState.waiting
                  ? Wait()
                  : RawKeyboardListener(
                      focusNode: FocusNode(),
                      autofocus: true,
                      onKey: (RawKeyEvent value) => rawKeyboard(value, context),
                      child: Scaffold(
                        drawer: const DDrawer(),
                        key: _drawerKey,
                        body: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 80,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 20),
                                    IconButton(
                                      onPressed: () {
                                        if (!_menuState) {
                                          _menuProgress.forward();
                                          _drawerKey.currentState!.openDrawer();
                                        } else {
                                          _menuProgress.reverse();
                                          _drawerKey.currentState!.closeDrawer();
                                        }
                                        _menuState = !_menuState;
                                      },
                                      icon: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _menuProgress, size: 35),
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
                          ),
                        ),
                      ),
                    );
        });
  }
}
