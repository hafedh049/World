// ignore_for_file: invalid_use_of_protected_member, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:world/game_model.dart';
import 'package:world/utils/shared.dart';

// open box = create collection
Future<Box<List<dynamic>>> openHiveBox() async {
  if (!Hive.isBoxOpen("games") && !kIsWeb) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  return Hive.openBox("games");
}

Future<void> addKVHive(String key, List<Map<String, dynamic>> value) async => await world!.put(key, value);

Color calculateColor(String type) => type == "UNSELECTED"
    ? white.withOpacity(.1)
    : type == "CORRECT"
        ? green
        : type == "MISPLACED"
            ? yellow
            : dark;

Map<String, dynamic> findKey(String key) {
  return <Map<String, dynamic>>[for (List<Map<String, dynamic>> list in currentGame!.keyboardMatrix_) ...list].firstWhere((Map<String, dynamic> element) => element["key"] == key);
}

List<Widget> buidGrid() {
  List<Widget> grid = <Widget>[];
  for (int indexI = 0; indexI < 6; indexI++) {
    grid.add(
      StatefulBuilder(
          key: rowsStates[indexI],
          builder: (BuildContext context, void Function(void Function()) _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int indexJ = 0; indexJ < cellsSize; indexJ++)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 12),
                    child: StatefulBuilder(
                      key: cellsStates[indexI][indexJ],
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Tooltip(
                          waitDuration: 2.seconds,
                          message: currentGame!.gameMatrix_[indexI][indexJ]["type"],
                          child: AnimatedRotation(
                            duration: 500.ms,
                            turns: currentGame!.rowRotation_ ? 2 * pi : 0,
                            child: AnimatedScale(
                              duration: 100.ms,
                              scale: currentGame!.lineIndex_ == indexI && currentGame!.columnIndex_ == indexJ && currentGame!.cellScale_ ? 1.1 : 1,
                              child: InkWell(
                                onTap: () => true,
                                focusColor: transparent,
                                hoverColor: blue,
                                highlightColor: transparent,
                                splashColor: transparent,
                                child: AnimatedContainer(
                                  duration: 1000.ms,
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: calculateColor(currentGame!.gameMatrix_[indexI][indexJ]["type"]),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: .5, color: currentGame!.gameMatrix_[indexI][indexJ]["key"] == "" ? white.withOpacity(.4) : white.withOpacity(.8)),
                                  ),
                                  child: Center(child: Text(currentGame!.gameMatrix_[indexI][indexJ]["key"], style: const TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }),
    );
  }
  return grid;
}

List<Widget> buidKeyboard(BuildContext context) {
  List<Widget> keyboard = <Widget>[];
  for (int indexI = 0; indexI < 3; indexI++) {
    keyboard.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int indexJ = 0; indexJ < currentGame!.keyboardMatrix_[indexI].length; indexJ++)
            Tooltip(
              waitDuration: 2.seconds,
              message: currentGame!.keyboardMatrix_[indexI][indexJ]["type"],
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: InkWell(
                  focusColor: transparent,
                  hoverColor: blue,
                  highlightColor: transparent,
                  splashColor: transparent,
                  onTap: () async {
                    if (currentGame!.keyboardMatrix_[indexI][indexJ]["key"] == "ENTER") {
                      if (currentGame!.lineIndex_ == (6 - 1) && currentGame!.columnIndex_ == cellsSize) {
                        for (int letter = 0; letter < cellsSize; letter++) {
                          if (currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"] == currentGame!.magicWord_["word"]![letter]) {
                            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(0);
                            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(0);
                          } else if (isDuplicate(letter, currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"]) && currentGame!.magicWord_["word"]!.contains(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])) {
                            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(2);
                            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(2);
                          } else {
                            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(1);
                            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(1);
                          }
                        }
                        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = true);
                        await Future.delayed(50.ms);
                        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = false);

                        double wait = 0;
                        for (int column = 0; column < cellsSize; column++) {
                          await Future.delayed(wait.ms);
                          cellsStates[currentGame!.lineIndex_][column].currentState!.setState(() {});
                          wait += 50;
                        }
                        keyboardKey.currentState!.setState(() {});
                        await update();
                        endGame(context);
                      } else if (currentGame!.columnIndex_ == cellsSize) {
                        for (int letter = 0; letter < cellsSize; letter++) {
                          if (currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"] == currentGame!.magicWord_["word"]![letter]) {
                            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(0);
                            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(0);
                          } else if (currentGame!.magicWord_["word"]!.contains(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])) {
                            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(2);
                            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(2);
                          } else {
                            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(1);
                            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(1);
                          }
                        }

                        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = true);
                        await Future.delayed(50.ms);
                        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = false);

                        double wait = 0;
                        for (int column = 0; column < cellsSize; column++) {
                          await Future.delayed(wait.ms);
                          cellsStates[currentGame!.lineIndex_][column].currentState!.setState(() {});
                          wait += 50;
                        }
                        keyboardKey.currentState!.setState(() {});
                        if (checkEndGame()) {
                          await update();
                          endGame(context);
                          return;
                        }
                        currentGame!.lineIndex_ += 1;
                        currentGame!.columnIndex_ = 0;
                        update();
                      }
                    } else if (currentGame!.keyboardMatrix_[indexI][indexJ]["key"] == "DEL") {
                      if (currentGame!.columnIndex_ > 0) {
                        currentGame!.columnIndex_ -= 1;
                        currentGame!.gameMatrix_[currentGame!.lineIndex_][currentGame!.columnIndex_]["key"] = '';
                        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = true);
                        await Future.delayed(50.ms);
                        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = false);
                      }
                    } else {
                      if (currentGame!.columnIndex_ < cellsSize) {
                        currentGame!.gameMatrix_[currentGame!.lineIndex_][currentGame!.columnIndex_]["key"] = currentGame!.keyboardMatrix_[indexI][indexJ]["key"].toUpperCase();
                        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = true);
                        await Future.delayed(50.ms);
                        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = false);
                        currentGame!.columnIndex_ += 1;
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: 1.seconds,
                    width: currentGame!.keyboardMatrix_[indexI][indexJ]["size"] == 2 ? 80 : 60,
                    height: 60,
                    decoration: BoxDecoration(color: currentGame!.keyboardMatrix_[indexI][indexJ]["key"].length > 1 ? blue : calculateColor(currentGame!.keyboardMatrix_[indexI][indexJ]["type"]), borderRadius: BorderRadius.circular(5)),
                    child: Center(child: Text(currentGame!.keyboardMatrix_[indexI][indexJ]["key"], style: const TextStyle(color: white, fontSize: 20))),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  return keyboard;
}

void rawKeyboard(RawKeyEvent event, BuildContext context) async {
  if (event is RawKeyDownEvent) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter) || event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
      if (currentGame!.lineIndex_ == (6 - 1) && currentGame!.columnIndex_ == cellsSize) {
        for (int letter = 0; letter < cellsSize; letter++) {
          if (currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"] == currentGame!.magicWord_["word"]![letter]) {
            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(0);
            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(0);
          } else if (isDuplicate(letter, currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"]) && currentGame!.magicWord_["word"]!.contains(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])) {
            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(2);
            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(2);
          } else {
            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(1);
            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(1);
          }
        }
        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = true);
        await Future.delayed(50.ms);
        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = false);

        double wait = 0;
        for (int column = 0; column < cellsSize; column++) {
          await Future.delayed(wait.ms);
          cellsStates[currentGame!.lineIndex_][column].currentState!.setState(() {});
          wait += 50;
        }
        keyboardKey.currentState!.setState(() {});
        await update();
        endGame(context);
      } else if (currentGame!.columnIndex_ == cellsSize) {
        for (int letter = 0; letter < cellsSize; letter++) {
          if (currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"] == currentGame!.magicWord_["word"]![letter]) {
            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(0);
            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(0);
          } else if (isDuplicate(letter, currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"]) && currentGame!.magicWord_["word"]!.contains(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])) {
            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(2);
            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(2);
          } else {
            currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["type"] = keyState.elementAt(1);
            findKey(currentGame!.gameMatrix_[currentGame!.lineIndex_][letter]["key"])["type"] = keyState.elementAt(1);
          }
        }

        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = true);
        await Future.delayed(50.ms);
        rowsStates[currentGame!.lineIndex_].currentState!.setState(() => currentGame!.rowRotation_ = false);

        double wait = 0;
        for (int column = 0; column < cellsSize; column++) {
          await Future.delayed(wait.ms);
          cellsStates[currentGame!.lineIndex_][column].currentState!.setState(() {});
          wait += 50;
        }
        keyboardKey.currentState!.setState(() {});

        if (checkEndGame()) {
          await update();
          endGame(context);
          return;
        }

        currentGame!.lineIndex_ += 1;
        currentGame!.columnIndex_ = 0;
        update();
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.backspace) || event.isKeyPressed(LogicalKeyboardKey.delete)) {
      if (currentGame!.columnIndex_ > 0) {
        currentGame!.columnIndex_ -= 1;
        currentGame!.gameMatrix_[currentGame!.lineIndex_][currentGame!.columnIndex_]["key"] = '';
        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = true);
        await Future.delayed(50.ms);
        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = false);
      }
    } else if (event.character != null && allKeys.contains(event.character!.toUpperCase())) {
      if (currentGame!.columnIndex_ < cellsSize) {
        currentGame!.gameMatrix_[currentGame!.lineIndex_][currentGame!.columnIndex_]["key"] = event.character!.toUpperCase();
        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = true);
        await Future.delayed(50.ms);
        cellsStates[currentGame!.lineIndex_][currentGame!.columnIndex_].currentState!.setState(() => currentGame!.cellScale_ = false);
        currentGame!.columnIndex_ += 1;
      }
    }
  }
}

