import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) async {
        if (event is RawKeyDownEvent) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter) || event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
            if (lineIndex == (6 - 1) && columnIndex == magicWord.length) {
              endGame(context);

              rowsStates[lineIndex].currentState!.setState(() => rowRotation = true);
              await Future.delayed(50.ms);
              rowsStates[lineIndex].currentState!.setState(() => rowRotation = false);

              double wait = 0;
              for (int column = 0; column < magicWord.length; column++) {
                await Future.delayed(wait.ms);
                cellsStates[lineIndex - 1][column].currentState!.setState(() {});
                wait += 50;
              }
              keyboardKey.currentState!.setState(() {});

              await Future.wait(<Future<void>>[addKVHive("new", true), addKVHive("gameMatrix", gameMatrix)]);
              lineIndex = 0;
              columnIndex = 0;
            } else if (columnIndex == magicWord.length) {
              for (int letter = 0; letter < magicWord.length; letter++) {
                if (gameMatrix[lineIndex][letter]["key"] == magicWord[letter]) {
                  gameMatrix[lineIndex][letter]["type"] = keyState.elementAt(0);
                  findKey(gameMatrix[lineIndex][letter]["key"])["type"] = keyState.elementAt(0);
                } else if (magicWord.contains(gameMatrix[lineIndex][letter]["key"])) {
                  gameMatrix[lineIndex][letter]["type"] = keyState.elementAt(2);
                  findKey(gameMatrix[lineIndex][letter]["key"])["type"] = keyState.elementAt(2);
                } else {
                  gameMatrix[lineIndex][letter]["type"] = keyState.elementAt(1);
                  findKey(gameMatrix[lineIndex][letter]["key"])["type"] = keyState.elementAt(1);
                }
              }
              lineIndex += 1;
              columnIndex = 0;
              rowsStates[lineIndex - 1].currentState!.setState(() => rowRotation = true);
              await Future.delayed(50.ms);
              rowsStates[lineIndex - 1].currentState!.setState(() => rowRotation = false);

              double wait = 0;
              for (int column = 0; column < magicWord.length; column++) {
                await Future.delayed(wait.ms);
                cellsStates[lineIndex - 1][column].currentState!.setState(() {});
                wait += 50;
              }
              keyboardKey.currentState!.setState(() {});
            }
          } else if (event.isKeyPressed(LogicalKeyboardKey.backspace) || event.isKeyPressed(LogicalKeyboardKey.delete)) {
            if (columnIndex > 0) {
              columnIndex -= 1;
              gameMatrix[lineIndex][columnIndex]["key"] = '';
              cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = true);
              await Future.delayed(50.ms);
              cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = false);
              await addKVHive("lineIndex", lineIndex);
              await addKVHive("columnIndex", columnIndex);
            }
          } else if (event.character != null && allKeys.contains(event.character!.toUpperCase())) {
            if (columnIndex < magicWord.length) {
              gameMatrix[lineIndex][columnIndex]["key"] = event.character!.toUpperCase();
              cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = true);
              await Future.delayed(50.ms);
              cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = false);
              columnIndex += 1;
              await addKVHive("lineIndex", lineIndex);
              await addKVHive("columnIndex", columnIndex);
            }
          }
        }
      },
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
                  return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(mainAxisSize: MainAxisSize.min, children: buidKeyboard()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
