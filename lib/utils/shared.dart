// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

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
List<Map<String, dynamic>> games = <Map<String, dynamic>>[];
Game? currentGame;

final List<List<GlobalKey<State>>> cellsStates = List<List<GlobalKey<State>>>.generate(6, (int _) => List<GlobalKey<State>>.generate(cellsSize, (int __) => GlobalKey<State>()));
final List<GlobalKey<State>> rowsStates = List<GlobalKey<State>>.generate(6, (int _) => GlobalKey<State>());

final GlobalKey<State> keyboardKey = GlobalKey<State>();

final List<String> allKeys = <String>[
  for (final List<Map<String, dynamic>> item in Game().keyboardMatrix_)
    for (final Map<String, dynamic> entry in item) entry["key"]
];

class Game {
  String state_ = "INCOMPLETE";

  Map<String, String> magicWord_ = <String, String>{};

  int lineIndex_ = 0;
  int columnIndex_ = 0;

  List<List<Map<String, dynamic>>> gameMatrix_ = List<List<Map<String, dynamic>>>.generate(6, (int index) => List<Map<String, dynamic>>.generate(cellsSize, (int _) => <String, dynamic>{"key": '', "type": keyState.lastOrNull}));

  List<List<Map<String, dynamic>>> keyboardMatrix_ = <List<Map<String, dynamic>>>[
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

  bool cellScale_ = false;
  bool rowRotation_ = false;

  List<Map<String, String>> endGameAnalytics_ = <Map<String, String>>[
    <String, String>{"value": "0", "text": "Played"},
    <String, String>{"value": "0", "text": "Win %"},
    <String, String>{"value": "0", "text": "Current\nStreak"},
    <String, String>{"value": "0", "text": "Max Streak"},
  ];

  Game();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "state": state_,
      "magicWord": magicWord_,
      "lineIndex": lineIndex_,
      "columnIndex": columnIndex_,
      "gameMatrix": gameMatrix_,
      "keyboardMatrix": keyboardMatrix_,
      "endGameAnalytics": endGameAnalytics_,
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game()
      ..state_ = json["state"] as String
      ..magicWord_ = json["magicWord"] as Map<String, String>
      ..lineIndex_ = json["lineIndex"] as int
      ..columnIndex_ = json["columnIndex"] as int
      ..gameMatrix_ = json["gameMatrix"] as List<List<Map<String, dynamic>>>
      ..keyboardMatrix_ = json["keyboardMatrix"] as List<List<Map<String, dynamic>>>;
  }
}

//add animation effects to the cells