bool isDuplicate(int index, String key) {
  List<String> keys = currentGame!.gameMatrix_[currentGame!.lineIndex_].map((Map<String, dynamic> e) => (e["key"] as String)).toList();
  return !(index > keys.indexOf(key));
}

bool checkEndGame() {
  for (final Map<String, dynamic> entry in currentGame!.gameMatrix_[currentGame!.lineIndex_]) {
    if (entry["type"] != "CORRECT") {
      return false;
    }
  }
  return true;
}

int calculateGuessDistribution(int rowIndex) {
  int sum = 0;
  for (final Map<String, dynamic> entry in currentGame!.gameMatrix_[rowIndex]) {
    if (entry["type"] == "CORRECT") {
      sum += 1;
    }
  }
  return sum;
}

int totalPlayed() {
  return games == null ? 0 : games!.length;
}

int winPercentage() {
  return games == null ? 0 : (games!.where((dynamic element) => element["state"] == "WIN").length / totalPlayed() * 100).toInt();
}

int currentStreak() {
  if (games == null || games!.isEmpty) {
    return 0;
  } else {
    int count = 0;
    List clone = games!.reversed.toList();
    for (dynamic item in clone) {
      if (item["state"] == "WIN") {
        count += 1;
      } else {
        break;
      }
    }
    return count;
  }
}

