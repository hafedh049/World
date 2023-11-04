// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:world/utils/shared.dart';

Future<Box> openHiveBox(String box) async {
  if (!Hive.isBoxOpen(box) && !kIsWeb) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  return Hive.openBox(box);
}

Future<void> addKVHive(String key, dynamic value) async => await world!.put(key, value);

Future<void> removeEntryHive(String key) async => await world!.delete(key);

Color calculateColor(String type) {
  return type == "UNSELECTED"
      ? white.withOpacity(.1)
      : type == "CORRECT"
          ? green
          : type == "MISPLACED"
              ? yellow
              : dark;
}

Map<String, dynamic> findKey(String key) {
  return <Map<String, dynamic>>[for (List<Map<String, dynamic>> list in keyboardMatrix) ...list].firstWhere((Map<String, dynamic> element) => element["key"] == key);
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
                for (int indexJ = 0; indexJ < magicWord.length; indexJ++)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 12),
                    child: StatefulBuilder(
                      key: cellsStates[indexI][indexJ],
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Tooltip(
                          waitDuration: 2.seconds,
                          message: gameMatrix[indexI][indexJ]["type"],
                          child: AnimatedRotation(
                            duration: 500.ms,
                            turns: rowRotation ? 2 * pi : 0,
                            child: AnimatedScale(
                              duration: 100.ms,
                              scale: lineIndex == indexI && columnIndex == indexJ && cellScale ? 1.1 : 1,
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
                                    color: calculateColor(gameMatrix[indexI][indexJ]["type"]),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: .5, color: gameMatrix[indexI][indexJ]["key"] == "" ? white.withOpacity(.4) : white.withOpacity(.8)),
                                  ),
                                  child: Center(child: Text(gameMatrix[indexI][indexJ]["key"], style: const TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold))),
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

List<Widget> buidKeyboard() {
  List<Widget> keyboard = <Widget>[];
  for (int indexI = 0; indexI < keyboardMatrix.length; indexI++) {
    keyboard.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int indexJ = 0; indexJ < keyboardMatrix[indexI].length; indexJ++)
            Tooltip(
              waitDuration: 2.seconds,
              message: keyboardMatrix[indexI][indexJ]["type"],
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: InkWell(
                  focusColor: transparent,
                  hoverColor: blue,
                  highlightColor: transparent,
                  splashColor: transparent,
                  onTap: () async {
                    if (keyboardMatrix[indexI][indexJ]["key"] == "ENTER") {
                      if (lineIndex == (6 - 1) && columnIndex == magicWord.length) {
                        // END OF GAME
                        await Future.wait(<Future<void>>[addKVHive("new", true), addKVHive("gameMatrix", gameMatrix)]);
                        lineIndex = 0;
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
                    } else if (keyboardMatrix[indexI][indexJ]["key"] == "DEL") {
                      if (columnIndex > 0) {
                        columnIndex -= 1;
                        gameMatrix[lineIndex][columnIndex]["key"] = '';
                        cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = true);
                        await Future.delayed(50.ms);
                        cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = false);
                        await addKVHive("lineIndex", lineIndex);
                        await addKVHive("columnIndex", columnIndex);
                      }
                    } else {
                      if (columnIndex < magicWord.length) {
                        gameMatrix[lineIndex][columnIndex]["key"] = keyboardMatrix[indexI][indexJ]["key"].toUpperCase();
                        cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = true);
                        await Future.delayed(50.ms);
                        cellsStates[lineIndex][columnIndex].currentState!.setState(() => cellScale = false);
                        columnIndex += 1;
                        await addKVHive("lineIndex", lineIndex);
                        await addKVHive("columnIndex", columnIndex);
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: 1.seconds,
                    width: keyboardMatrix[indexI][indexJ]["size"] == 2 ? 80 : 60,
                    height: 60,
                    decoration: BoxDecoration(color: keyboardMatrix[indexI][indexJ]["key"].length > 1 ? blue : calculateColor(keyboardMatrix[indexI][indexJ]["type"]), borderRadius: BorderRadius.circular(5)),
                    child: Center(child: Text(keyboardMatrix[indexI][indexJ]["key"], style: const TextStyle(color: white, fontSize: 20))),
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

int calculateGuessDistribution(int rowIndex) {
  int sum = 0;
  for (final Map<String, dynamic> entry in gameMatrix[rowIndex]) {
    if (entry["type"] == "CORRECT") {
      sum += 1;
    }
  }
  return sum;
}

void endGame(BuildContext context) async {
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
                      Text(entry["text"]!, style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14)),
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
  );
}
