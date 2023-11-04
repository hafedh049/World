// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

String theme = "dark";
String language = "en";
final List<String> supportedLanguages = <String>["en", "fr", "ar"];
const String gameTitle = "WORLD";
final List<List<dynamic>> gameLetters = gameTitle.split(r"").map((String e) => <dynamic>[e, white]).toList();
Box? world;
const Color blue = Color.fromARGB(255, 0, 146, 175);
const Color white = Color.fromARGB(255, 229, 229, 229);
const Color transparent = Colors.transparent;
const Color green = Colors.green;
const Color dark = Colors.black87;
Color yellow = Colors.amber;

String magicWord = "HELLO";

int lineIndex = 0;
int columnIndex = 0;

Set<String> keyState = <String>{"CORRECT", "INCORRECT", "MISPLACED", "UNSELECTED"};

List<List<Map<String, dynamic>>> gameMatrix = List<List<Map<String, dynamic>>>.generate(6, (int index) => List<Map<String, dynamic>>.generate(magicWord.length, (int _) => <String, dynamic>{"key": '', "type": keyState.lastOrNull}));

List<List<Map<String, dynamic>>> keyboardMatrix = <List<Map<String, dynamic>>>[
  <Map<String, dynamic>>[
    <String, dynamic>{"key": 'Q', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'W', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'E', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'R', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'T', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'Y', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'U', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'I', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'O', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'P', "type": keyState.lastOrNull},
  ],
  <Map<String, dynamic>>[
    <String, dynamic>{"key": 'A', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'S', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'D', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'F', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'G', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'H', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'J', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'K', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'L', "type": keyState.lastOrNull},
  ],
  <Map<String, dynamic>>[
    <String, dynamic>{"key": 'ENTER', "size": 2, "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'Z', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'X', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'C', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'V', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'B', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'N', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'M', "type": keyState.lastOrNull},
    <String, dynamic>{"key": 'DEL', "size": 2, "type": keyState.lastOrNull},
  ],
];

final List<String> allKeys = <String>[
  for (final List<Map<String, dynamic>> item in keyboardMatrix)
    for (final Map<String, dynamic> entry in item) entry["key"]
];

final List<List<GlobalKey<State>>> cellsStates = List<List<GlobalKey<State>>>.generate(6, (int _) => List<GlobalKey<State>>.generate(magicWord.length, (int __) => GlobalKey<State>()));
final List<GlobalKey<State>> rowsStates = List<GlobalKey<State>>.generate(6, (int _) => GlobalKey<State>());

final GlobalKey<State> keyboardKey = GlobalKey<State>();

bool cellScale = false;
bool rowRotation = false;

String selectedItem = "Home";

final List<Map<String, dynamic>> menu = <Map<String, dynamic>>[
  <String, dynamic>{"state": false, "item": "Home", "onTap": () {}, "icon": FontAwesomeIcons.gamepad},
  <String, dynamic>{"state": false, "item": "History", "onTap": () {}, "icon": FontAwesomeIcons.clockRotateLeft},
  <String, dynamic>{"state": false, "item": "Analytics", "onTap": () {}, "icon": FontAwesomeIcons.calculator},
  <String, dynamic>{"state": false, "item": "About Me", "onTap": () {}, "icon": FontAwesomeIcons.medal},
  <String, dynamic>{"state": false, "item": "Version 1.0.0", "onTap": () {}, "icon": FontAwesomeIcons.cubes},
];

//add animation effects to the cells