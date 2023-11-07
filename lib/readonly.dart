import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:world/utils/methods.dart';
import 'package:world/utils/shared.dart';

class ReadOnly extends StatefulWidget {
  const ReadOnly({super.key, required this.data});
  final Map<dynamic, dynamic> data;
  @override
  State<ReadOnly> createState() => _ReadOnlyState();
}

class _ReadOnlyState extends State<ReadOnly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) _) {
            return Column(
              children: <Widget>[
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesomeIcons.chevronLeft, size: 25)),
                const SizedBox(height: 30),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (int indexI = 0; indexI < 6; indexI++)
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
                                        message: widget.data["gameMatrix"][indexI][indexJ]["type"],
                                        child: InkWell(
                                          onTap: () => true,
                                          focusColor: transparent,
                                          hoverColor: blue,
                                          highlightColor: transparent,
                                          splashColor: transparent,
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: calculateColor(widget.data["gameMatrix"][indexI][indexJ]["type"]),
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(width: .5, color: widget.data["gameMatrix"][indexI][indexJ]["key"] == "" ? white.withOpacity(.4) : white.withOpacity(.8)),
                                            ),
                                            child: Center(child: Text(widget.data["gameMatrix"][indexI][indexJ]["key"], style: const TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold))),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
