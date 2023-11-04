// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:world/game_model.dart';

String theme = "dark";
String language = "en";
final List<String> supportedLanguages = <String>["en", "fr", "ar"];
const String gameTitle = "WORLD";
final List<List<dynamic>> gameLetters = gameTitle.split(r"").map((String e) => <dynamic>[e, white]).toList();

const Color blue = Color.fromARGB(255, 0, 146, 175);
const Color white = Color.fromARGB(255, 229, 229, 229);
const Color transparent = Colors.transparent;
const Color green = Colors.green;
const Color dark = Colors.black87;
Color yellow = Colors.amber;

int cellsSize = 5;

Set<String> keyState = <String>{"CORRECT", "INCORRECT", "MISPLACED", "UNSELECTED"};

String selectedItem = "Home";

final List<Map<String, dynamic>> menu = <Map<String, dynamic>>[
  <String, dynamic>{"state": false, "item": "Home", "onTap": () {}, "icon": FontAwesomeIcons.gamepad},
  <String, dynamic>{"state": false, "item": "History", "onTap": () {}, "icon": FontAwesomeIcons.clockRotateLeft},
  <String, dynamic>{"state": false, "item": "Analytics", "onTap": () {}, "icon": FontAwesomeIcons.calculator},
  <String, dynamic>{"state": false, "item": "About Me", "onTap": () {}, "icon": FontAwesomeIcons.medal},
  <String, dynamic>{"state": false, "item": "Version 1.0.0", "onTap": () {}, "icon": FontAwesomeIcons.cubes},
];

Box? world;
List<Map<String, dynamic>>? games = <Map<String, dynamic>>[];
Game? currentGame;

final List<List<GlobalKey<State>>> cellsStates = List<List<GlobalKey<State>>>.generate(6, (int _) => List<GlobalKey<State>>.generate(cellsSize, (int __) => GlobalKey<State>()));
final List<GlobalKey<State>> rowsStates = List<GlobalKey<State>>.generate(6, (int _) => GlobalKey<State>());

final GlobalKey<State> keyboardKey = GlobalKey<State>();

final List<String> allKeys = <String>[
  for (final List<Map<String, dynamic>> item in Game().keyboardMatrix_)
    for (final Map<String, dynamic> entry in item) entry["key"]
];

//add animation effects to the cells