import 'package:world/utils/shared.dart';

class Game {
  String state_ = "INCOMPLETE";

  Map<String, dynamic> magicWord_ = <String, dynamic>{};

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

  Game();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "state": state_,
      "magicWord": magicWord_,
      "lineIndex": lineIndex_,
      "columnIndex": columnIndex_,
      "gameMatrix": gameMatrix_,
      "keyboardMatrix": keyboardMatrix_,
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    var g = Game()
      ..state_ = json["state"] as String
      ..magicWord_ = json["magicWord"].cast<String, dynamic>()
      ..lineIndex_ = json["lineIndex"] as int
      ..columnIndex_ = json["columnIndex"] as int
      ..gameMatrix_ = List.castFrom<List<dynamic>, List<Map<String, dynamic>>>(json["gameMatrix"])
      ..keyboardMatrix_ = List.castFrom<List<dynamic>, List<Map<String, dynamic>>>(json["keyboardMatrix"]);
    print(g);

    return g;
  }
}