int longuestStreak() {
  if (games == null || games!.isEmpty) {
    return 0;
  } else {
    int count = 0;
    int maxCount = 0;
    for (dynamic item in games!) {
      if (item["state"] == "WIN") {
        count += 1;
      } else {
        count = 0;
      }
      if (count > maxCount) {
        maxCount = count;
      }
    }
    return count;
  }
}

void endGame(BuildContext context) async {
  endGameAnalytics[0]["value"] = "${totalPlayed()}";
  endGameAnalytics[1]["value"] = "${winPercentage()}";
  endGameAnalytics[2]["value"] = "${currentStreak()}";
  endGameAnalytics[3]["value"] = "${longuestStreak()}";

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Container(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text("STATISTICS", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final Map<String, String> entry in endGameAnalytics)
                Container(
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    children: <Widget>[
                      Text(entry["value"]!, style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 35)),
                      const SizedBox(height: 5),
                      Text(entry["text"]!, textAlign: TextAlign.center, style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("GUESS DISTRIBUTION", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          for (int index = 0; index < 6; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text((index + 1).toString(), style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 5),
                  Container(padding: const EdgeInsets.all(2), color: blue.withOpacity(.6), child: Text(calculateGuessDistribution(index).toString(), style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14))),
                ],
              ),
            ),
        ],
      ),
    ),
  ).then((void value) async => gameKey.currentState!.setState(() {}));
}

Future<Map<String, dynamic>> getMagicWord() async {
  return (json.decode(await rootBundle.loadString("assets/words_$cellsSize.json")))[Random().nextInt(4287)].cast<String, String>();
}

Future<void> load() async {
  world = await openHiveBox();

  games = world!.get("games");
  if (games == null || games!.isEmpty || games!.last["state"] != "INCOMPLETE") {
    currentGame = Game();
    currentGame!.magicWord_ = await getMagicWord();
  } else {
    currentGame = Game.fromJson(games!.last.cast<String, dynamic>());
  }
}

Future<void> update() async {
  if (games == null || games!.isEmpty) {
    games = <Map<String, dynamic>>[currentGame!.toJson()];
  } else if (games!.last["state"] == "INCOMPLETE") {
    currentGame!.state_ = checkEndGame()
        ? "WIN"
        : currentGame!.lineIndex_ == 5 && currentGame!.columnIndex_ == cellsSize
            ? "LOSS"
            : "INCOMPLETE";
    games!.last = currentGame!.toJson();
  } else {
    currentGame!.state_ = checkEndGame()
        ? "WIN"
        : currentGame!.lineIndex_ == 5 && currentGame!.columnIndex_ == cellsSize
            ? "LOSS"
            : "INCOMPLETE";
    games!.add(currentGame!.toJson());
  }
  world!.put("games", games!);
  saveStateKey.currentState!.setState(() => save = true);
  await Future.delayed(1000.ms);
  saveStateKey.currentState!.setState(() => save = false);
}
